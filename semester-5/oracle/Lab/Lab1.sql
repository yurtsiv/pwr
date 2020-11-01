CREATE TABLE Bandy
(
  nr_bandy NUMBER(2) CONSTRAINT bandy_pk PRIMARY KEY,
  nazwa VARCHAR2(20) CONSTRAINT nazwa_nn NOT NULL,
  teren VARCHAR2(15) CONSTRAINT teren_uniq UNIQUE,
  szef_bandy VARCHAR(15) 
);

CREATE TABLE Funkcje
(
  funkcja VARCHAR2(10) CONSTRAINT funkcje_pk PRIMARY KEY,
  min_myszy NUMBER(3) 
    CONSTRAINT min_myszy_check CHECK (min_myszy > 5),
  max_myszy NUMBER(3)
    CONSTRAINT max_myszy_check_max CHECK (max_myszy < 200),
  CONSTRAINT max_myszy_check_min CHECK (max_myszy >= min_myszy)
);

CREATE TABLE Wrogowie
(
  imie_wroga VARCHAR2(15) CONSTRAINT wrogowie_pk PRIMARY KEY,
  stopien_wrogosci NUMBER(2)
    CONSTRAINT stopien_wrogosci_check CHECK (stopien_wrogosci BETWEEN 1 AND 10),
  gatunek VARCHAR2(15),
  lapowka VARCHAR2(20)
);

CREATE TABLE Kocury
(
  imie VARCHAR2(15) CONSTRAINT imie_nn NOT NULL,
  plec VARCHAR2(1) CONSTRAINT plec_check CHECK (plec IN ('D', 'M')),
  pseudo VARCHAR2(15) CONSTRAINT kocury_pk PRIMARY KEY,
  funkcja VARCHAR2(10) CONSTRAINT funkcja_fk REFERENCES Funkcje(funkcja),
  szef VARCHAR2(15),
  w_stadku_od DATE DEFAULT SYSDATE,
  przydzial_myszy NUMBER(3),
  myszy_extra NUMBER(3),
  nr_bandy NUMBER(2) CONSTRAINT nr_bandy_fk REFERENCES Bandy(nr_bandy)
);

CREATE TABLE Wrogowie_Kocurow
(
  pseudo VARCHAR2(15) CONSTRAINT pseudo_fk REFERENCES Kocury(pseudo),
  imie_wroga VARCHAR2(15) CONSTRAINT imie_wroga_fk REFERENCES Wrogowie(imie_wroga),
  data_incydentu DATE CONSTRAINT data_incydentu_nn NOT NULL,
  opis_incydentu VARCHAR2(50),
  CONSTRAINT wrogowie_kocurow_pk PRIMARY KEY (pseudo, imie_wroga)
);

INSERT ALL
  INTO Funkcje VALUES ('SZEFUNIO',90,110)
  INTO Funkcje VALUES ('BANDZIOR',70,90)
  INTO Funkcje VALUES ('LOWCZY',60,70)
  INTO Funkcje VALUES ('LAPACZ',50,60)
  INTO Funkcje VALUES ('KOT',40,50)
  INTO Funkcje VALUES ('MILUSIA',20,30)
  INTO Funkcje VALUES ('DZIELCZY',45,55)
  INTO Funkcje VALUES ('HONOROWA',6,25)
SELECT * FROM dual;

INSERT ALL
  INTO Bandy VALUES (1,'SZEFOSTWO','CALOSC','TYGRYS')
  INTO Bandy VALUES (2,'CZARNI RYCERZE','POLE','LYSY')
  INTO Bandy VALUES (3,'BIALI LOWCY','SAD','ZOMBI')
  INTO Bandy VALUES (4,'LACIACI MYSLIWI','GORKA','RAFA')
  INTO Bandy VALUES (5,'ROCKERSI','ZAGRODA',NULL)
SELECT * FROM dual;

