import os
from PIL import Image
import numpy as np

screenshots_dir = r"c:\Users\y.el.taher\Desktop\Yehia\Privato\CodePulse\Progetti\CP26-14 - Guido\2.Software\Guido\GuidoFlutter\screenshots"
files = sorted([f for f in os.listdir(screenshots_dir) if f.startswith("Screenshot 2026-05-26 10")])

print("Heuristic check on screenshots:")
for f in files:
    path = os.path.join(screenshots_dir, f)
    with Image.open(path) as img:
        w, h = img.size
        # Get region color averages
        # Top header region (top 15%)
        top_crop = img.crop((0, 0, w, int(h * 0.15)))
        top_arr = np.array(top_crop)
        top_avg = np.mean(top_arr, axis=(0,1))
        
        # Middle region (middle 50%)
        mid_crop = img.crop((0, int(h * 0.25), w, int(h * 0.75)))
        mid_arr = np.array(mid_crop)
        mid_avg = np.mean(mid_arr, axis=(0,1))
        
        # Bottom region (bottom 15%)
        bot_crop = img.crop((0, int(h * 0.85), w, h))
        bot_arr = np.array(bot_crop)
        bot_avg = np.mean(bot_arr, axis=(0,1))
        
        print(f"\nFile: {f}")
        print(f"  Top avg: {top_avg[:3]}")
        print(f"  Mid avg: {mid_avg[:3]}")
        print(f"  Bot avg: {bot_avg[:3]}")
