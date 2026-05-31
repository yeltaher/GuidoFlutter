import os
from PIL import Image
import numpy as np

screenshots_dir = r"c:\Users\y.el.taher\Desktop\Yehia\Privato\CodePulse\Progetti\CP26-14 - Guido\2.Software\Guido\GuidoFlutter\screenshots"
files = sorted([f for f in os.listdir(screenshots_dir) if f.startswith("Screenshot 2026-05-26 10")])

print("Analyzing recent screenshots:")
for f in files:
    path = os.path.join(screenshots_dir, f)
    with Image.open(path) as img:
        img_gray = img.convert("L")
        arr = np.array(img_gray)
        avg_brightness = np.mean(arr)
        mode = "Light Mode" if avg_brightness > 160 else "Dark Mode"
        print(f"- {f}: Brightness={avg_brightness:.2f} ({mode})")
