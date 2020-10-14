CREATE TABLE Bandy
(
  nr_bandy NUMBER(2) CONSTRAINT bandy_pk PRIMARY KEY,
  nazwa VARCHAR2(20) CONSTRAINT nazwa_nn NOT NULL,
  teren VARCHAR2(15)
    CONSTRAINT teren_uniq UNIQUE
)

CREATE TABLE Funkcje
(
  funkcja VARCHAR2(10) CONSTRAINT fukcje_pk PRIMARY KEY,
  min_myszy NUMBER(3) NOT NULL,
  max_myszy NUMBER(3) NOT NULL,

  CONSTRAINT check_min_myszy
    CHECK (min_myszy > 5),
  
  CONSTRAINT check_max_myszy
    CHECK (max_myszy < 200 AND max_muszy >= min_myszy)
)

CREATE TABLE Wrogowie
(
  imie_wroga VARCHAR2(15) CONSTRAINT wrogowie_pk PRIMARY KEY,
  stopien_wrogosci NUMBER(2) NOT NULL
    CONSTRAINT check_stopien
        CHECK BETWEEN 1 AND,
  gatunek VARCHAR2(15),
  lapowka VARCHAR2(20)
)

CREATE TABLE Kocury
(
  imie VARCHAR2(15) NOT NULL,
  plec VARCHAR2(1) NOT NULL
    CONSTRAINT check_plec CHECK (plec = 'M' OR plec = 'D'),
  pseudo VARCHAR2(15) CONSTRAINT kocury_pk PRIMARY KEY,
  funkcja VARCHAR2(10) NOT NULL
    CONSTRAINT funkcja_fk REFERENCES Funckje(funkcja),
  szef VARCHAR2(15) NOT NULL,
  w_stadku_od DATE DEFAULT SYSDATE,
  przydzial_myszy NUMBER(3),
  myszy_extra NUMBER(3),
  nr_bandy NUMBER(2) NOT NULL,
  
  CONSTRAINT szef_fk
    FOREIGN KEY (szef)
    REFERENCES Kocury(pseudo),
    
  CONSTRAINT nr_bandy_fk
     FOREIGN KEY (nr_bandy)
     REFERENCES Bandy(nr_bandy)
)

CREATE TABLE Wrogowie_Kocurow
(
  pseudo VARCHAR2(15) NOT NULL,
  imie_wroga VARCHAR2(15) NOT NULL,
  data_incydentu DATE NOT NULL,
  opis_incydentu VARCHAR2(50),
  CONSTRAINT wrogowie_kocurow_pk
    PRIMARY KEY (pseudo, imie_wroga),
  CONSTRAINT pseudo_fk
    FOREIGN KEY (pseudo)
    REFERENCES Kocury(pseudo),

  CONSTRAINT imie_wroga_fk
    FOREIGN KEY (imie_wroga)
    REFERENCES Wrogowie(imie_wroga)
)