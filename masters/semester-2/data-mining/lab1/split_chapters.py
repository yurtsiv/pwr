import re

with open("./data/harry_potter.txt", encoding="UTF-8") as f:
    txt = f.read()
    
    chapters = re.split('\nCHAPTER [^\n]+', txt)

    for (i, chapter) in enumerate(chapters[1:]):
        with open(f"./data/harry_potter_chapters/{i+1}.txt", "w") as cf:
            cf.write(chapter)