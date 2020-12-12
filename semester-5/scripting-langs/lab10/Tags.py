import json
import re
from utils import calc_edit_distance, read_json, is_list_of_strings

MIN_DL = 3
MAX_DL = 20

class InvalidTagFormatError(ValueError):
    def __init__(self, tag):
        ValueError.__init__(self, "A tag should be alpanumerical and can contain at most 2 underscores. Got: " + tag)

class IncorrectTagLengthError(ValueError):
    def __init__(self, tag):
        ValueError.__init__(self, "Tag length should be >= %d and <= %d. Got: %s" % (MIN_DL, MAX_DL, tag))

class InvalidTagFileFormatError(ValueError):
    def __init__(self, file_path):
        ValueError.__init__(self, "Couldn't parse the file %s. Make sure it's a JSON array of strings" % file_path)

class Tags:
    # Any number of letters or digits or underscores
    # (exact number of underscores is checked separately)
    __TAG_REGEX = re.compile(r"^[a-zA-Z0-9\_]+$")

    def __init__(self, tags = []):
        self.__tags = set()

        for tag in tags:
            self.add_tag(tag)

    @property
    def tags(self):
        return self.__tags

    def add_tag(self, tag):
        if not Tags.__TAG_REGEX.match(tag) or len(re.findall(r"\_", tag)) > 2:
            raise InvalidTagFormatError(tag)
        
        if not MIN_DL <= len(tag) <= MAX_DL:
            raise IncorrectTagLengthError(tag)
        
        self.__tags.add(tag)
 
    def get_tags(self, tag, edit_dist):
        similar_tags = filter(
            lambda t:
                calc_edit_distance(tag, t) <= edit_dist,
            list(self.__tags),
        )

        return list(similar_tags)

    def is_accepted(self, tag):
        return tag in self.__tags

    def get_accepted(self, tags):
        return [t for t in tags if t in self.__tags]

    def get_rejected(self, tags):
        return [t for t in tags if t not in self.__tags]

    def to_json_file(self, file_path):
        with open(file_path, 'w') as outfile:
            json.dump(list(self.__tags), outfile, indent=2)

    @classmethod
    def from_json_file(cls, file_path):
        data = None
        try:
            data = read_json(file_path)
        except json.JSONDecodeError:
            raise InvalidTagFileFormatError(file_path)

        if not is_list_of_strings(data):
            raise InvalidTagFileFormatError(file_path)

        tags_obj = cls()
        for tag in data:
            tags_obj.add_tag(tag)

        return tags_obj
    
    def __add__(self, other):
        return Tags(self.tags | other.tags)
 
    def __mul__(self, other):
        return Tags(self.tags & other.tags)
    
    def __sub__(self, other):
        return Tags(self.tags - other.tags)

    def __str__(self):
        return "Tags [" + ', '.join(self.__tags) + "]"