INSERT ALL
  INTO Wrogowie VALUES ('KAZIO',10,'CZLOWIEK','FLASZKA')
  INTO Wrogowie VALUES ('GLUPIA ZOSKA',1,'CZLOWIEK','KORALIK')
  INTO Wrogowie VALUES ('SWAWOLNY DYZIO',7,'CZLOWIEK','GUMA DO ZUCIA')
  INTO Wrogowie VALUES ('BUREK',4,'PIES','KOSC')
  INTO Wrogowie VALUES ('DZIKI BILL',10,'PIES',NULL)
  INTO Wrogowie VALUES ('REKSIO',2,'PIES','KOSC')
  INTO Wrogowie VALUES ('BETHOVEN',1,'PIES','PEDIGRIPALL')
  INTO Wrogowie VALUES ('CHYTRUSEK',5,'LIS','KURCZAK')
  INTO Wrogowie VALUES ('SMUKLA',1,'SOSNA',NULL)
  INTO Wrogowie VALUES ('BAZYLI',3,'KOGUT','KURA DO STADA')
SELECT * FROM dual;

ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD';

INSERT ALL
  INTO Kocury VALUES ('JACEK','M','PLACEK','LOWCZY','LYSY','2008-12-01',67,NULL,2)
  INTO Kocury VALUES ('BARI','M','RURA','LAPACZ','LYSY','2009-09-01',56,NULL,2)
  INTO Kocury VALUES ('MICKA','D','LOLA','MILUSIA','TYGRYS','2009-10-14',25,47,1)
  INTO Kocury VALUES ('LUCEK','M','ZERO','KOT','KURKA','2010-03-01',43,NULL,3)
  INTO Kocury VALUES ('SONIA','D','PUSZYSTA','MILUSIA','ZOMBI','2010-11-18',20,35,3)
  INTO Kocury VALUES ('LATKA','D','UCHO','KOT','RAFA','2011-01-01',40,NULL,4)
  INTO Kocury VALUES ('DUDEK','M','MALY','KOT','RAFA','2011-05-15',40,NULL,4)
  INTO Kocury VALUES ('MRUCZEK','M','TYGRYS','SZEFUNIO',NULL,'2002-01-01',103,33,1)
  INTO Kocury VALUES ('CHYTRY','M','BOLEK','DZIELCZY','TYGRYS','2002-05-05',50,NULL,1)
  INTO Kocury VALUES ('KOREK','M','ZOMBI','BANDZIOR','TYGRYS','2004-03-16',75,13,3)
  INTO Kocury VALUES ('BOLEK','M','LYSY','BANDZIOR','TYGRYS','2006-08-15',72,21,2)
  INTO Kocury VALUES ('ZUZIA','D','SZYBKA','LOWCZY','LYSY','2006-07-21',65,NULL,2)
  INTO Kocury VALUES ('RUDA','D','MALA','MILUSIA','TYGRYS','2006-09-17',22,42,1)
  INTO Kocury VALUES ('PUCEK','M','RAFA','LOWCZY','TYGRYS','2006-10-15',65,NULL,4)
  INTO Kocury VALUES ('PUNIA','D','KURKA','LOWCZY','ZOMBI','2008-01-01',61,NULL,3)
  INTO Kocury VALUES ('BELA','D','LASKA','MILUSIA','LYSY','2008-02-01',24,28,2)
  INTO Kocury VALUES ('KSAWERY','M','MAN','LAPACZ','RAFA','2008-07-12',51,NULL,4)
  INTO Kocury VALUES ('MELA','D','DAMA','LAPACZ','RAFA','2008-11-01',51,NULL,4)
SELECT * FROM dual;

ALTER TABLE Kocury
    ADD CONSTRAINT szef_fk FOREIGN KEY (szef) REFERENCES Kocury(pseudo);


ALTER TABLE Bandy 
    ADD CONSTRAINT szef_bandy_fk
        FOREIGN KEY (szef_bandy) REFERENCES Kocury(pseudo);

