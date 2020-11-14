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

-- Zadanie 29a
SELECT
    K1.imie,
    K1.przydzial_myszy + NVL(K1.myszy_extra, 0) "Zjada",
    K1.nr_bandy "Nr bandy",
    AVG(K2.przydzial_myszy + NVL(K2.myszy_extra, 0)) "Srednia bandy"
FROM Kocury K1
JOIN Kocury K2 ON K1.nr_bandy = K2.nr_bandy
WHERE K1.plec = 'M'
GROUP BY K1.imie, K1.nr_bandy, K1.przydzial_myszy, K1.myszy_extra
HAVING (K1.przydzial_myszy + NVL(K1.myszy_extra, 0)) <= (
     AVG(K2.przydzial_myszy + NVL(K2.myszy_extra, 0))
)
ORDER BY K1.nr_bandy DESC

-- Zadanie 29b
SELECT
    imie,
    przydzial_myszy + NVL(myszy_extra, 0) "Zjada",
    nr_bandy "Nr bandy",
    "Srednia bandy"
FROM (
    SELECT nr_bandy, AVG(przydzial_myszy + NVL(myszy_extra, 0)) "Srednia bandy"
    FROM Kocury
    GROUP BY nr_bandy
)
JOIN Kocury USING (nr_bandy)
WHERE (przydzial_myszy + NVL(myszy_extra, 0)) <= "Srednia bandy" AND plec = 'M'
ORDER BY nr_bandy DESC

-- Zadanie 29c
SELECT
    K.imie,
    K.przydzial_myszy + NVL(myszy_extra, 0) "Zjada",
    K.nr_bandy "Nr bandy",
    (
        SELECT AVG(przydzial_myszy + NVL(myszy_extra, 0))
        FROM Kocury
        WHERE nr_bandy = K.nr_bandy
    ) "Srednia bandy"
FROM Kocury K
WHERE (przydzial_myszy + NVL(myszy_extra, 0)) <= (
    SELECT AVG(przydzial_myszy + NVL(myszy_extra, 0))
    FROM Kocury
    WHERE nr_bandy = K.nr_bandy
) AND plec = 'M'
ORDER BY nr_bandy DESC

-- Zadanie 30
SELECT
    imie,
    w_stadku_od "Wstapil do stadka",
    '<--- NAJMLODSZY STAZEM W BANDZIE ' || nazwa " "
FROM Kocury K
JOIN Bandy B ON K.nr_bandy = B.nr_bandy 
WHERE w_stadku_od = (
    SELECT MAX(w_stadku_od)
    FROM Kocury
    WHERE K.nr_bandy = nr_bandy
)
UNION
SELECT
    imie,
    w_stadku_od "Wstapil do stadka",
    '<--- NAJSTARSZY STAZEM W BANDZIE ' || nazwa " "
FROM Kocury K
JOIN Bandy B ON K.nr_bandy = B.nr_bandy 
WHERE w_stadku_od = (
    SELECT MIN(w_stadku_od) FROM Kocury WHERE K.nr_bandy = nr_bandy
)
UNION
SELECT
    imie,
    w_stadku_od,
    ' ' " "
FROM Kocury K
JOIN Bandy B ON K.nr_bandy = B.nr_bandy
WHERE w_stadku_od NOT IN (
    (SELECT MAX(w_stadku_od) FROM Kocury WHERE K.nr_bandy = nr_bandy),
    (SELECT MIN(w_stadku_od) FROM Kocury WHERE K.nr_bandy = nr_bandy)
)

-- Zadanie 31
CREATE OR REPLACE VIEW Bandy_info AS
SELECT
    nazwa nazwa_bandy,
    AVG(przydzial_myszy) sre_spoz,
    MAX(przydzial_myszy) max_spoz,
    MIN(przydzial_myszy) min_spoz,
    COUNT(*) koty,
    COUNT(myszy_extra) koty_z_dod
FROM Kocury
NATURAL JOIN Bandy
GROUP BY nazwa
ORDER BY max_spoz DESC;

SELECT * from Bandy_info

-- TODO: check
SELECT
    pseudo,
    imie,
    funkcja,
    przydzial_myszy "Zjada",
    'OD ' || min || ' DO ' || max "Granice spozycia",
    w_stadku_od "Lowi od"
