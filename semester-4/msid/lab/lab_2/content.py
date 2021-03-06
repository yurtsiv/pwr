# --------------------------------------------------------------------------
# ------------  Metody Systemowe i Decyzyjne w Informatyce  ----------------
# --------------------------------------------------------------------------
#  Zadanie 2: k-NN i Naive Bayes
#  autorzy: A. Gonczarek, J. Kaczmar, S. Zareba, P. Dąbrowski
#  2019
# --------------------------------------------------------------------------

import numpy as np
from scipy.spatial import distance


def hamming_distance(X, X_train):
    """
    Zwróć odległość Hamminga dla obiektów ze zbioru *X* od obiektów z *X_train*.

    :param X: zbiór porównywanych obiektów N1xD
    :param X_train: zbiór obiektów do których porównujemy N2xD
    :return: macierz odległości pomiędzy obiektami z "X" i "X_train" N1xN2
    """

    X = X.toarray()
    X_train = X_train.toarray().transpose()
    outArr = X.astype(np.uint8) @ X_train.astype(np.uint8)
    outArr += (~X).astype(np.uint8) @ (~X_train).astype(np.uint8)
    return np.subtract(np.uint8(X_train.shape[0]), outArr)

def sort_train_labels_knn(Dist, y):
    """
    Posortuj etykiety klas danych treningowych *y* względem prawdopodobieństw
    zawartych w macierzy *Dist*.

    :param Dist: macierz odległości pomiędzy obiektami z "X" i "X_train" N1xN2
    :param y: wektor etykiet o długości N2
    :return: macierz etykiet klas posortowana względem wartości podobieństw
        odpowiadającego wiersza macierzy Dist N1xN2

    Do sortowania użyj algorytmu mergesort.
    """

    indecies = Dist.argsort(kind='mergesort')
    return y[indecies]

def p_y_x_knn(y, k):
    """
    Wyznacz rozkład prawdopodobieństwa p(y|x) każdej z klas dla obiektów
    ze zbioru testowego wykorzystując klasyfikator KNN wyuczony na danych
    treningowych.

    :param y: macierz posortowanych etykiet dla danych treningowych N1xN2
    :param k: liczba najbliższych sasiadow dla KNN
    :return: macierz prawdopodobieństw p(y|x) dla obiektów z "X" N1xM
    """

    m = len(np.unique(y[0]))
    res = np.zeros((y.shape[0], m))

    for row_num, row in enumerate(y):
        nearest_neigh_categs = row[:k]

        for category in range(m):
            probability = np.count_nonzero(nearest_neigh_categs == category) / k
            res[row_num][category] = probability
    
    return res

def classification_error(p_y_x, y_true):
    """
    Wyznacz błąd klasyfikacji.

    :param p_y_x: macierz przewidywanych prawdopodobieństw - każdy wiersz
        macierzy reprezentuje rozkład p(y|x) NxM
    :param y_true: zbiór rzeczywistych etykiet klas 1xN
    :return: błąd klasyfikacji
    """

    wrong_predictions = 0
    for sample_num, sample in enumerate(p_y_x):
        max_probablity_label = len(sample) - np.argmax(np.flip(sample)) - 1
        true_lable = y_true[sample_num]

        if max_probablity_label != true_lable:
            wrong_predictions += 1
    
    return wrong_predictions / len(y_true)

def model_selection_knn(X_val, X_train, y_val, y_train, k_values):
    """
    Wylicz bład dla różnych wartości *k*. Dokonaj selekcji modelu KNN
    wyznaczając najlepszą wartość *k*, tj. taką, dla której wartość błędu jest
    najniższa.

    :param X_val: zbiór danych walidacyjnych N1xD
    :param X_train: zbiór danych treningowych N2xD
    :param y_val: etykiety klas dla danych walidacyjnych 1xN1
    :param y_train: etykiety klas dla danych treningowych 1xN2
    :param k_values: wartości parametru k, które mają zostać sprawdzone
    :return: krotka (best_error, best_k, errors), gdzie "best_error" to
        najniższy osiągnięty błąd, "best_k" to "k" dla którego błąd był
        najniższy, a "errors" - lista wartości błędów dla kolejnych
        "k" z "k_values"
    """

    dist = hamming_distance(X_val, X_train)
    labels_sorted = sort_train_labels_knn(dist, y_train)

    k_errors = []
    for k in k_values:
        p_y_x = p_y_x_knn(labels_sorted, k)
        error = classification_error(p_y_x, y_val)
        k_errors.append((error, k))

    best_error, best_k = min(k_errors, key=lambda e: e[0])
    return (best_error, best_k, [error for error, _ in k_errors])


