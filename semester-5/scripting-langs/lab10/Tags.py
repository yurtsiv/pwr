import re
from utils import calc_edit_distance

MIN_DL = 3
MAX_DL = 20

class InvalidTagFormatError(ValueError):
    def __init__(self, tag):
        ValueError.__init__(self, "A tag should be alpanumerical and can contain at most 2 underscores. Got: " + tag)

class IncorrectTagLengthError(ValueError):
    def __init__(self, tag):
        ValueError.__init__(self, "Tag length should be >= %d and <= %d. Got: %s" % (MIN_DL, MAX_DL, tag))

class Tags:
    # Any number of letters or digits or underscores
    # (exact number of underscores is checked separately)
    __TAG_REGEX = re.compile(r"^[a-zA-Z0-9\_]+$")

    def __init__(self):
        self.__tags = set()

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

    def get_accepted(self, tags):
        return [t for t in tags if t in self.__tags]

    def get_rejected(self, tags):
        return [t for t in tags if t not in self.__tags]
