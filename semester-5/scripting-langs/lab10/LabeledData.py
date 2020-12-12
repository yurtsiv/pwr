import json
from utils import EMPTY_SET, read_json
from Label import Label, LABEL_FORMAT

class InvalidLabeledDataFileFormat(ValueError):
  def __init__(self, file_path):
    msg = "Couldn't parse the file %s. Make sure it contains a JSON array of objects of the following format:\n%s" % LABEL_FORMAT

    ValueError.__init__(self, msg)


class LabeledData:
  def __init__(self, labels = []):
    self.__labels = set(labels)
  
  def add_label(self, label):
    if label in self.__labels:
      return False

    self.__labels.add(label)
    return True
    
  
  def to_json_file(self, file_path):
    with open(file_path, 'w') as outfile:
      labels = [l.to_dict() for l in self.__labels]
      json.dump(labels, outfile, indent=2)
 
  @classmethod
  def from_json_file(cls, file_path):
    data = None
    try:
      data = read_json(file_path)
    except json.JSONDecodeError:
      raise InvalidLabeledDataFileFormat(file_path)

    if not isinstance(data, list):
      raise InvalidLabeledDataFileFormat(file_path)
    
    labels = [Label.from_dict(l) for l in data]

    return cls(labels)

  @property
  def labels(self):
    return self.__labels
  
  def __eq__(self, other):
    return self.labels == other.labels
  
  def __ne__(self, other):
    return self.labels & other.labels == EMPTY_SET
  
  def __le__(self, other):
    return self.labels - other.labels == EMPTY_SET
  
  def __ge__(self, other):
    return other.labels - self.labels == EMPTY_SET
  
  def __str__(self):
    labels_str = [str(l) for l in self.labels]

    res = ""

    for l in labels_str:
      res += "  " + l + "\n"
    
    return res