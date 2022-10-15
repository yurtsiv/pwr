from preprocess import preprocess_file
from tf_idf import calc_tf_idf, most_relevant_chapters
from random_paragraph import random_paragraph
from wordcloud import WordCloud


book_path = "data/harry_potter.txt"
chapter_paths = [f"data/harry_potter_chapters/{i}.txt" for i in range(1, 18)]
tf_idf_weights = calc_tf_idf(chapter_paths)

# Task 5,6
def gen_word_clouds():
    book_freq = preprocess_file(book_path)
    ignored_words = set(
        sorted(book_freq.keys(), key=lambda word: book_freq[word], reverse=True)[:3])
    for w in ignored_words:
        del book_freq[w]

    wc = WordCloud()
    wc.generate_from_frequencies(book_freq)
    wc.to_file("word_clouds/whole_book.png")
    for i, chapter in enumerate(tf_idf_weights.keys()):
        wc = WordCloud()
        wc.generate_from_frequencies(tf_idf_weights[chapter])
        wc.to_file(f"word_clouds/chapter_{i + 1}.png")


# gen_word_clouds()

# Task 7
# print(most_relevant_chapters("vernon", tf_idf_weights))

print(random_paragraph(book_path))