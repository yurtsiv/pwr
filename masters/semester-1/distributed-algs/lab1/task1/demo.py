import os
import file

f1 = file.open("test.txt", "w+")
f1.write("Some text")
f1.seek(0)
print(f1.read())
f1.write(" Some new text")
f1.seek(10)
print(f1.read(5))
file.chmod("test.txt", 666)
file.rename("test.txt", "test2.txt")

try:
    file.open("test.txt", "w+")
except Exception as e:
    print(e)

f2 = file.open("test3.txt", "w+")
f2.write("File to delete")
file.unlink("test3.txt")
try:
    f2.read()
except Exception as e:
    print(e)