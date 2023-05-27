from string import punctuation
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer

english_stopwords = set(stopwords.words('english'))

ignored_tokens = set.union(
    english_stopwords,
    punctuation,
    {"''", "'re", "...", "....", "'m", "'ve", "``",
        "--", "'s", "'d", "n't", "'ll", "the"}
)


def get_words(filepath):
    stemmer = PorterStemmer()

    with open(filepath, encoding="UTF-8") as f:
        text = f.read()

        words = []
        for token in word_tokenize(text):
            stem = stemmer.stem(token.lower())
            if not stem in ignored_tokens and len(stem) > 2:
                words.append(stem)

        return words

def get_n_grams(n, filepath):
    words = get_words(filepath)
    text = ' '.join(words)
    return set(text[i:i+n] for i in range(len(text) - n + 1))