FROM Kocury
NATURAL JOIN Bandy
NATURAL JOIN Bandy_info
WHERE pseudo = $(pseudonim_kota)

-- Zadanie 32
SELECT
    pseudo "Pseudonim",
    plec "Plec",
    przydzial_myszy "Myszy przed podw.",
    NVL(myszy_extra, 0) "Extra przed podw."
FROM Kocury
WHERE pseudo IN (
    (
        SELECT *
        FROM (
            SELECT pseudo
            FROM Kocury
            NATURAL JOIN Bandy
            WHERE nazwa = 'CZARNI RYCERZE'
            ORDER BY w_stadku_od
        )
        WHERE ROWNUM < 4
    )
    UNION ALL
    (
        SELECT *
        FROM (
            SELECT pseudo
            FROM Kocury
            NATURAL JOIN Bandy
            WHERE nazwa = 'LACIACI MYSLIWI'
            ORDER BY w_stadku_od
        )
        WHERE ROWNUM < 4   
    )
);

UPDATE Kocury
SET przydzial_myszy =
    CASE plec
    WHEN 'M' THEN przydzial_myszy + 10
    ELSE (
        przydzial_myszy + (SELECT MIN(przydzial_myszy) FROM Kocury) * 0.1
    )
    END,
    myszy_extra = NVL(myszy_extra, 0) + (
        SELECT AVG(NVL(myszy_extra, 0))
        FROM Kocury K2
        WHERE Kocury.nr_bandy = K2.nr_bandy
    ) * 0.15
WHERE pseudo IN (
    (
        SELECT *
        FROM (
            SELECT pseudo
            FROM Kocury
            NATURAL JOIN Bandy
            WHERE nazwa = 'CZARNI RYCERZE'
            ORDER BY w_stadku_od
        )
        WHERE ROWNUM < 4
    )
    UNION ALL
    (
        SELECT *
        FROM (
            SELECT pseudo
            FROM Kocury
            NATURAL JOIN Bandy
            WHERE nazwa = 'LACIACI MYSLIWI'
            ORDER BY w_stadku_od
        )
        WHERE ROWNUM < 4   
    )
);

SELECT
    pseudo "Pseudonim",
    plec "Plec",
    przydzial_myszy "Myszy po podw.",
    NVL(myszy_extra, 0) "Extra po podw."
FROM Kocury
WHERE pseudo IN (
    (
        SELECT *
        FROM (
            SELECT pseudo
            FROM Kocury
            NATURAL JOIN Bandy
            WHERE nazwa = 'CZARNI RYCERZE'
            ORDER BY w_stadku_od
        )
        WHERE ROWNUM < 4
    )
    UNION ALL
    (
        SELECT *
        FROM (
            SELECT pseudo
            FROM Kocury
            NATURAL JOIN Bandy
            WHERE nazwa = 'LACIACI MYSLIWI'
            ORDER BY w_stadku_od
        )
        WHERE ROWNUM < 4   
    )
);

ROLLBACK;

-- Zadanie 33a
SELECT
    DECODE(plec, 'Kocur', ' ', nazwa) nazwa,
    plec,
    ile,
    szefunio,
    bandzior,
    lowczy,
    lapacz,
    kot,
    milusia,
    dzielczy,
    suma
