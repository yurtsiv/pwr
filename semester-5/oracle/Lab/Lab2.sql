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


