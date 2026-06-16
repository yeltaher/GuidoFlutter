import os
import glob

def wrap_gesture_detector(content):
    res = ""
    idx = 0
    search_str = "GestureDetector("
    
    while True:
        pos = content.find(search_str, idx)
        if pos == -1:
            res += content[idx:]
            break
            
        # check if it's already wrapped (heuristic)
        if pos > 10 and content[pos-10:pos].find("child:") != -1:
            # might already be in Semantics, but let's just do it
            pass
            
        res += content[idx:pos]
        res += 'Semantics(button: true, label: "Interactive element", child: GestureDetector('
        
        # find matching parenthesis
        paren_count = 1
        curr = pos + len(search_str)
        while curr < len(content) and paren_count > 0:
            if content[curr] == '(':
                paren_count += 1
            elif content[curr] == ')':
                paren_count -= 1
            curr += 1
            
        res += content[pos + len(search_str):curr]
        res += ")"
        idx = curr

    return res

lib_dir = "lib"
for filepath in glob.iglob(lib_dir + '/**/*.dart', recursive=True):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if "GestureDetector(" in content:
        new_content = wrap_gesture_detector(content)
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Updated {filepath}")
