FOLDERS = [
    "./scaledata/Dennis+Schwartz",
    "./scaledata/James+Berardinelli",
    "./scaledata/Scott+Renshaw",
    "./scaledata/Steve+Rhodes"
]

FILES = [
    "id",
    "label3",
    "label4",
    "rating",
    "subj"
]

data = {
    "subj": [],
    "label3": [],
    "label4": [],
}

for folder in FOLDERS:
    for file in FILES:
        with open(folder + "/" + file, 'r') as f:
            data[file] = f.read().split("\n")


result = "subj,label3,label4"

for i in range(0, len(data["subj"])):
    subj = data["subj"][i].replace(',', '').replace('"', '')
    result += "\n\"" + subj + "\"," + \
        data["label3"][i] + "," + data["label4"][i]

with open("./data.csv", "w") as f:
    f.write(result)
