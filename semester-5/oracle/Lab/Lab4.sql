DROP TYPE KotO FORCE;
DROP TYPE PlebsO FORCE;
DROP TYPE ElitaO FORCE;
DROP TYPE KontoWpisO FORCE;

DROP TABLE Elita CASCADE CONSTRAINTS; 
DROP TABLE Plebs CASCADE CONSTRAINTS;
DROP TABLE Kocury_t CASCADE CONSTRAINTS; 
DROP TABLE Konta CASCADE CONSTRAINTS;

CREATE OR REPLACE TYPE KotO AS OBJECT
(
    imie VARCHAR2(15),
    plec VARCHAR2(1),
    pseudo VARCHAR2(15),
    funkcja VARCHAR2(10),
    szef VARCHAR2(15),
    w_stadku_od DATE,
    przydzial_myszy NUMBER(3),
    myszy_extra NUMBER(3),

    MEMBER FUNCTION calk_przydzial RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY KotO AS
    MEMBER FUNCTION calk_przydzial RETURN NUMBER IS
    BEGIN
        RETURN przydzial_myszy + NVL(myszy_extra, 0);
    END;
END;
/

CREATE OR REPLACE TYPE PlebsO AS OBJECT
(
    idn NUMBER(3),
    kot REF KotO,
    
    MEMBER FUNCTION pseudo RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY PlebsO AS
    MEMBER FUNCTION pseudo RETURN VARCHAR2 IS
        ps VARCHAR(15);
    BEGIN
        SELECT DEREF(kot).pseudo INTO ps FROM dual;
        RETURN ps;
    END;
END;
/

CREATE OR REPLACE TYPE ElitaO AS OBJECT
(
    idn NUMBER(3),
    kot REF KotO,
    sluga REF PlebsO,
    
    MEMBER FUNCTION pseudo RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY ElitaO AS
    MEMBER FUNCTION pseudo RETURN VARCHAR2 IS
        ps VARCHAR(15);
    BEGIN
        SELECT DEREF(kot).pseudo INTO ps FROM dual;
        RETURN ps;
    END;
END;
/

CREATE OR REPLACE TYPE KontoWpisO AS OBJECT
(
    idn NUMBER(3),
    dataWprowadzenia DATE,
    dataUsuniecia DATE,
    wlasciciel REF ElitaO,

    MEMBER FUNCTION usuniety RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY KontoWpisO AS
    MEMBER FUNCTION usuniety RETURN VARCHAR2 IS
        res VARCHAR2(5);
    BEGIN
        IF dataUsuniecia IS NULL THEN
            RETURN 'NIE';
        ELSE
            RETURN 'TAK';
        END IF;
    END;
END;
/

CREATE TABLE Kocury_t OF KotO (
    CONSTRAINT kocury_t_pk PRIMARY KEY (pseudo)
);
/

CREATE TABLE Plebs OF PlebsO (
    CONSTRAINT plebs_pk PRIMARY KEY (idn)
);
/

CREATE TABLE Elita OF ElitaO (
    CONSTRAINT elita_pk PRIMARY KEY (idn)
);
/

CREATE TABLE Konta OF KontoWpisO(
    CONSTRAINT konta_pk PRIMARY KEY (idn)
);
/

INSERT ALL
  INTO Kocury_t VALUES (KotO('JACEK','M','PLACEK','LOWCZY','LYSY','2008-12-01',67,NULL))
  INTO Kocury_t VALUES (KotO('BARI','M','RURA','LAPACZ','LYSY','2009-09-01',56,NULL))
  INTO Kocury_t VALUES (KotO('MICKA','D','LOLA','MILUSIA','TYGRYS','2009-10-14',25,47))
  INTO Kocury_t VALUES (KotO('LUCEK','M','ZERO','KOT','KURKA','2010-03-01',43,NULL))
  INTO Kocury_t VALUES (KotO('SONIA','D','PUSZYSTA','MILUSIA','ZOMBI','2010-11-18',20,35))
  INTO Kocury_t VALUES (KotO('LATKA','D','UCHO','KOT','RAFA','2011-01-01',40,NULL))
  INTO Kocury_t VALUES (KotO('DUDEK','M','MALY','KOT','RAFA','2011-05-15',40,NULL))
  INTO Kocury_t VALUES (KotO('MRUCZEK','M','TYGRYS','SZEFUNIO',NULL,'2002-01-01',103,33))
  INTO Kocury_t VALUES (KotO('CHYTRY','M','BOLEK','DZIELCZY','TYGRYS','2002-05-05',50,NULL))
  INTO Kocury_t VALUES (KotO('KOREK','M','ZOMBI','BANDZIOR','TYGRYS','2004-03-16',75,13))
  INTO Kocury_t VALUES (KotO('BOLEK','M','LYSY','BANDZIOR','TYGRYS','2006-08-15',72,21))
  INTO Kocury_t VALUES (KotO('ZUZIA','D','SZYBKA','LOWCZY','LYSY','2006-07-21',65,NULL))
  INTO Kocury_t VALUES (KotO('RUDA','D','MALA','MILUSIA','TYGRYS','2006-09-17',22,42))
  INTO Kocury_t VALUES (KotO('PUCEK','M','RAFA','LOWCZY','TYGRYS','2006-10-15',65,NULL))
  INTO Kocury_t VALUES (KotO('PUNIA','D','KURKA','LOWCZY','ZOMBI','2008-01-01',61,NULL))
  INTO Kocury_t VALUES (KotO('BELA','D','LASKA','MILUSIA','LYSY','2008-02-01',24,28))
  INTO Kocury_t VALUES (KotO('KSAWERY','M','MAN','LAPACZ','RAFA','2008-07-12',51,NULL))
  INTO Kocury_t VALUES (KotO('MELA','D','DAMA','LAPACZ','RAFA','2008-11-01',51,NULL))
SELECT * FROM dual;
/

INSERT INTO Plebs
    SELECT PlebsO(ROWNUM, REF(K))
    FROM Kocury_t K
    WHERE K.funkcja NOT IN ('SZEFUNIO', 'BANDZIOR', 'MILUSIA');
/

INSERT INTO Elita
    SELECT ElitaO(
        ROWNUM,
        REF(K),
        NULL
    )
    FROM Kocury_t K
    WHERE K.funkcja IN ('SZEFUNIO', 'BANDZIOR', 'MILUSIA');
/

INSERT INTO Konta
    SELECT KontoWpisO(ROWNUM, CURRENT_DATE, NULL, REF(E))
    FROM Elita E;
/

-- Przypisz losowych sług do elity
DECLARE
    CURSOR elita_c IS SELECT idn FROM Elita;
    sluga_rand NUMBER := 0;
BEGIN
    FOR e IN elita_c
    LOOP
        SELECT dbms_random.value INTO sluga_rand FROM dual;
        
        UPDATE Elita
        SET sluga = (
            SELECT * FROM
            (SELECT REF(P) FROM Plebs P
                ORDER BY dbms_random.value
            )
            WHERE rownum = 1
        )
        WHERE idn = e.idn;
    END LOOP;
END;
/


-- REF w JOIN (elita i ich sługi)
SELECT K.pseudo, E.sluga.pseudo() "Sluga"
FROM Kocury_t K JOIN Elita E ON E.kot = REF(K);
/

-- Podzapytanie (sługi)
SELECT ("sluga").pseudo()
FROM Kocury_t K JOIN (
    SELECT DEREF(E.sluga) "sluga" FROM Elita E
) ON ("sluga").kot = REF(k);
/

-- Grupowanie
SELECT K.funkcja, SUM(K.calk_przydzial()) "Calk. przydzial"
FROM Kocury_t K
GROUP BY K.funkcja;
/

-- Zadanie 18
SELECT K1.imie, K1.w_stadku_od "POLUJE OD"
FROM Kocury_t K1, Kocury_t K2
WHERE K2.imie = 'JACEK' AND K1.w_stadku_od < K2.w_stadku_od
ORDER BY K1.w_stadku_od DESC;

-- Zadanie 19c
SELECT imie, funkcja, SUBSTR(MAX(szefowie), 17) "Imiona kolejnych szefów"
FROM (
    SELECT CONNECT_BY_ROOT imie imie,
           CONNECT_BY_ROOT funkcja funkcja,
           SYS_CONNECT_BY_PATH(RPAD(imie, 10), ' | ') szefowie
    FROM Kocury_t
    CONNECT BY PRIOR szef = pseudo
    START WITH funkcja IN ('KOT', 'MILUSIA')
)
GROUP BY imie, funkcja;

-- Zadanie 34
DECLARE
    var_funkcja Kocury.funkcja%TYPE := '&Funkcja';
    kocury_num NUMBER;
BEGIN
    SELECT COUNT(*) INTO kocury_num FROM Kocury_t WHERE funkcja = var_funkcja;
    
    IF kocury_num > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Znaleziono kota pełniącego funkcję ' || var_funkcja);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono żadnego kota');
    END IF;
END;

-- Zadanie 37
DECLARE
    CURSOR koty IS
        SELECT (przydzial_myszy + NVL(myszy_extra, 0)) zjada, pseudo
        FROM Kocury_t
        ORDER BY zjada DESC;

    nr NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Nr    Pseudonim    Zjada');
    DBMS_OUTPUT.PUT_LINE('------------------------');

    FOR kot IN koty
    LOOP
        DBMS_OUTPUT.PUT_LINE(LPAD(nr, 2) || ' ' || LPAD(kot.pseudo, 12)|| ' ' || LPAD(kot.zjada, 8));
        nr := nr + 1;
        EXIT WHEN nr > 5;
    END LOOP;
END;
/

-- 49a
CREATE TABLE Myszy(
    nr_myszy NUMBER CONSTRAINT myszy_pk PRIMARY KEY,
    lowca VARCHAR2(10) CONSTRAINT lowca_fk REFERENCES Kocury(pseudo),
    zjadacz VARCHAR2(10) CONSTRAINT zjadacz_fk REFERENCES Kocury(pseudo),
    waga_myszy NUMBER(3),
    data_zlowienia DATE,
    data_wydania DATE
);
/

CREATE TABLE Myszy_tmp(
    nr_myszy NUMBER CONSTRAINT myszy_tmp_pk PRIMARY KEY,
    lowca VARCHAR2(10) CONSTRAINT lowca_tmp_fk REFERENCES Kocury(pseudo),
    zjadacz VARCHAR2(10) CONSTRAINT zjadacz_tmp_fk REFERENCES Kocury(pseudo),
    waga_myszy NUMBER(3),
    data_zlowienia DATE,
    data_wydania DATE
);
/


DROP TABLE Myszy CASCADE CONSTRAINTS;
/
DROP TABLE Myszy_tmp CASCADE CONSTRAINTS;
/

DECLARE
    from_date DATE := TO_DATE('2004-01-01');
    cat_date DATE;
    cat_date_record DATE;
    current_date DATE := TO_DATE('2018-01-16');
    max_month_diff INTEGER := MONTHS_BETWEEN(current_date, from_date);
    months_b INTEGER;
    extra_pseudo VARCHAR2(10) := 'TYGRYS';
    kocur_przydzial INTEGER;
    randFromDate DATE;
    randToDate DATE;
    kot_max INTEGER;

    suma INTEGER := 0;
    dostepnych INTEGER;

    TYPE MyszyTmp IS TABLE OF Myszy%ROWTYPE INDEX BY BINARY_INTEGER;
    myszyTmpTable MyszyTmp;
    myszyTmpIndex BINARY_INTEGER := 1;
    numer_myszy NUMBER := 1;


    CURSOR kocuryC IS SELECT * FROM Kocury ORDER BY przydzial_myszy + NVL(myszy_extra, 0), w_stadku_od;
    kocur Kocury%ROWTYPE;

    TYPE myszyCT IS REF CURSOR;
    myszyC myszyCT;
    tmpMysz myszy_tmp%ROWTYPE;

    CURSOR avgsC IS (
        SELECT (
            SELECT CEIL(AVG(przydzial_myszy + NVL(myszy_extra, 0)))
            FROM kocury
            WHERE w_stadku_od < "dat"
        )
        FROM (
            SELECT trunc(LAST_DAY(ADD_MONTHS(SYSDATE, -rn + 1))) "dat"
            FROM (
                SELECT rownum rn
                FROM dual
                CONNECT BY level <= max_month_diff + 1
            ) dates
        )
    );

    avgs INTEGER;

    CURSOR srodyC IS (
        SELECT NEXT_DAY(LAST_DAY(ADD_MONTHS(SYSDATE, -rn + 1)) - 7, 3) "dat"
        FROM (
            SELECT rownum rn
            FROM dual
            CONNECT BY level <= max_month_diff +1
        )
    );

    sroda DATE;
BEGIN
  DELETE FROM myszy_Tmp;

  OPEN kocuryC;

  LOOP
    FETCH kocuryC INTO kocur;
    EXIT WHEN kocuryC%NOTFOUND;

    IF kocur.w_stadku_od < from_date THEN
      cat_date := from_date;
    ELSE
      cat_date := kocur.w_stadku_od;
    END IF;

    cat_date_record := cat_date;
    months_b := MONTHS_BETWEEN(current_date, cat_date);
    kocur_przydzial := kocur.przydzial_myszy + NVL(kocur.myszy_extra, 0);

    OPEN avgsC;
    OPEN srodyC;

    FOR i IN 0..(months_b-1)
    LOOP
      FETCH avgsC INTO avgs;
      FETCH srodyC INTO sroda;

      EXIT WHEN avgsC%NOTFOUND;
      EXIT WHEN srodyC%NOTFOUND;

      IF i = (months_b-1) AND TRUNC(ADD_MONTHS(current_date, -i), 'MONTH') = TRUNC(kocur.w_stadku_od, 'MONTH') THEN
        randFromDate := kocur.w_stadku_od;
      ELSE
        randFromDate := TRUNC(ADD_MONTHS(current_date, -i), 'MONTH');
      END IF;

      IF i = 0 THEN
        randToDate := current_date;
      ELSE
        randToDate := sroda;
      END IF;

      --       Ile kot moze wytworzyc i zjesc
      IF kocur_przydzial <= avgs THEN
        kot_max := kocur_przydzial;
      ELSE
        kot_max := avgs;
      END IF;

      --  Własna produkcja
      FOR j IN 1..kot_max
      LOOP
        --          Dla siebie
        myszyTmpTable(myszyTmpIndex).nr_myszy := numer_myszy;
        myszyTmpTable(myszyTmpIndex).zjadacz := kocur.pseudo;
        myszyTmpTable(myszyTmpIndex).lowca := kocur.pseudo;
        myszyTmpTable(myszyTmpIndex).waga_myszy := CEIL(DBMS_RANDOM.VALUE(16, 60));
        myszyTmpTable(myszyTmpIndex).data_zlowienia := randFromDate + DBMS_RANDOM.VALUE(0, randToDate - randFromDate);
        myszyTmpTable(myszyTmpIndex).data_wydania := sroda;

        myszyTmpIndex := myszyTmpIndex + 1;
        numer_myszy := numer_myszy + 1;
      END LOOP;

      IF avgs >= kocur_przydzial THEN
        suma := suma + (avgs - kocur_przydzial);
        --         Powyzej przydzialu kota
        FOR k IN 1..(avgs - kocur_przydzial)
        LOOP
          INSERT INTO myszy_tmp VALUES(numer_myszy, kocur.pseudo, NULL,
                                       CEIL(DBMS_RANDOM.VALUE(16, 60)),
                                       randFromDate + DBMS_RANDOM.VALUE(0, randToDate - randFromDate), sroda);
          numer_myszy := numer_myszy + 1;
        END LOOP;
      ELSE
        --         Ponizej przydzilu kota
        OPEN myszyC FOR SELECT * FROM myszy_tmp WHERE TRUNC(data_zlowienia, 'MONTH') = TRUNC(randFromDate, 'MONTH')
                                                      AND TRUNC(data_wydania, 'MONTH') = TRUNC(randToDate, 'MONTH');
        FOR k IN 1..(kocur_przydzial - avgs)
        LOOP
          FETCH myszyC INTO tmpMysz;
          EXIT WHEN myszyC%NOTFOUND;
          myszyTmpTable(myszyTmpIndex).nr_myszy := tmpMysz.nr_myszy;
          myszyTmpTable(myszyTmpIndex).zjadacz := kocur.pseudo;
          myszyTmpTable(myszyTmpIndex).lowca := tmpMysz.lowca;
          myszyTmpTable(myszyTmpIndex).waga_myszy := tmpmysz.waga_myszy;
          myszyTmpTable(myszyTmpIndex).data_zlowienia := tmpmysz.data_zlowienia;
          myszyTmpTable(myszyTmpIndex).data_wydania := tmpmysz.data_wydania;
          myszyTmpIndex := myszyTmpIndex + 1;
          DELETE FROM myszy_tmp WHERE nr_myszy = tmpmysz.nr_myszy;
        END LOOP;
      END IF;
    END LOOP;
    CLOSE avgsC;
    CLOSE srodyC;
  END LOOP;


  OPEN myszyC FOR SELECT *  FROM myszy_tmp;
  LOOP
    FETCH myszyC INTO tmpMysz;
    EXIT WHEN myszyC%NOTFOUND;

    myszyTmpTable(myszyTmpIndex).nr_myszy := tmpMysz.nr_myszy;
    myszyTmpTable(myszyTmpIndex).zjadacz := extra_pseudo;
    myszyTmpTable(myszyTmpIndex).lowca := tmpMysz.lowca;
    myszyTmpTable(myszyTmpIndex).waga_myszy := tmpmysz.waga_myszy;
    myszyTmpTable(myszyTmpIndex).data_zlowienia := tmpmysz.data_zlowienia;
    myszyTmpTable(myszyTmpIndex).data_wydania := tmpmysz.data_wydania;
    myszyTmpIndex := myszyTmpIndex + 1;
    DELETE FROM myszy_tmp WHERE nr_myszy = tmpmysz.nr_myszy;
  END LOOP;

  FORALL i IN 1 .. myszyTmpTable.COUNT
  INSERT INTO Myszy VALUES (
    myszyTmpTable(i).nr_myszy,
    myszyTmpTable(i).lowca,
    myszyTmpTable(i).zjadacz,
    myszyTmpTable(i).waga_myszy,
    myszyTmpTable(i).data_zlowienia,
    myszyTmpTable(i).data_wydania
  );
END;
/