INSERT ALL
  INTO Wrogowie_Kocurow VALUES ('TYGRYS','KAZIO','2004-10-13','USILOWAL NABIC NA WIDLY')
  INTO Wrogowie_Kocurow VALUES ('ZOMBI','SWAWOLNY DYZIO','2005-03-07','WYBIL OKO Z PROCY')
  INTO Wrogowie_Kocurow VALUES ('BOLEK','KAZIO','2005-03-29','POSZCZUL BURKIEM')
  INTO Wrogowie_Kocurow VALUES ('SZYBKA','GLUPIA ZOSKA','2006-09-12','UZYLA KOTA JAKO SCIERKI')
  INTO Wrogowie_Kocurow VALUES ('MALA','CHYTRUSEK','2007-03-07','ZALECAL SIE')
  INTO Wrogowie_Kocurow VALUES ('TYGRYS','DZIKI BILL','2007-06-12','USILOWAL POZBAWIC ZYCIA')
  INTO Wrogowie_Kocurow VALUES ('BOLEK','DZIKI BILL','2007-11-10','ODGRYZL UCHO')
  INTO Wrogowie_Kocurow VALUES ('LASKA','DZIKI BILL','2008-12-12','POGRYZL ZE LEDWO SIE WYLIZALA')
  INTO Wrogowie_Kocurow VALUES ('LASKA','KAZIO','2009-01-07','ZLAPAL ZA OGON I ZROBIL WIATRAK')
  INTO Wrogowie_Kocurow VALUES ('DAMA','KAZIO','2009-02-07','CHCIAL OBEDRZEC ZE SKORY')
  INTO Wrogowie_Kocurow VALUES ('MAN','REKSIO','2009-04-14','WYJATKOWO NIEGRZECZNIE OBSZCZEKAL')
  INTO Wrogowie_Kocurow VALUES ('LYSY','BETHOVEN','2009-05-11','NIE PODZIELIL SIE SWOJA KASZA')
  INTO Wrogowie_Kocurow VALUES ('RURA','DZIKI BILL','2009-09-03','ODGRYZL OGON')
  INTO Wrogowie_Kocurow VALUES ('PLACEK','BAZYLI','2010-07-12','DZIOBIAC UNIEMOZLIWIL PODEBRANIE KURCZAKA')
  INTO Wrogowie_Kocurow VALUES ('PUSZYSTA','SMUKLA','2010-11-19','OBRZUCILA SZYSZKAMI')
  INTO Wrogowie_Kocurow VALUES ('KURKA','BUREK','2010-12-14','POGONIL')
  INTO Wrogowie_Kocurow VALUES ('MALY','CHYTRUSEK','2011-07-13','PODEBRAL PODEBRANE JAJKA')
  INTO Wrogowie_Kocurow VALUES ('UCHO','SWAWOLNY DYZIO','2011-07-14','OBRZUCIL KAMIENIAMI')
SELECT * FROM dual;

COMMIT;

--Zadanie 1
SELECT imie_wroga "WROG", opis_incydentu "PRZEWINA"
FROM Wrogowie_Kocurow
WHERE EXTRACT(YEAR FROM data_incydentu) = 2009;

-- Zadanie 2
SELECT imie, funkcja, w_stadku_od "Z NAMI OD"
FROM Kocury
WHERE plec = 'D' AND w_stadku_od BETWEEN '2005-09-01' AND '2007-07-31';
    
-- Zadanie 3
SELECT imie_wroga "WROG", gatunek, stopien_wrogosci "STOPIEN WROGOSCI"
FROM Wrogowie
WHERE lapowka IS NULL
ORDER BY stopien_wrogosci;

-- Zadanie 4
SELECT imie || ' zwany ' || pseudo || ' (fun. ' || funkcja || ') lowi myszki w bandzie ' || nr_bandy || ' od ' || w_stadku_od  "WSZYSTKO O KOCURACH"
FROM Kocury
WHERE plec = 'M'
ORDER BY w_stadku_od DESC, pseudo;

-- Zadanie 5
SELECT
    pseudo,
    REGEXP_REPLACE(
        REGEXP_REPLACE(pseudo, 'A', '#', 1, 1), 'L', '%', 1, 1
    ) "Po wymianie A na # oraz L na %"
FROM Kocury
WHERE pseudo LIKE '%A%' AND pseudo LIKE '%L%';

-- Zadanie 6
SELECT
    imie,
    w_stadku_od "W stadku",
    ROUND(przydzial_myszy / 1.1) "Zjadal",
    ADD_MONTHS(w_stadku_od, 6) "Podwyzka",
    przydzial_myszy "Zjada"
FROM Kocury
WHERE
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM w_stadku_od) > 11 AND
    EXTRACT(MONTH FROM w_stadku_od) BETWEEN 3 AND 9;
    
-- Zadanie 7
SELECT
    imie,
    przydzial_myszy * 3 "MYSZY KWARTALNIE",
    NVL(myszy_extra, 0) "KWARTALNE DODATKI"
FROM Kocury
WHERE
    przydzial_myszy >= 55 AND
    przydzial_myszy > NVL(myszy_extra, 0) * 2;


