import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';

// =============================================================================
// VR GAZE SYSTEM — Riscrittura completa
//
// Architettura:
// 1. VrGazeController  — gestisce giroscopio (dt reale) e dwell timer
// 2. VrGazeScope       — InheritedWidget che condivide il controller
// 3. VrGazeOverlay     — wrapper occhio VR che:
//      a) disegna il reticle centrato sulla PROPRIA vista occhio locale
//      b) aggiorna reticleGlobalPosition nel controller (solo isActive=true)
// 4. VrGazableButton   — pulsante con hit-test basato su reticleGlobalPosition
//      → Elimina MediaQuery.size dal calcolo, risolve il bug di sfasamento
// =============================================================================

// =============================================================================
// VrGazeController
// =============================================================================

class VrGazeController extends ChangeNotifier {
  /// Offset del reticle relativo al centro della propria vista occhio (px)
  Offset _reticleOffset = Offset.zero;
  Offset get reticleOffset => _reticleOffset;

  /// Posizione GLOBALE del reticle — aggiornata dall'overlay isActive=true
  /// basandosi sulla sua RenderBox reale, non su MediaQuery.
  Offset? _reticleGlobalPosition;
  Offset? get reticleGlobalPosition => _reticleGlobalPosition;

  double _dwellProgress = 0.0;
  double get dwellProgress => _dwellProgress;

  String? _activeTargetId;
  String? get activeTargetId => _activeTargetId;

  final double sensitivity;
  final Duration dwellTime;
  final double maxOffset;

  StreamSubscription<GyroscopeEvent>? _gyroSub;
  Timer? _dwellTimer;
  VoidCallback? _pendingAction;
  DateTime? _dwellStartTime;
  DateTime? _lastGyroTime; // per calcolo dt reale

  VrGazeController({
    this.sensitivity = 220.0,
    this.dwellTime = const Duration(seconds: 2),
    this.maxOffset = 140.0,
  });

  void start() {
    _reticleOffset = Offset.zero;
    _targetOffset = Offset.zero;
    _reticleGlobalPosition = null;
    _dwellProgress = 0.0;
    _activeTargetId = null;
    _lastGyroTime = null;

    _gyroSub = gyroscopeEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen(_onGyroEvent, onError: (_) {});
  }

  void stop() {
    _gyroSub?.cancel();
    _gyroSub = null;
    _dwellTimer?.cancel();
    _dwellTimer = null;
    _reticleOffset = Offset.zero;
    _targetOffset = Offset.zero;
    _reticleGlobalPosition = null;
    _dwellProgress = 0.0;
    _activeTargetId = null;
    _lastGyroTime = null;
  }

  void recenter() {
    _reticleOffset = Offset.zero;
    _targetOffset = Offset.zero;
    _dwellProgress = 0.0;
    _activeTargetId = null;
    notifyListeners();
  }

