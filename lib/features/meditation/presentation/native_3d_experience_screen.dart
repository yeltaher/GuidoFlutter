import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/database/settings_provider.dart';

class Native3DExperienceScreen extends ConsumerStatefulWidget {
  final String? experienceId;

  const Native3DExperienceScreen({super.key, this.experienceId});

  @override
  ConsumerState<Native3DExperienceScreen> createState() => _Native3DExperienceScreenState();
}

class _Native3DExperienceScreenState extends ConsumerState<Native3DExperienceScreen> with SingleTickerProviderStateMixin {
  bool _isVrMode = false;
  
  // Gyroscope tracking
  double _yaw = 0.0;
  double _pitch = 90.0;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;

  // Breathing Guide
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;
  String _breathPhaseText = "Inspira";

  // Audio Service
  GuidoAudioService? _audioService;

  @override
  void initState() {
    super.initState();
    
    // Disable system UI for immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _initAudio();
    _initSensors();
    _initBreathing();
  }

  Future<void> _initAudio() async {
    _audioService = await ref.read(audioServiceProvider.future);
    
    // Avvio di un audio ambientale fittizio/di base
    // Nella realtà verificheremo experienceId per caricare l'audio corretto.
    try {
      await _audioService?.playAmbient('assets/Esperienze_Guido/Audio/Meditazioni/Generale/Meditazione_Generale_1.mp3');
    } catch (e) {
      debugPrint("Errore play audio: $e");
    }
  }

  void _initSensors() {
    _gyroSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      setState(() {
        _yaw += event.y * 2.0;
        _pitch -= event.x * 2.0;
        _pitch = _pitch.clamp(10.0, 170.0);
      });
    });
  }

  void _initBreathing() {
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );
    
    _breathController.addListener(() {
      final val = _breathController.value;
      String newPhase;
      if (val < 0.25) {
        newPhase = "Inspira";
      } else if (val < 0.50) {
        newPhase = "Trattieni";
      } else if (val < 0.75) {
        newPhase = "Espira";
      } else {
        newPhase = "Pausa";
      }
      
      if (newPhase != _breathPhaseText) {
        setState(() => _breathPhaseText = newPhase);
        HapticFeedback.mediumImpact();
      }
    });

    _breathAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.5).chain(CurveTween(curve: Curves.easeInOut)), weight: 25),
      TweenSequenceItem(tween: ConstantTween(1.5), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 0.5).chain(CurveTween(curve: Curves.easeInOut)), weight: 25),
      TweenSequenceItem(tween: ConstantTween(0.5), weight: 25),
    ]).animate(_breathController);

    _breathController.repeat();
  }

  @override
  void dispose() {
    _gyroSubscription?.cancel();
    _breathController.dispose();
    _audioService?.stopAll();
    
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Uscire dall'esperienza?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Annulla"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Esci"),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  Widget _buildModelViewer({bool isLeftEye = false, bool isRightEye = false}) {
    double eyeYaw = _yaw;
    if (_isVrMode) {
      if (isLeftEye) eyeYaw -= 2.0; 
      if (isRightEye) eyeYaw += 2.0;
    }

    return ModelViewer(
      src: 'assets/models/portal.glb',
      alt: "VR Environment",
      cameraControls: false,
      cameraOrbit: '${eyeYaw}deg ${double.parse(_pitch.toStringAsFixed(1))}deg 105%',
      fieldOfView: '90deg',
      interactionPrompt: InteractionPrompt.none,
      disableZoom: true,
      backgroundColor: Colors.black,
      loading: Loading.eager,
    );
  }

  Widget _buildBreathingOverlay() {
    return Center(
      child: AnimatedBuilder(
        animation: _breathAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _breathAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal.withValues(alpha: 0.3),
                border: Border.all(color: Colors.tealAccent, width: 2),
              ),
              child: Center(
                child: Text(
                  _breathPhaseText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControls() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(_isVrMode ? Icons.fullscreen : Icons.vrpano),
                color: Colors.white,
                iconSize: 32,
                onPressed: () {
                  setState(() {
                    _isVrMode = !_isVrMode;
                  });
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.white,
                iconSize: 32,
                onPressed: () async {
                  if (await _onWillPop()) {
                    if (mounted) context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            if (!_isVrMode)
              Positioned.fill(
                child: _buildModelViewer(),
              )
            else
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(child: _buildModelViewer(isLeftEye: true)),
                    Container(width: 4, color: Colors.black), 
                    Expanded(child: _buildModelViewer(isRightEye: true)),
                  ],
                ),
              ),
            
            if (!_isVrMode)
              _buildBreathingOverlay()
            else
              Row(
                children: [
                  Expanded(child: _buildBreathingOverlay()),
                  Expanded(child: _buildBreathingOverlay()),
                ],
              ),
              
            _buildControls(),
          ],
        ),
      ),
    );
  }
}