-- Zadanie 8
SELECT
    imie,
    (
        SELECT
            CASE
                WHEN rocznie > 660 THEN TO_CHAR(rocznie)
                WHEN rocznie = 660 THEN 'Limit'
                ELSE 'Ponizej 660'
            END
        FROM (
            SELECT przydzial_myszy * 12 + NVL(myszy_extra, 0) * 12 AS rocznie FROM dual
        )
    )  "Zjada rocznie"
FROM Kocury;

-- Zadanie 9

--2020-10-27
SELECT
    pseudo,
    w_stadku_od "W STADKU",
    (
        SELECT
            CASE
                WHEN day_of_month <= 15 AND last_wednesday >= '2020-10-27'
                    THEN last_wednesday
                ELSE NEXT_DAY(ADD_MONTHS('2020-10-27', 1) - 7, 'WEDNESDAY')
            END
        FROM (
            SELECT
                EXTRACT(DAY FROM w_stadku_od) AS day_of_month,
                NEXT_DAY(
                    LAST_DAY('2020-10-27') - INTERVAL '7' DAY,
                    'WEDNESDAY'
                ) AS last_wednesday
            FROM dual
        )
    ) "WYPLATA"
FROM Kocury;

--2020-10-29
SELECT
    pseudo,
    w_stadku_od "W STADKU",
    (
        SELECT
            CASE
                WHEN day_of_month <= 15 AND last_wednesday >= '2020-10-29'
                    THEN last_wednesday
                ELSE NEXT_DAY(ADD_MONTHS('2020-10-29', 1) - 7, 'WEDNESDAY')
            END
        FROM (
            SELECT
                EXTRACT(DAY FROM w_stadku_od) AS day_of_month,
                NEXT_DAY(
                    LAST_DAY('2020-10-29') - INTERVAL '7' DAY,
                    'WEDNESDAY'
                ) AS last_wednesday
            FROM dual
        )
    ) "WYPLATA"
FROM Kocury;

-- Zadanie 10

SELECT pseudo || ' - ' || NVL2(NULLIF(COUNT(*), 1), 'Nieunikalny', 'Unikalny') "Unikalnosc atr. PSEUDO"
FROM Kocury
GROUP BY pseudo;

SELECT szef || ' - ' || NVL2(NULLIF(COUNT(*), 1), 'Nieunikalny', 'Unikalny') "Unikalnosc atr. SZEF"
FROM Kocury
GROUP BY szef
HAVING szef IS NOT NULL;

-- Zadanie 11
SELECT pseudo "Pseudonim", COUNT(pseudo) "Liczba wrogow"
FROM Wrogowie_Kocurow
GROUP BY pseudo
HAVING COUNT(pseudo) >= 2;

-- Zadanie 12
SELECT 'Liczba kotow= ' || COUNT(pseudo) || ' lowi jako ' || funkcja || ' i zjada max. ' || MAX(przydzial_myszy + NVL(myszy_extra, 0)) " "
FROM Kocury
WHERE plec != 'M'
GROUP BY funkcja
HAVING
    funkcja != 'SZEFUNIO' AND
    AVG(przydzial_myszy + NVL(myszy_extra, 0)) > 50;
    
-- Zadanie 13
SELECT
    nr_bandy "Nr bandy",
    plec "Plec",
    MIN(przydzial_myszy) "Minimalny przydzial"
FROM Kocury
GROUP BY nr_bandy, plec;

-- Zadanie 14
SELECT LEVEL "Poziom", pseudo "Pseudonim", funkcja "Funkcja", nr_bandy "Nr bandy"
FROM Kocury
WHERE plec = 'M'
START WITH funkcja = 'BANDZIOR'
CONNECT BY szef = PRIOR pseudo;

-- Zadanie 15
SELECT
    LPAD(TO_CHAR(LEVEL - 1), (LEVEL -1) * 4 + LENGTH(TO_CHAR(LEVEL - 1)), '===>') || '            ' || imie "Hierarchia",
    NVL(szef, 'Sam sobie szef') "Pseudo szefa",
    funkcja "Funkcja"
FROM Kocury
WHERE myszy_extra > 0
START WITH szef IS NULL
CONNECT BY szef = PRIOR pseudo;

-- Zadanie 16
SELECT
    RPAD(' ', (LEVEL - 1) * 4, ' ') || pseudo "Droga sluzbowa"
FROM Kocury
START WITH
    plec = 'M' AND
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM w_stadku_od) > 11 AND
    myszy_extra IS NULL
CONNECT BY pseudo = PRIOR szef;