  /// Chiamato dall'overlay [isActive=true] — aggiorna la posizione globale
  /// del reticle basandosi sulla sua RenderBox fisica, non su MediaQuery.
  /// Il listener dell'overlay viene registrato PRIMA dei bottoni, quindi
  /// quando i bottoni ricevono la notifica il valore è già aggiornato.
  void updateReticleGlobalPosition(Offset globalPos) {
    _reticleGlobalPosition = globalPos;
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  Offset _targetOffset = Offset.zero;

  void _onGyroEvent(GyroscopeEvent event) {
    // dt calcolato dal tempo REALE tra eventi (non il fisso 16ms)
    final now = DateTime.now();
    final dt = _lastGyroTime != null
        ? (now.difference(_lastGyroTime!).inMicroseconds / 1000000.0).clamp(
            0.004,
            0.050,
          )
        : 0.016;
    _lastGyroTime = now;

    // Telefono LANDSCAPE nel visore Cardboard:
    // • Yaw  (testa sx/dx) → asse X fisico del telefono → event.x
    // • Pitch (testa su/giù) → asse Y fisico del telefono → event.y
    final dx = -event.x * sensitivity * dt;
    final dy = event.y * sensitivity * dt;

    final tx = (_targetOffset.dx + dx).clamp(-maxOffset, maxOffset);
    final ty = (_targetOffset.dy + dy).clamp(-maxOffset, maxOffset);
    _targetOffset = Offset(tx, ty);

    // Filtro Passa-Basso (Lerp) per rendere il puntatore ESTREMAMENTE fluido
    final double smoothFactor = (12.0 * dt).clamp(0.0, 1.0);
    final currentX = _reticleOffset.dx;
    final currentY = _reticleOffset.dy;

    _reticleOffset = Offset(
      currentX + (_targetOffset.dx - currentX) * smoothFactor,
      currentY + (_targetOffset.dy - currentY) * smoothFactor,
    );

    notifyListeners();
  }

  void onGazeEnter(String targetId, VoidCallback action) {
    if (_activeTargetId == targetId) return;
    _cancelDwell();
    _activeTargetId = targetId;
    _pendingAction = action;
    _dwellStartTime = DateTime.now();

    _dwellTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_dwellStartTime == null) return;
      final elapsed = DateTime.now().difference(_dwellStartTime!);
      _dwellProgress = (elapsed.inMilliseconds / dwellTime.inMilliseconds)
          .clamp(0.0, 1.0);
      notifyListeners();

      if (_dwellProgress >= 1.0) {
        timer.cancel();
        final cb = _pendingAction;
        _cancelDwell();
        cb?.call();
      }
    });

    notifyListeners();
  }

  void onGazeExit(String targetId) {
    if (_activeTargetId != targetId) return;
    _cancelDwell();
  }

  void _cancelDwell() {
    _dwellTimer?.cancel();
    _dwellTimer = null;
    _activeTargetId = null;
    _pendingAction = null;
    _dwellStartTime = null;
    _dwellProgress = 0.0;
    notifyListeners();
  }
}

// =============================================================================
// VrGazeScope — InheritedWidget che condivide il controller nell'albero
// =============================================================================

class VrGazeScope extends StatefulWidget {
  final Widget child;
  final VrGazeController controller;

  const VrGazeScope({super.key, required this.child, required this.controller});

  @override
  State<VrGazeScope> createState() => _VrGazeScopeState();

  static VrGazeController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_VrGazeScopeData>()
        ?.controller;
  }
}

class _VrGazeScopeState extends State<VrGazeScope> {
  @override
  void initState() {
    super.initState();
    widget.controller.start();
  }

  @override
  void dispose() {
    widget.controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _VrGazeScopeData(controller: widget.controller, child: widget.child);
  }
}

class _VrGazeScopeData extends InheritedWidget {
  final VrGazeController controller;

  const _VrGazeScopeData({required this.controller, required super.child});

  @override
  bool updateShouldNotify(_VrGazeScopeData oldWidget) => false;
}

// =============================================================================
// VrGazeOverlay — wrapper occhio VR che disegna il reticle e aggiorna
//                 la posizione globale del reticle nel controller
// =============================================================================

class VrGazeOverlay extends StatefulWidget {
  final Widget child;
  final VrGazeController controller;

  /// Solo l'overlay isActive=true aggiorna reticleGlobalPosition
  /// (usata dall'hit-test dei bottoni). Entrambi gli overlay disegnano
  /// visivamente il reticle.
  final bool isActive;

  const VrGazeOverlay({
    super.key,
    required this.child,
    required this.controller,
    this.isActive = false,
  });

  @override
  State<VrGazeOverlay> createState() => _VrGazeOverlayState();
}

