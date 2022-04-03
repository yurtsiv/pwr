import sys
import file

file.connect(
    sys.argv[1],
    int(sys.argv[2]),
    int(sys.argv[3])
)

try:
    file.unlink("test2.txt")
except:
    pass

f1 = file.open("test.txt", "w+")
f1.write("Initial text")
f1.seek(0)
print(f1.read())

f1.write(" Next text")
f1.seek(13)
print(f1.read(5))

file.chmod("test.txt", 777)

file.rename("test.txt", "test2.txt")
f1.seek(0)
# still works after renaming
print(f1.read())

file.unlink("test2.txt")

try:
    # can't open unexisting file
    file.open("unexisting.txt", "r")
except Exception as e:
    print(e)

try:
    # renaming unexisting file
    file.rename("renmae.txt", "test.txt")
except Exception as e:
    print(e)

try:
    # chmod-ing unexisting file
    file.chmod("chmod.txt", 666)
except Exception as e:
    print(e)
