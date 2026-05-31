import os
from PIL import Image

screenshots_dir = r"c:\Users\y.el.taher\Desktop\Yehia\Privato\CodePulse\Progetti\CP26-14 - Guido\2.Software\Guido\GuidoFlutter\screenshots"
files = [f for f in os.listdir(screenshots_dir) if f.endswith(".png")]

print(f"Found {len(files)} screenshots:")
for idx, f in enumerate(sorted(files)):
    path = os.path.join(screenshots_dir, f)
    with Image.open(path) as img:
        print(f"{idx+1}. {f} - Size: {img.size} - Format: {img.format}")
