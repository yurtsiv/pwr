-- Zadanie 17
SELECT pseudo "POLUJE W POLU",
       przydzial_myszy "PRZYDZIAL MYSZY",
       nazwa "BANDA"
FROM Kocury NATURAL JOIN Bandy
WHERE teren IN('POLE', 'CALOSC') AND przydzial_myszy > 50
ORDER BY przydzial_myszy DESC

-- Zadanie 18
SELECT K1.imie, K1.w_stadku_od "POLUJE OD"
FROM Kocury K1, Kocury K2
WHERE K2.imie = 'JACEK' AND K1.w_stadku_od < K2.w_stadku_od
ORDER BY K1.w_stadku_od DESC

-- Zadanie 19a
SELECT K.imie "Imie",
       K.funkcja "Funkcja",
       S1.pseudo "Szef 1",
       S2.pseudo "Szef 2",
       S3.pseudo "Szef 3"
FROM Kocury K LEFT JOIN Kocury S1 ON K.szef = S1.pseudo
              LEFT JOIN Kocury S2 ON S1.szef = S2.pseudo
              LEFT JOIN Kocury S3 ON S2.szef = S3.pseudo
WHERE K.funkcja in ('KOT', 'MILUSIA')

-- Zadanie 19b
SELECT
  RootImie "Imie",
  "Funkcja",
  NVL(sz1, ' ') "Szef 1",
  NVL(sz2, ' ') "Szef 2",
  NVL(sz3, ' ') "Szef 3"
FROM
(
  SELECT CONNECT_BY_ROOT imie RootImie, CONNECT_BY_ROOT funkcja "Funkcja", LEVEL lvl, imie
  FROM kocury
  CONNECT BY PRIOR szef = pseudo
  START WITH funkcja IN ('KOT', 'MILUSIA')
)
PIVOT
(
    MIN(imie)
    FOR lvl
    IN (2 sz1, 3 sz2, 4 sz3)
)

-- Zadanie 19c
SELECT imie, funkcja, SUBSTR(MAX(szefowie), 17) "Imiona kolejnych szefów"
FROM
(
    SELECT
        CONNECT_BY_ROOT imie imie,
        CONNECT_BY_ROOT funkcja funkcja,
        SYS_CONNECT_BY_PATH(RPAD(imie, 10), ' | ') szefowie
    FROM kocury
    CONNECT BY PRIOR szef = pseudo
    START WITH funkcja IN ('KOT', 'MILUSIA')
)
GROUP BY imie, funkcja;

ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY';

-- Zadanie 20
SELECT
    imie "Imie kotki",
    nazwa "Nazwa bandy",
    imie_wroga "Imie wroga",
    LPAD(stopien_wrogosci, 15) "Ocena wroga",
    data_incydentu "Data incydentu"
FROM Kocury
NATURAL JOIN Bandy
NATURAL JOIN Wrogowie_kocurow
NATURAL JOIN Wrogowie
WHERE plec = 'D' AND data_incydentu > '01.01.2007'
ORDER BY imie

-- Zadanie 21
SELECT nazwa "Nazwa bandy", COUNT(DISTINCT pseudo) "Koty z wrogami"
FROM Bandy
NATURAL JOIN Kocury
NATURAL JOIN Wrogowie_kocurow
GROUP BY nazwa

-- Zadanie 22
SELECT funkcja "Funkcja", pseudo "Pseudonim kota", COUNT(*) "Liczba wrogów"
FROM Kocury
NATURAL JOIN Wrogowie_kocurow
GROUP BY funkcja, pseudo
HAVING COUNT(*) > 1

-- Zadanie 23
SELECT
    imie,
    przydzial_myszy * 12 + myszy_extra * 12 "Dawka roczna",
    'powyzej 864' "Dawka"
FROM Kocury
WHERE
    przydzial_myszy * 12 + myszy_extra * 12 > 864 AND
    myszy_extra IS NOT NULL
UNION
SELECT
    imie,
    przydzial_myszy * 12 + myszy_extra * 12 "Dawka roczna",
    '864' "Dawka"
FROM KOCURY
WHERE
    przydzial_myszy * 12 + myszy_extra * 12 = 864 AND
    myszy_extra IS NOT NULL
UNION
SELECT
    imie,
    przydzial_myszy * 12 + myszy_extra * 12 "Dawka roczna",
    'ponizej 864' "Dawka"
FROM KOCURY
WHERE
    przydzial_myszy * 12 + myszy_extra * 12 < 864 AND
    myszy_extra IS NOT NULL
ORDER BY "Dawka roczna" DESC

-- Zadanie 24 (bez podzapytań i operatorów zbiorowych)
SELECT LPAD(nr_bandy, 10) "NR BANDY", nazwa, teren
FROM Bandy
LEFT JOIN Kocury USING(nr_bandy)
WHERE pseudo IS NULL

