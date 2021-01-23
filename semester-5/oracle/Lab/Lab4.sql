DROP TYPE KotO FORCE;
DROP TYPE PlebsO FORCE;
DROP TYPE ElitaO FORCE;
DROP TYPE KontoWpisO FORCE;

DROP TYPE plebs FORCE;

-- DROP TABLE Bandy CASCADE CONSTRAINTS;
-- DROP TABLE Funkcje CASCADE CONSTRAINTS;
DROP TABLE Elita CASCADE CONSTRAINTS; 
DROP TABLE Plebs CASCADE CONSTRAINTS;
DROP TABLE Kocury_t CASCADE CONSTRAINTS; 

CREATE OR REPLACE TYPE KotO AS OBJECT
(
    imie VARCHAR2(15),
    plec VARCHAR(1),
    pseudo VARCHAR(15),
    funkcja VARCHAR2(10),
    szef VARCHAR(15),
    w_stadku_od DATE,
    przydzial_myszy NUMBER(3),
    myszy_extra NUMBER(3)
);

CREATE OR REPLACE TYPE PlebsO AS OBJECT
(
    idn NUMBER(3),
    kot REF KotO
);

CREATE OR REPLACE TYPE ElitaO AS OBJECT
(
    idn NUMBER(3),
    kot REF KotO,
    sluga REF PlebsO
);


CREATE OR REPLACE TYPE KontoWpisO AS OBJECT
(
    dataWprowadzenia DATE,
    dataUsuniecia DATE,
    wlasciciel REF ElitaO
);


CREATE TABLE Kocury_t OF KotO (
    CONSTRAINT kocury_t_pk PRIMARY KEY (pseudo)
)

CREATE TABLE Plebs OF PlebsO (
    CONSTRAINT plebs_pk PRIMARY KEY (idn)
)

CREATE TABLE Elita OF ElitaO (
    CONSTRAINT elita_pk PRIMARY KEY (idn)
)

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


DELETE FROM Plebs;
INSERT INTO Plebs
    SELECT PlebsO(ROWNUM, REF(K))
    FROM Kocury_t K
    WHERE K.funkcja NOT IN ('SZEFUNIO', 'BANDZIOR', 'MILUSIA')


DELETE FROM Elita;

INSERT INTO Elita
    SELECT ElitaO(
        ROWNUM,
        REF(K),
        NULL
    )
    FROM Kocury_t K
    WHERE K.funkcja IN ('SZEFUNIO', 'BANDZIOR', 'MILUSIA')

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

UPDATE Elita
SET sluga = (
    SELECT * FROM
    (SELECT REF(P) FROM Plebs P
        ORDER BY dbms_random.value
    )
    WHERE rownum = 1
)

SELECT * FROM
( SELECT idn FROM Plebs
ORDER BY dbms_random.value )
WHERE rownum = 1

SELECT idn FROM Plebs T WHERE ROWNUM = TRUNC(DBMS_RANDOM.value(0, 3))

SELECT idn, VALUE(E).kot.imie, VALUE(E).sluga.kot.imie
FROM Elita E;
