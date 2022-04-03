import os
import file

f = file.open("test.txt", "w+")
f.write("Some text")
f.seek(0)
print(f.read())
f.write("Some new text")
f.seek(5)
print(f.read())