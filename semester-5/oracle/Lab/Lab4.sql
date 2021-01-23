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

DELETE FROM Myszy;
/

DECLARE
    waga_myszy_min INTEGER := 1;
    waga_myszy_max INTEGER := 10;
    start_date DATE := TO_DATE('2004-01-01');
    start_date_for_kocur DATE;
--    current_date DATE := TO_DATE('2018-01-16');
    max_month_diff INTEGER := MONTHS_BETWEEN(SYSDATE, start_date);
    months_num_for_kocur INTEGER;
    extra_pseudo VARCHAR2(10) := 'TYGRYS';
    kot_przydzial INTEGER;
    random_from_date DATE;
    random_to_date DATE;
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
    tmpMysz Myszy%ROWTYPE;

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
  OPEN kocuryC;

  LOOP
    FETCH kocuryC INTO kocur;
    EXIT WHEN kocuryC%NOTFOUND;

    IF kocur.w_stadku_od < start_date THEN
      start_date_for_kocur := start_date;
    ELSE
      start_date_for_kocur := kocur.w_stadku_od;
    END IF;

    months_num_for_kocur := MONTHS_BETWEEN(SYSDATE, start_date_for_kocur);
    kot_przydzial := kocur.przydzial_myszy + NVL(kocur.myszy_extra, 0);

    OPEN avgsC;
    OPEN srodyC;

    FOR i IN 0..(months_num_for_kocur-1)
    LOOP
      FETCH avgsC INTO avgs;
      FETCH srodyC INTO sroda;

      EXIT WHEN avgsC%NOTFOUND;
      EXIT WHEN srodyC%NOTFOUND;

      IF i = (months_num_for_kocur - 1) AND TRUNC(ADD_MONTHS(SYSDATE, -i), 'MONTH') = TRUNC(kocur.w_stadku_od, 'MONTH') THEN
        random_from_date := kocur.w_stadku_od;
      ELSE
        random_from_date := TRUNC(ADD_MONTHS(SYSDATE, -i), 'MONTH');
      END IF;

      IF i = 0 THEN
        random_to_date := SYSDATE;
      ELSE
        random_to_date := sroda;
      END IF;

      --  Własna produkcja
      FOR j IN 1..avgs
      LOOP
        -- Dla siebie
        myszyTmpTable(myszyTmpIndex).nr_myszy := numer_myszy;
        myszyTmpTable(myszyTmpIndex).zjadacz := kocur.pseudo;
        myszyTmpTable(myszyTmpIndex).lowca := kocur.pseudo;
        myszyTmpTable(myszyTmpIndex).waga_myszy := CEIL(DBMS_RANDOM.VALUE(waga_myszy_min, waga_myszy_max));
        myszyTmpTable(myszyTmpIndex).data_zlowienia := random_from_date + DBMS_RANDOM.VALUE(0, random_to_date - random_from_date);
        myszyTmpTable(myszyTmpIndex).data_wydania := sroda;

        myszyTmpIndex := myszyTmpIndex + 1;
        numer_myszy := numer_myszy + 1;
      END LOOP;
    END LOOP;

    CLOSE avgsC;
    CLOSE srodyC;
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

CREATE OR REPLACE PROCEDURE dodaj_myszy(kocur_pseudo Kocury.pseudo%TYPE, data_zlow DATE) AS
    TYPE MyszyTable IS TABLE OF MYSZY%ROWTYPE INDEX BY BINARY_INTEGER;
    myszy_do_dodania MyszyTable;

    TYPE MyszyKotaType IS RECORD (
        nr_myszy Myszy.nr_myszy%TYPE,
        waga_myszy Myszy.waga_myszy%TYPE,
        data_zlowienia Myszy.data_zlowienia%TYPE
    );
    TYPE MyszyKotaTable IS TABLE OF MyszyKotaType INDEX BY BINARY_INTEGER;
    upolowane_myszy MyszyKotaTable;

    next_nr_myszy NUMBER;
BEGIN
    SELECT MAX(nr_myszy) + 1 INTO next_nr_myszy FROM Myszy;

    EXECUTE IMMEDIATE 'SELECT * FROM MYSZY_' || kocur_pseudo || ' WHERE data_zlowienia=''' || data_zlow || ''''
    BULK COLLECT INTO upolowane_myszy;

    FOR i IN 1 .. upolowane_myszy.COUNT
    LOOP
        myszy_do_dodania(i).nr_myszy := next_nr_myszy;
        myszy_do_dodania(i).waga_myszy := upolowane_myszy(i).waga_myszy;
        myszy_do_dodania(i).data_zlowienia := upolowane_myszy(i).data_zlowienia;
        next_nr_myszy := next_nr_myszy + 1;
    END LOOP;

    FORALL i IN 1..myszy_do_dodania.COUNT
    INSERT INTO Myszy VALUES(
        myszy_do_dodania(i).nr_myszy,
        kocur_pseudo,
        NULL,
        myszy_do_dodania(i).waga_myszy,
        myszy_do_dodania(i).data_zlowienia,
        NULL
    );

    EXECUTE IMMEDIATE 'DELETE FROM MYSZY_' || kocur_pseudo || ' WHERE data_zlowienia=''' || TO_CHAR(data_zlow, 'YYYY-MM-DD') || '''';
END;

