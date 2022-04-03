import file

f = file.open("test.txt", "r+")
print(f.read())
f.write("new text")
print(f.read())
