import json
import os
from string import punctuation
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem.porter import PorterStemmer
from nltk.stem import WordNetLemmatizer
import nltk

nltk.download('stopwords')
nltk.download('punkt')
nltk.download('wordnet')
nltk.download('omw-1.4')

ignored_tokens = set.union(
    set(stopwords.words('english')),
    punctuation,
    {"''", "'re", "...", "....", "'m", "'ve", "``",
        "--", "'s", "'d", "n't", "'ll", "the"}
)


def count_occurences(words):
    occurences = {}
    for word in words:
        if occurences.get(word):
            occurences[word] += 1
        else:
            occurences[word] = 1

    return occurences

def get_words(filepath):
    # stemmer =  PorterStemmer()
    lemmatizer = WordNetLemmatizer()

    with open(filepath, encoding="UTF-8") as f:
        text = f.read()
        return [lemmatizer.lemmatize(token.lower()) for token in word_tokenize(
            text) if not token in ignored_tokens]

def do_preprocess(filepath):
    words = get_words(filepath)
    return count_occurences(words)

def preprocess_file(filepath):
    cache_filepath = f".cache/preprocess_{filepath.replace('/', '')}.json"

    if os.path.isfile(cache_filepath):
        with open(cache_filepath) as f:
            return json.load(f)
    else:
        occurences = do_preprocess(filepath)

        with open(cache_filepath, "w") as f:
            json.dump(occurences, f)

        return occurences
