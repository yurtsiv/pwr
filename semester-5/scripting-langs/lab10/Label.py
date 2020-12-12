import json
from utils import read_json, is_list_of_strings
from Tags import Tags

class TagNotAceeptedError(ValueError):
  def __init__(self, tag):
    ValueError.__init__(self, "The tag you're trying to add is not present in the available tags list. Tag: " % tag)

class InvalidLabelFileFormatError(ValueError):
    def __init__(self, file_path):
        msg = """
        Couldnt parse the file %s. Make sure it a JSON objet with the following format:
        {
          "available_tags": ["tag1", "tag2"],
          "tags": ["tag1"]
        }
        """ % file_path

        ValueError.__init__(self, msg)

EMPTY_SET = set()

class Label:
  def __init__(self, tags_obj, tags):
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
  
  def to_json_file(self, file_path):
    with open(file_path, 'w') as outfile:
      json.dump({
        "available_tags": list(self.tags_obj.tags),
        "tags": list(self.tags)
      }, outfile)
  
  @classmethod
  def from_json_file(cls, file_path):
    data = None
    try:
      data = read_json(file_path)
    except:
      raise InvalidLabelFileFormatError(file_path)

    if not isinstance(data, dict):
      raise InvalidLabelFileFormatError(file_path)
    
    if not (data.get("available_tags") and data.get("tags")):
      raise InvalidLabelFileFormatError(file_path)

    available_tags = data["available_tags"]
    tags = data["tags"]

    if not (is_list_of_strings(available_tags) and is_list_of_strings(tags)):
      raise InvalidLabelFileFormatError(file_path)

    tags_obj = Tags(available_tags)

    return cls(
      tags_obj,
      tags
    )
 
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
    return (self.tags - other.tags) == EMPTY_SET
  
  def __ge__(self, other):
    return (other.tags - self.tags) == EMPTY_SET
  
  def __ne__(self, other):
    return self.tags & other.tags == EMPTY_SET
  
  def __str__(self):
    return "Label [" + ', '.join(self.tags) + "]"