-- Zadanie 24 (z operatorem zbiorowym)
SELECT nr_bandy, nazwa, teren
FROM Bandy
LEFT JOIN Kocury USING(nr_bandy)
MINUS
SELECT nr_bandy, nazwa, teren
FROM Bandy
NATURAL JOIN Kocury;

-- Zadanie 25
SELECT *
FROM Kocury
WHERE przydzial_myszy >= 3 * (
        SELECT przydzial_myszy
        FROM (SELECT * FROM Kocury ORDER BY przydzial_myszy DESC)
        NATURAL JOIN Bandy
        WHERE funkcja = 'MILUSIA' AND teren IN ('SAD', 'CALOSC') AND rownum = 1
      );

-- Zadanie 26
SELECT
  funkcja,
  ROUND(AVG(przydzial_myszy + NVL(myszy_extra, 0)))  "Srednio najw. i najm. myszy"
FROM Funkcje
NATURAL JOIN Kocury
WHERE funkcja <> 'SZEFUNIO'
GROUP BY funkcja
HAVING AVG(przydzial_myszy + NVL(myszy_extra, 0)) IN (
    (SELECT MIN(AVG(przydzial_myszy + NVL(myszy_extra, 0)))
     FROM Funkcje
     NATURAL JOIN Kocury
     WHERE funkcja <> 'SZEFUNIO'
     GROUP BY Funkcja),
    (SELECT MAX(AVG(przydzial_myszy + NVL(myszy_extra, 0)))
     FROM Funkcje
     NATURAL JOIN Kocury
     WHERE funkcja <> 'SZEFUNIO'
     GROUP BY Funkcja)
);

-- Zadanie 27a
SELECT pseudo, (przydzial_myszy + NVL(myszy_extra, 0)) Zjada
FROM Kocury K
WHERE 6 >= (
        SELECT COUNT(*)
        FROM Kocury
        WHERE (K.przydzial_myszy + NVL(K.myszy_extra, 0)) <
                (przydzial_myszy + NVL(myszy_extra, 0))
    )
ORDER BY Zjada DESC

-- Zadanie 27b
SELECT pseudo, (przydzial_myszy + NVL(myszy_extra, 0)) Zjada
FROM Kocury
WHERE (przydzial_myszy + NVL(myszy_extra, 0)) IN (
    SELECT *
    FROM (
        SELECT (przydzial_myszy + NVL(myszy_extra, 0)) zjada
        FROM Kocury
        ORDER BY zjada DESC
    )
    WHERE ROWNUM <= 6
)
ORDER BY Zjada DESC

-- Zadanie 27c
SELECT K1.pseudo, MAX(K1.przydzial_myszy + NVL(K1.myszy_extra, 0)) Zjada
FROM Kocury K1, Kocury K2
WHERE (K1.przydzial_myszy + NVL(K1.myszy_extra, 0)) <=
      (K2.przydzial_myszy + NVL(K2.myszy_extra, 0))
GROUP BY K1.pseudo
HAVING COUNT(DISTINCT K2.przydzial_myszy + NVL(K2.myszy_extra, 0)) <= 6
ORDER BY Zjada DESC

-- Zadanie 27d
SELECT pseudo, Zjada    
FROM (
    SELECT
        pseudo,
        przydzial_myszy + NVL(myszy_extra, 0) Zjada,
        DENSE_RANK() OVER (ORDER BY przydzial_myszy + NVL(myszy_extra, 0) DESC) pozycja
    FROM Kocury
)
WHERE pozycja <= 6

-- -- Zadanie 28
SELECT
    TO_CHAR(EXTRACT(YEAR FROM w_stadku_od)) "Rok",
    COUNT(*) "Liczba wstapien"
FROM Kocury
GROUP BY EXTRACT(YEAR FROM w_stadku_od)
HAVING COUNT(*) IN (
    -- Pierwsza większa od śrendiej
    (
        SELECT *
        FROM (
            SELECT COUNT(*)
            FROM Kocury
            GROUP BY EXTRACT(YEAR FROM w_stadku_od)
            HAVING COUNT(*) > (
                SELECT AVG(COUNT(*))
                FROM Kocury
                GROUP BY EXTRACT(YEAR FROM w_stadku_od)
            )
            ORDER BY COUNT(*) DESC
        )
        WHERE ROWNUM = 1
    ),

    -- Pierwsza niższa od średniej
    (
        SELECT *
        FROM (
            SELECT COUNT(*)
            FROM Kocury
            GROUP BY EXTRACT(YEAR FROM w_stadku_od)
            HAVING COUNT(*) < (
                SELECT AVG(COUNT(*))
                FROM Kocury
                GROUP BY EXTRACT(YEAR FROM w_stadku_od)
            )
            ORDER BY COUNT(*) DESC
        )
        WHERE ROWNUM = 1
    )
)
UNION
SELECT 'Srednia' "Rok", ROUND(AVG(COUNT(*)), 7) "Liczba wstapien"
FROM Kocury
GROUP BY EXTRACT(YEAR FROM w_stadku_od)
ORDER BY "Liczba wstapien"

