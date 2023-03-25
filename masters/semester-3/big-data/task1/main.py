from preprocess import preprocess_file
from tf_idf import calc_tf_idf
from wordcloud import WordCloud


doc_path = "data/shakespeare/piece1.txt"
chapter_paths = [f"data/shakespeare/piece{i}.txt" for i in range(1, 5)]
tf_idf_weights = calc_tf_idf(chapter_paths)


def gen_word_clouds():
    book_freq = preprocess_file(doc_path)

    wc = WordCloud()
    wc.generate_from_frequencies(book_freq)
    wc.to_file("word_clouds/doc.png")
    for i, doc in enumerate(tf_idf_weights.keys()):
        wc = WordCloud()
        wc.generate_from_frequencies(tf_idf_weights[doc])
        wc.to_file(f"word_clouds/doc{i + 1}.png")


gen_word_clouds()
