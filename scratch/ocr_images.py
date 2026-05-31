import os
from PIL import Image
import pytesseract

# Set tesseract path if it's not in PATH (on Windows, sometimes it needs explicit path, let's try direct first)
# pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

screenshots_dir = r"c:\Users\y.el.taher\Desktop\Yehia\Privato\CodePulse\Progetti\CP26-14 - Guido\2.Software\Guido\GuidoFlutter\screenshots"
files = sorted([f for f in os.listdir(screenshots_dir) if f.startswith("Screenshot 2026-05-26 10")])

print("Running OCR on screenshots:")
for f in files:
    path = os.path.join(screenshots_dir, f)
    try:
        with Image.open(path) as img:
            text = pytesseract.image_to_string(img, lang='ita+eng')
            print(f"\n======================================")
            print(f"FILE: {f}")
            print(f"======================================")
            print(text.strip()[:400])  # Show first 400 chars of OCR
    except Exception as e:
        # If Italian + English fails, try default lang
        try:
            with Image.open(path) as img:
                text = pytesseract.image_to_string(img)
                print(f"\n======================================")
                print(f"FILE: {f}")
                print(f"======================================")
                print(text.strip()[:400])
        except Exception as e2:
            print(f"Failed to OCR {f}: {e2}")
