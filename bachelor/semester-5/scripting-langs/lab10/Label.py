import json
from utils import EMPTY_SET, read_json, is_list_of_strings
from Tags import Tags

LABEL_FORMAT = """{
  "available_tags": ["tag1", "tag2"],
  "tags": ["tag1"]
}"""


class TagNotAceeptedError(ValueError):
    def __init__(self, tag):
        ValueError.__init__(
            self, "The tag you're trying to add is not present in the available tags list. Tag: " % tag)


class InvalidLabelFileFormatError(ValueError):
    def __init__(self, file_path):
        msg = "Couldn't parse the file %s. Make sure it contains a JSON objet with the following format:\n%s" % (
            file_path, LABEL_FORMAT)
        ValueError.__init__(self, msg)


class InvalidLabelFormatError(ValueError):
    def __init__(self, got):
        msg = "Couldn't parse the label. Make sure it has the following format:\n%s\nGot:\n%s" % (LABEL_FORMAT, got)
        ValueError.__init__(self, msg)

class Label:
    def __init__(self, tags_obj, tags = []):
        self.__tags_obj = tags_obj
        self.__tags = set(tags_obj.get_accepted(tags))

    def add_tag(self, tag):
        if not self.__tags_obj.is_accepted(tag):
            raise TagNotAceeptedError(tag)

        self.__tags.add(tag)

    @property
    def tags(self):
        return self.__tags

    @property
    def tags_obj(self):
        return self.__tags_obj

    def to_dict(self):
      return {
        "available_tags": list(self.tags_obj.tags),
        "tags": list(self.tags)
      }


    def to_json_file(self, file_path):
        with open(file_path, 'w') as outfile:
            json.dump(self.to_dict(), outfile, indent=2)

    @classmethod
    def from_dict(cls, label_dict):
        if not isinstance(label_dict, dict):
            raise InvalidLabelFormatError(label_dict)

        if not (label_dict.get("available_tags") and label_dict.get("tags")):
            raise InvalidLabelFormatError(label_dict)

        available_tags = label_dict["available_tags"]
        tags = label_dict["tags"]

        if not (is_list_of_strings(available_tags) and is_list_of_strings(tags)):
            raise InvalidLabelFormatError(label_dict)

        tags_obj = Tags(available_tags)

        return cls(
            tags_obj,
            tags
        )

    @classmethod
    def from_json_file(cls, file_path):
        data = None
        try:
            data = read_json(file_path)
        except json.JSONDecodeError:
            raise InvalidLabelFileFormatError(file_path)

        return cls.from_dict(data)

    def __add__(self, other):
        return Label(
            self.tags_obj + other.tags_obj,
            self.tags | other.tags
        )

    def __mul__(self, other):
        return Label(
            self.tags_obj * other.tags_obj,
            self.tags & other.tags
        )

    def __sub__(self, other):
        return Label(
            self.tags_obj + other.tags_obj,
            self.tags - other.tags
        )

    def __eq__(self, other):
        return self.tags == other.tags

    def __le__(self, other):
        return self.tags - other.tags == EMPTY_SET

    def __ge__(self, other):
        return other.tags - self.tags == EMPTY_SET

    def __ne__(self, other):
        return self.tags & other.tags == EMPTY_SET

    def __hash__(self):
        return hash(' '.join(self.__tags))

    def __str__(self):
        return "Label [" + ', '.join(self.tags) + "]"