FROM (
    SELECT
        nazwa,
        DECODE(PLEC, 'D', 'Kotka', 'Kocur') plec,
        TO_CHAR(COUNT(*)) ile,
        TO_CHAR(SUM(DECODE(funkcja,'SZEFUNIO', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) szefunio,
        TO_CHAR(SUM(DECODE(funkcja, 'BANDZIOR', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) bandzior,
        TO_CHAR(SUM(DECODE(funkcja, 'LOWCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) lowczy,
        TO_CHAR(SUM(DECODE(funkcja, 'LAPACZ', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) lapacz,
        TO_CHAR(SUM(DECODE(funkcja, 'KOT', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) kot,
        TO_CHAR(SUM(DECODE(funkcja, 'MILUSIA', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) milusia,
        TO_CHAR(SUM(DECODE(funkcja, 'DZIELCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) dzielczy,
        TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) suma
    FROM Kocury
    NATURAL JOIN Bandy
    GROUP BY nazwa, plec
    UNION
    SELECT
        'Z----------------',
        '--------',
        '----------',
        '-----------',
        '-----------',
        '----------',
        '----------',
        '----------',
        '----------',
        '----------',
        '----------'
    FROM dual
    UNION
    SELECT
        'ZJADA RAZEM' nazwa, ' ' plec, ' ' ile,
        TO_CHAR(SUM(DECODE(funkcja, 'SZEFUNIO', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) szefunio,
        TO_CHAR(SUM(DECODE(funkcja, 'BANDZIOR', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) bandzior,
        TO_CHAR(SUM(DECODE(funkcja, 'LOWCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) lowczy,
        TO_CHAR(SUM(DECODE(funkcja, 'LAPACZ', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) lapacz,
        TO_CHAR(SUM(DECODE(funkcja, 'KOT', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0),0))) kot,
        TO_CHAR(SUM(DECODE(funkcja, 'MILUSIA', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) milusia,
        TO_CHAR(SUM(DECODE(funkcja, 'DZIELCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))) dzielczy,
        TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) suma
    FROM Kocury
    NATURAL JOIN BANDY
    ORDER BY 1, 2 DESC
);

-- Zadanie 33b
SELECT *
FROM
(
  SELECT
    TO_CHAR(DECODE(plec, 'D', nazwa, ' ')) "NAZWA BANDY",
    TO_CHAR(DECODE(plec, 'D', 'Kotka', 'Kocor')) plec,
    TO_CHAR(ile) ile,
    TO_CHAR(NVL(szefunio, 0)) szefunio,
    TO_CHAR(NVL(bandzior, 0)) bandzior,
    TO_CHAR(NVL(lowczy, 0)) lowczy,
    TO_CHAR(NVL(lapacz, 0)) lapacz,
    TO_CHAR(NVL(kot, 0)) kot,
    TO_CHAR(NVL(milusia, 0)) milusia,
    TO_CHAR(NVL(dzielczy, 0)) dzielczy,
    TO_CHAR(NVL(suma, 0)) suma
  FROM
  (
    SELECT nazwa, plec, funkcja, przydzial_myszy + NVL(myszy_extra, 0) liczba
    FROM Kocury
    NATURAL JOIN Bandy
  ) PIVOT (
      SUM(liczba) FOR funkcja IN (
        'SZEFUNIO' szefunio,
        'BANDZIOR' bandzior,
        'LOWCZY' lowczy,
        'LAPACZ' lapacz,
        'KOT' kot,
        'MILUSIA' milusia,
        'DZIELCZY' dzielczy
    )
  ) JOIN (
    SELECT nazwa n, plec p, COUNT(pseudo) ile, SUM(przydzial_myszy + NVL(myszy_extra, 0)) suma
    FROM Kocury
    NATURAL JOIN Bandy
    GROUP BY nazwa, plec
    ORDER BY nazwa
  ) ON n = nazwa AND p = plec
)
UNION ALL
SELECT
    'Z--------------',
    '------',
    '--------',
    '---------',
    '---------',
    '--------',
    '--------',
    '--------',
    '--------',
    '--------',
    '--------'
FROM DUAL
UNION ALL
SELECT 
    'ZJADA RAZEM',
    ' ',
    ' ',
    TO_CHAR(NVL(szefunio, 0)) szefunio,
    TO_CHAR(NVL(bandzior, 0)) bandzior,
    TO_CHAR(NVL(lowczy, 0)) lowczy,
    TO_CHAR(NVL(lapacz, 0)) lapacz,
    TO_CHAR(NVL(kot, 0)) kot,
    TO_CHAR(NVL(milusia, 0)) milusia,
    TO_CHAR(NVL(dzielczy, 0)) dzielczy,
    TO_CHAR(NVL(suma, 0)) suma
FROM
(
  SELECT funkcja, przydzial_myszy + NVL(myszy_extra, 0) liczba
  FROM Kocury
  NATURAL JOIN Bandy
) PIVOT (
    SUM(liczba) FOR funkcja IN (
        'SZEFUNIO' szefunio,
        'BANDZIOR' bandzior,
        'LOWCZY' lowczy,
        'LAPACZ' lapacz,
        'KOT' kot,
        'MILUSIA' milusia,
        'DZIELCZY' dzielczy
    )
) CROSS JOIN (
  SELECT SUM(przydzial_myszy + NVL(myszy_extra, 0)) suma
  FROM Kocury
);
