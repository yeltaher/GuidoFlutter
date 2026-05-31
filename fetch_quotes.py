import requests
from deep_translator import GoogleTranslator
import time
import sys

def main():
    print("Fetching quotes...")
    sys.stdout.flush()
    response = requests.get('https://dummyjson.com/quotes?limit=0')
    quotes_data = response.json().get('quotes', [])
    selected = quotes_data[:366]
    
    print("Translating...")
    sys.stdout.flush()
    
    translator = GoogleTranslator(source='en', target='it')
    dart_list = []
    
    for i, q in enumerate(selected):
        text = q['quote']
        author = q['author']
        
        try:
            translated_text = translator.translate(text)
        except Exception as e:
            translated_text = text
            print("Translation error:", e)
        
        escaped_text = translated_text.replace('"', '\\"').replace('\n', ' ')
        escaped_author = author.replace('"', '\\"').replace('\n', ' ')
        dart_list.append(f'  {{"quote": "{escaped_text}", "author": "{escaped_author}"}},')
        
        if (i+1) % 10 == 0:
            print(f"Translated {i+1} / 366")
            sys.stdout.flush()

    with open('lib/core/constants/daily_quotes.dart', 'w', encoding='utf-8') as f:
        f.write("/// Quotes generate automatically\n")
        f.write("class DailyQuotes {\n")
        f.write("  static const List<Map<String, String>> quotes = [\n")
        for item in dart_list:
            f.write(item + "\n")
        f.write("  ];\n")
        f.write("}\n")
    print("Done!")

if __name__ == '__main__':
    main()
