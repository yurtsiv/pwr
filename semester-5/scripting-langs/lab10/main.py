import os

from Tags import Tags
from Label import Label

data_folder = os.getcwd() + "/data/"

tags_file = data_folder + "tags.json"
label1_file = data_folder + "label1.json"
label2_file = data_folder + "label2.json"

l1 = Label.from_json_file(label1_file)
l2 = Label.from_json_file(label2_file)

print(l1)
print(l2)
print(l1 != l2)
