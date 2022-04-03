import file

f = file.open("test.txt", "a+")
# f.lseek(0, 0)
f.write("new text")
# print(f.read())
# file.chmod("test.txt", 666)
# file.unlink("test.txt")