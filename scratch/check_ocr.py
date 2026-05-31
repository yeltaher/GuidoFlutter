try:
    import pytesseract
    print("pytesseract is installed")
except ImportError:
    print("pytesseract is NOT installed")

try:
    import easyocr
    print("easyocr is installed")
except ImportError:
    print("easyocr is NOT installed")

try:
    import cv2
    print("opencv-python is installed")
except ImportError:
    print("opencv-python is NOT installed")