def estimate_a_priori_nb(y_train):
    """
    Wyznacz rozkład a priori p(y) każdej z klas dla obiektów ze zbioru
    treningowego.

    :param y_train: etykiety dla danych treningowych 1xN
    :return: wektor prawdopodobieństw a priori p(y) 1xM
    """

    N = len(y_train)
    res = []
    for k in range(len(np.unique(y_train))):
        pi_k = np.count_nonzero(y_train == k) / N
        res.append(pi_k)
    
    return res

def estimate_p_x_y_nb(X_train, y_train, a, b):
    """
    Wyznacz rozkład prawdopodobieństwa p(x|y) zakładając, że *x* przyjmuje
    wartości binarne i że elementy *x* są od siebie niezależne.

    :param X_train: dane treningowe NxD
    :param y_train: etykiety klas dla danych treningowych 1xN
    :param a: parametr "a" rozkładu Beta
    :param b: parametr "b" rozkładu Beta
    :return: macierz prawdopodobieństw p(x|y) dla obiektów z "X_train" MxD.
    """

    _, D = X_train.shape 
    M = len(np.unique(y_train))

    res = np.zeros((M, D))

    for k in range(M):
        for d in range(D):
            x_d = X_train[:, d].toarray().flatten()

            numerator = np.count_nonzero([(y_train == k) & (x_d == 1)]) + a - 1 
            denominator = np.count_nonzero(y_train == k) + a + b - 2
            res[k][d] = (numerator / denominator)

    return res

def p_y_x_nb(p_y, p_x_1_y, X):
    """
    Wyznacz rozkład prawdopodobieństwa p(y|x) dla każdej z klas z wykorzystaniem
    klasyfikatora Naiwnego Bayesa.

    :param p_y: wektor prawdopodobieństw a priori 1xM
    :param p_x_1_y: rozkład prawdopodobieństw p(x=1|y) MxD
    :param X: dane dla których beda wyznaczone prawdopodobieństwa, macierz NxD
    :return: macierz prawdopodobieństw p(y|x) dla obiektów z "X" NxM
    """

    M = p_x_1_y.shape[0]
    N = X.shape[0]
    X = X.toarray()
    res = np.empty((N, M))
    p_x_1_y_rev = 1 - p_x_1_y

    for n, x in enumerate(X):
        x_rev = 1 - x
        categories_p = np.prod((p_x_1_y ** x) * (p_x_1_y_rev ** x_rev), axis=1) * p_y

        res[n] = categories_p / np.sum(categories_p)

    return res

def model_selection_nb(X_train, X_val, y_train, y_val, a_values, b_values):
    """
    Wylicz bład dla różnych wartości *a* i *b*. Dokonaj selekcji modelu Naiwnego
    Byesa, wyznaczając najlepszą parę wartości *a* i *b*, tj. taką, dla której
    wartość błędu jest najniższa.
    
    :param X_train: zbiór danych treningowych N2xD
    :param X_val: zbiór danych walidacyjnych N1xD
    :param y_train: etykiety klas dla danych treningowych 1xN2
    :param y_val: etykiety klas dla danych walidacyjnych 1xN1
    :param a_values: lista parametrów "a" do sprawdzenia
    :param b_values: lista parametrów "b" do sprawdzenia
    :return: krotka (best_error, best_a, best_b, errors), gdzie "best_error" to
        najniższy osiągnięty błąd, "best_a" i "best_b" to para parametrów
        "a" i "b" dla której błąd był najniższy, a "errors" - lista wartości
        błędów dla wszystkich kombinacji wartości "a" i "b" (w kolejności
        iterowania najpierw po "a_values" [pętla zewnętrzna], a następnie
        "b_values" [pętla wewnętrzna]).
    """

    errors = np.ones((len(a_values), len(b_values)))
    estimated_p_y = estimate_a_priori_nb(y_train)
    best_a = 0
    best_b = 0
    best_error = np.inf
    for i in range(len(a_values)):
        for j in range(len(b_values)):
            error = classification_error(p_y_x_nb(estimated_p_y, estimate_p_x_y_nb(X_train, y_train, a_values[i], b_values[j]), X_val), y_val)
            errors[i][j] = error
            if error < best_error:
                best_a = a_values[i]
                best_b = b_values[j]
                best_error = error
    return best_error, best_a, best_b, errors