class _VrGazeOverlayState extends State<VrGazeOverlay> {
  /// GlobalKey sulla SizedBox.expand — fornisce il RenderBox fisico della
  /// vista occhio. localToGlobal su questo box è indipendente da MediaQuery.
  final _boxKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      // Il listener dell'overlay si registra PRIMA dei bottoni figli,
      // quindi aggiorna reticleGlobalPosition prima che i bottoni
      // eseguano il loro hit-test nella stessa notifyListeners().
      widget.controller.addListener(_updateReticleGlobal);
    }
  }

  @override
  void dispose() {
    if (widget.isActive) {
      widget.controller.removeListener(_updateReticleGlobal);
    }
    super.dispose();
  }

  void _updateReticleGlobal() {
    final box = _boxKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    // Centro della vista occhio + offset giroscopio = posizione globale reticle
    final localCenter = Offset(
      box.size.width / 2 + widget.controller.reticleOffset.dx,
      box.size.height / 2 + widget.controller.reticleOffset.dy,
    );
    widget.controller.updateReticleGlobalPosition(
      box.localToGlobal(localCenter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      key: _boxKey,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,

          // Reticle centrato sulla PROPRIA vista occhio (locale)
          ListenableBuilder(
            listenable: widget.controller,
            builder: (ctx, _) => Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ReticlePainter(
                    offset: widget.controller.reticleOffset,
                    dwellProgress: widget.controller.dwellProgress,
                    hasTarget: widget.controller.activeTargetId != null,
                    textColor: AppColors.getTextColor(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _ReticlePainter
// =============================================================================

class _ReticlePainter extends CustomPainter {
  final Color textColor;
  final Offset offset;
  final double dwellProgress;
  final bool hasTarget;

  const _ReticlePainter({
    required this.offset,
    required this.dwellProgress,
    required this.hasTarget,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2 + offset.dx,
      size.height / 2 + offset.dy,
    );
    const dotRadius = 4.0;
    const ringRadius = 20.0;
    const strokeWidth = 2.5;

    // Anello esterno inattivo
    canvas.drawCircle(
      center,
      ringRadius,
      Paint()
        ..color = textColor.withValues(alpha: 0.30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Arco di progresso dwell
    if (dwellProgress > 0) {
      // Glow
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: ringRadius),
        -pi / 2,
        2 * pi * dwellProgress,
        false,
        Paint()
          ..color = textColor.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 4
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      // Arco principale
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: ringRadius),
        -pi / 2,
        2 * pi * dwellProgress,
        false,
        Paint()
          ..color = hasTarget ? const Color(0xFF7EE89A) : textColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 1
          ..strokeCap = StrokeCap.round,
      );
    }

    // Punto centrale
    canvas.drawCircle(
      center,
      dotRadius,
      Paint()
        ..color = textColor.withValues(alpha: hasTarget ? 1.0 : 0.7)
        ..style = PaintingStyle.fill,
    );
    // Alone
    canvas.drawCircle(
      center,
      dotRadius + 3,
      Paint()
        ..color = textColor.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_ReticlePainter old) =>
      old.offset != offset ||
      old.dwellProgress != dwellProgress ||
      old.hasTarget != hasTarget;
}

// =============================================================================
// VrGazableButton
// =============================================================================

class VrGazableButton extends StatefulWidget {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTriggered;
  final double size;
  final double hitRadius;

  /// Se false, questo bottone NON esegue l'hit-test (bottone passivo, solo
  /// visivo). Usato nell'occhio destro dove i bottoni non devono interferire
  /// con il dwell timer del bottone attivo nell'occhio sinistro.
  final bool isActiveEye;

  const VrGazableButton({
    super.key,
    required this.id,
    required this.label,
    required this.icon,
    required this.onTriggered,
    this.color = const Color(0xFF7C9A6A),
    this.size = 80.0,
    this.hitRadius = 50.0,
    this.isActiveEye = true,
  });

  @override
  State<VrGazableButton> createState() => _VrGazableButtonState();
}

class _VrGazableButtonState extends State<VrGazableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  VrGazeController? _gazeController;
  bool _isGazed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gazeController?.removeListener(_onGazeUpdate);
    _gazeController = VrGazeScope.of(context);
    if (widget.isActiveEye) {
      _gazeController?.addListener(_onGazeUpdate);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    if (widget.isActiveEye) {
      _gazeController?.removeListener(_onGazeUpdate);
      _gazeController?.onGazeExit(widget.id);
    }
    super.dispose();
  }

  void _onGazeUpdate() {
    if (!mounted) return;
    final ctrl = _gazeController;
    if (ctrl == null) return;

    // FIX PRINCIPALE: usa reticleGlobalPosition calcolata dall'overlay
    // attivo (basata sulla RenderBox fisica), non MediaQuery.size.
    final reticleGlobal = ctrl.reticleGlobalPosition;
    if (reticleGlobal == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final buttonGlobalCenter = box.localToGlobal(
      Offset(box.size.width / 2, box.size.height / 2),
    );

    final distance = (reticleGlobal - buttonGlobalCenter).distance;
    final isGazed = distance <= widget.hitRadius;

    if (isGazed && !_isGazed) {
      _isGazed = true;
      setState(() {});
      ctrl.onGazeEnter(widget.id, widget.onTriggered);
    } else if (!isGazed && _isGazed) {
      _isGazed = false;
      setState(() {});
      ctrl.onGazeExit(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _gazeController?.activeTargetId == widget.id;
    final dwellProgress = isActive
        ? (_gazeController?.dwellProgress ?? 0.0)
        : 0.0;
    final textColor = AppColors.getTextColor(
      Theme.of(context).brightness == Brightness.dark,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            final pulse = _pulseController.value;
            return SizedBox(
              width: widget.size + 28,
              height: widget.size + 28,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Bagliore esterno pulsante
                  Container(
                    width: widget.size + 14 + (pulse * 8),
                    height: widget.size + 14 + (pulse * 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withValues(
                        alpha: isActive
                            ? 0.10 + dwellProgress * 0.15
                            : 0.03 + pulse * 0.05,
                      ),
                    ),
                  ),

                  // Traccia inattiva anello
                  CustomPaint(
                    size: Size(widget.size + 14, widget.size + 14),
                    painter: _GazeRingPainter(
                      progress: 1.0,
                      color: textColor.withValues(alpha: 0.10),
                      strokeWidth: 3.0,
                    ),
                  ),

                  // Anello dwell progress
                  if (dwellProgress > 0)
                    CustomPaint(
                      size: Size(widget.size + 14, widget.size + 14),
                      painter: _GazeRingPainter(
                        progress: dwellProgress,
                        color: widget.color,
                        strokeWidth: 4.0,
                        glowColor: widget.color.withValues(alpha: 0.6),
                      ),
                    ),

                  // Cerchio glassmorphic + icona
                  ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: widget.size,
                        height: widget.size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textColor.withValues(
                            alpha: isActive
                                ? 0.10 + dwellProgress * 0.12
                                : 0.05,
                          ),
                          border: Border.all(
                            color: widget.color.withValues(
                              alpha: isActive
                                  ? 0.50 + dwellProgress * 0.30
                                  : 0.18 + pulse * 0.12,
                            ),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          widget.icon,
                          color: textColor.withValues(
                            alpha: isActive
                                ? 0.85 + dwellProgress * 0.15
                                : 0.55 + pulse * 0.25,
                          ),
                          size: widget.size * 0.32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            final isActive = _gazeController?.activeTargetId == widget.id;
            return Text(
              widget.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: textColor.withValues(
                  alpha: isActive ? 0.9 : 0.40 + _pulseController.value * 0.30,
                ),
                letterSpacing: 1.2,
                height: 1.4,
              ),
            );
          },
        ),
      ],
    );
  }
}

// =============================================================================
// _GazeRingPainter
// =============================================================================

class _GazeRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final Color? glowColor;

  const _GazeRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    if (glowColor != null) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        Paint()
          ..color = glowColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 5
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_GazeRingPainter old) =>
      old.progress != progress || old.color != color;
}
