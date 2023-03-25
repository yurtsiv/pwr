from string import punctuation
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer


english_stopwords = None
with open('./data/stopwords_english.txt') as f:
    english_stopwords = set(
        f.read().split('\n')
    )

ignored_tokens = set.union(
    english_stopwords,
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
    # stemmer = PorterStemmer()
    lemmatizer = WordNetLemmatizer()

    with open(filepath, encoding="UTF-8") as f:
        text = f.read()

        words = []
        for token in word_tokenize(text):
            lemmatized = lemmatizer.lemmatize(token.lower())
            if not lemmatized in ignored_tokens and len(lemmatized) > 2:
                words.append(lemmatized)

        return words


def preprocess_file(filepath):
    words = get_words(filepath)
    return count_occurences(words)
