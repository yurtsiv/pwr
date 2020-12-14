import os

from Tags import Tags
from Label import Label
from LabeledData import LabeledData

data_folder = os.getcwd() + "/data/"

# ----
# TAGS
# ----

tags_str = [
  "red",
  "blue",
  "yellow",
  "yellow_2",
  "light_brown",
  "light_brown_2",
  "purple",
  "bronze",
  "orange"
  # "__white_"
] 

print("\n-- Tags --\n")
tags_obj = Tags(tags_str)

print(tags_obj)

test_tags = ["red", "black", "white", "blue"]
print()
print("get_accepted(" + str(test_tags) + ") => " + str(tags_obj.get_accepted(test_tags)))
print("\nget_rejected(" + str(test_tags) + ") => " + str(tags_obj.get_rejected(test_tags)))

tags_file_path = data_folder + "tags.json"

print("\nSaving tags to a file...")
tags_obj.to_json_file(tags_file_path)

print("\nReading tags from a file...\n")
print(Tags.from_json_file(tags_file_path))


# ------
# LABELS
# ------

print("\n\n-- Labels --")

label_1 = Label(tags_obj, ["red", "yellow", "blue"])
label_1.add_tag("red")

# label_1.add_tag("cyan")

label_2 = Label(tags_obj, ["red", "yellow", "bronze", "blue", "purple"])
label_3 = Label(tags_obj, ["red", "yellow", "blue"])
label_4 = Label(tags_obj, ["orange"])

print()
print("label_1: " + str(label_1))
print("label_2: " + str(label_2))
print("label_3: " + str(label_3))
print("label_4: " + str(label_4))

print("\nlabel_1 + label_2: " + str(label_1 + label_2))
print("\nlabel_1 * label_2: " + str(label_1 * label_2))
print("\nlabel_1 - label_2: " + str(label_1 - label_2))
print("\nlabel_2 - label_1: " + str(label_2 - label_1))
print("\nlabel_1 == label_2: " + str(label_1 == label_2))
print("\nlabel_1 == label_3: " + str(label_1 == label_3))
print("\nlabel_1 <= label_2: " + str(label_1 <= label_2))
print("\nlabel_1 >= label_2: " + str(label_1 >= label_2))
print("\nlabel_1 >= label_3: " + str(label_1 >= label_3))
print("\nlabel_1 != label_4: " + str(label_1 != label_4))
print("\nlabel_1 != label_2: " + str(label_1 != label_2))

label_1_file_path = data_folder + "label_1.json"

print("\nSaving label_1 to a file...")
label_1.to_json_file(label_1_file_path)

print("\nReading label_1 from a file...\n")
print(Label.from_json_file(label_1_file_path))

# ------------
# LABELED DATA
# ------------

print("\n\n-- Labeled data --")

labeled_data_1 = LabeledData([label_1])
labeled_data_1.add_label(label_2)

labeled_data_2 = LabeledData([label_1, label_2, label_3, label_4])
labeled_data_3 = LabeledData([label_1, label_2])
labeled_data_4 = LabeledData([label_4])

print("\nlabeled_data_1:\n" + str(labeled_data_1))
print("\nlabeled_data_2:\n" + str(labeled_data_2))
print("\nlabeled_data_3:\n" + str(labeled_data_3))
print("\nlabeled_data_4:\n" + str(labeled_data_4))

print("\nlabeled_data_1.add_label(label_3): " + str(labeled_data_1.add_label(label_3)))
print("\nlabeled_data_1 == labeled_data_2: " + str(labeled_data_1 == labeled_data_2))
print("\nlabeled_data_1 == labeled_data_3: " + str(labeled_data_1 == labeled_data_3))
print("\nlabeled_data_1 != labeled_data_2: " + str(labeled_data_1 != labeled_data_2))
print("\nlabeled_data_1 != labeled_data_4: " + str(labeled_data_1 != labeled_data_4))
print("\nlabeled_data_1 <= labeled_data_2: " + str(labeled_data_1 <= labeled_data_2))
print("\nlabeled_data_1 <= labeled_data_3: " + str(labeled_data_1 <= labeled_data_3))
print("\nlabeled_data_1 <= labeled_data_4: " + str(labeled_data_1 <= labeled_data_4))
print("\nlabeled_data_1 >= labeled_data_2: " + str(labeled_data_1 >= labeled_data_2))
print("\nlabeled_data_1 >= labeled_data_3: " + str(labeled_data_1 >= labeled_data_3))
print("\nlabeled_data_2 >= labeled_data_3: " + str(labeled_data_2 >= labeled_data_3))


labeled_data_1_file_path = data_folder + "labeled_data_1.json"

print("\nSaving labeled_data_1 to a file...")
labeled_data_1.to_json_file(labeled_data_1_file_path)

print("\nReading labeled_data_1 from a file...\n")
print(LabeledData.from_json_file(labeled_data_1_file_path))
