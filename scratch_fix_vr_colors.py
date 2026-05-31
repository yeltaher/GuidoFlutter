import re

file_gaze = r"c:\Users\y.el.taher\Desktop\Yehia\Privato\CodePulse\Progetti\CP26-14 - Guido\2.Software\Guido\GuidoFlutter\lib\core\theme\vr_gaze_button.dart"
with open(file_gaze, 'r', encoding='utf-8') as f:
    text = f.read()

if "import 'app_theme.dart';" not in text:
    text = text.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'app_theme.dart';")

# 1. VrGazeOverlay _ReticlePainter
text = text.replace(
    "class _ReticlePainter extends CustomPainter {",
    "class _ReticlePainter extends CustomPainter {\n  final Color textColor;"
)
text = text.replace(
    "required this.hasTarget,\n  });",
    "required this.hasTarget,\n    required this.textColor,\n  });"
)
text = text.replace(
    "painter: _ReticlePainter(\n                      offset: ctrl.reticleOffset,\n                      dwellProgress: ctrl.dwellProgress,\n                      hasTarget: ctrl.activeTargetId != null,\n                    ),",
    "painter: _ReticlePainter(\n                      offset: ctrl.reticleOffset,\n                      dwellProgress: ctrl.dwellProgress,\n                      hasTarget: ctrl.activeTargetId != null,\n                      textColor: AppColors.getTextColor(Theme.of(context).brightness == Brightness.dark),\n                    ),"
)

# Replace Colors.white with textColor inside _ReticlePainter
text = re.sub(r'Colors\.white(?=\.withOpacity|\b)', 'textColor', text, count=5) # There are 5 Colors.white in _ReticlePainter

# 2. VrGazableButton
text = text.replace(
    "final dwellProgress =\n        isActive ? (_gazeController?.dwellProgress ?? 0.0) : 0.0;",
    "final dwellProgress =\n        isActive ? (_gazeController?.dwellProgress ?? 0.0) : 0.0;\n    final textColor = AppColors.getTextColor(Theme.of(context).brightness == Brightness.dark);"
)
# Replace all remaining Colors.white with textColor in the file (which are all in VrGazableButton)
text = text.replace('Colors.white', 'textColor')

with open(file_gaze, 'w', encoding='utf-8') as f:
    f.write(text)


file_calib = r"c:\Users\y.el.taher\Desktop\Yehia\Privato\CodePulse\Progetti\CP26-14 - Guido\2.Software\Guido\GuidoFlutter\lib\features\meditation\presentation\vr_calibration_screen.dart"
with open(file_calib, 'r', encoding='utf-8') as f:
    text2 = f.read()

# Replace Colors.white with AppColors.getTextColor(isDark) in vr_calibration_screen
text2 = text2.replace('Colors.white', 'AppColors.getTextColor(isDark)')

with open(file_calib, 'w', encoding='utf-8') as f:
    f.write(text2)

print("Done")
