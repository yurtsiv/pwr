import random
import os
import json

from preprocess import get_words


def do_get_top_following_words(filepath, num_of_top_words=5):
    words = get_words(filepath)

    # { word: { other_word: <count> }}
    following_word_count = {}

    for i, word in enumerate(words[:-1]):
        if not following_word_count.get(word):
            following_word_count[word] = {}

        next_word = words[i + 1]

        if following_word_count[word].get(next_word):
            following_word_count[word][next_word] += 1
        else:
            following_word_count[word][next_word] = 1

    top_following_words = {}

    for word in words[:-1]:
        top_following_words[word] = sorted(
            following_word_count[word].keys(),
            key=lambda other_word: following_word_count[word][other_word],
            reverse=True)[:num_of_top_words]

    return top_following_words


def get_top_following_words(filepath):
    cache_filepath = f".cache/random_paragraph_{filepath.replace('/', '')}.json"

    if os.path.isfile(cache_filepath):
        with open(cache_filepath) as f:
            return json.load(f)
    else:
        occurences = do_get_top_following_words(filepath)

        with open(cache_filepath, "w") as f:
            json.dump(occurences, f)

        return occurences


def random_paragraph(filepath, words_count=100):
    top_following_words = get_top_following_words(filepath)

    prev_word = random.choice(list(top_following_words.keys()))
    result = prev_word
    for _ in range(words_count):
        next_word = random.choice(top_following_words[prev_word])
        result += f' {next_word}'
        prev_word = next_word

    return result
