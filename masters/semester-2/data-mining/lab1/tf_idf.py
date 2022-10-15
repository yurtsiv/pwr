import math
from preprocess import preprocess_file


def calc_tf_idf(chapters):
    chapter_freq = {}
    for chapter in chapters:
        chapter_freq[chapter] = preprocess_file(chapter)

    # { 'chapter': { 'word': <tfidf> } } }
    weights = {}
    for chapter in chapters:
        for word in chapter_freq[chapter]:
            if not weights.get(chapter):
                weights[chapter] = {}

            other_chapters_count = len(
                [c for c in chapters if chapter_freq[c].get(word)])
            idf = math.log(len(chapters) / (other_chapters_count + 1))
            weights[chapter][word] = chapter_freq[chapter][word] * idf

    return weights


def most_relevant_chapters(word, weights):
    return sorted(
        [(chapter, weights[chapter][word])
         for chapter in weights.keys() if weights[chapter].get(word)],
        key=lambda x: x[1],
        reverse=True
    )
