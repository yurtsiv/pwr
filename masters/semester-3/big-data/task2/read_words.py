from nltk.tokenize import word_tokenize


def read_words(filepath):
    with open(filepath) as f:
        return word_tokenize(f.read())
