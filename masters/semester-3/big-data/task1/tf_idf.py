import math
from preprocess import preprocess_file


def calc_tf_idf(docs):
    chapter_freq = {}
    for chapter in docs:
        chapter_freq[chapter] = preprocess_file(chapter)

    # { 'chapter': { 'word': <tfidf> } } }
    weights = {}
    for chapter in docs:
        for word in chapter_freq[chapter]:
            if not weights.get(chapter):
                weights[chapter] = {}

            other_chapters_count = len(
                [c for c in docs if chapter_freq[c].get(word)])
            idf = math.log(len(docs) / (other_chapters_count + 1))
            weights[chapter][word] = chapter_freq[chapter][word] * idf

    return weights
