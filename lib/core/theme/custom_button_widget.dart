import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Un pulsante custom che replica l'estetica ed il riempimento radiale
/// del `CustomButton.cs` originale di Unity.
class CustomUnityButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLocked;
  final double width;
  final Color accentColor;

  const CustomUnityButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLocked = false,
    this.width = 220.0,
    this.accentColor = AppColors.successAccent,
  });

  @override
  State<CustomUnityButton> createState() => _CustomUnityButtonState();
}

class _CustomUnityButtonState extends State<CustomUnityButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isPressing = false;

  @override
  void initState() {
    super.initState();
    // Velocità di riempimento (fillSpeed) simile a quella di Unity
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTap();
        _resetButton();
      }
    });
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isLocked) {
      // Se bloccato, aprirebbe il paywall
      widget.onTap();
      return;
    }
    setState(() {
      _isPressing = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _resetButton();
  }

  void _onTapCancel() {
    _resetButton();
  }

  void _resetButton() {
    if (mounted) {
      setState(() {
        _isPressing = false;
      });
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: "Interactive element",
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _isPressing ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: widget.width,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: widget.isLocked
                    ? AppColors.goldAccent.withValues(alpha: 0.6)
                    : widget.accentColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Effetto riempimento radiale / lineare progressivo in stile Unity fillSprite
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: _animationController.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.isLocked
                              ? AppColors.goldAccent.withValues(alpha: 0.25)
                              : widget.accentColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    );
                  },
                ),

                // Contenuto testuale ed icone
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isLocked) ...[
                        const Icon(
                          Icons.lock_outline,
                          color: AppColors.goldAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.text.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: widget.isLocked
                                  ? AppColors.goldAccent
                                  : AppColors.getTextColor(
                                      Theme.of(context).brightness ==
                                          Brightness.dark,
                                    ),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
