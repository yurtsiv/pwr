SET SERVEROUTPUT ON

-- Zadanie 34
DECLARE
    var_funkcja Kocury.funkcja%TYPE := '&Funkcja';
    kocury_num NUMBER;
BEGIN
    SELECT COUNT(*) INTO kocury_num FROM Kocury WHERE funkcja = var_funkcja;
    
    IF kocury_num > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Znaleziono kota pełniącego funkcję ' || var_funkcja);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono żadnego kota');
    END IF;
END;

-- Zadanie 35
DECLARE
    var_pseudo Kocury.pseudo%TYPE := '&Pseudo';
    kocur Kocury%ROWTYPE;
    res VARCHAR(100) := '';
BEGIN
    SELECT * INTO kocur FROM Kocury WHERE pseudo = var_pseudo;

    IF (kocur.przydzial_myszy + NVL(kocur.myszy_extra, 0)) * 12 > 770 THEN
        res := res || 'calkowity roczny przydzial myszy > 700' || CHR(10);
    END IF;

    IF INSTR(var_pseudo, 'A') <> 0 THEN
        res := res || 'imię zawiera litere A' || CHR(10);
    END IF;
    
    IF EXTRACT(MONTH FROM kocur.w_stadku_od) = 5 THEN
        res := res || 'maj jest miesiacem przystapienia do stada' || CHR(10);
    END IF;

    IF res IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(res);
    ELSE
        DBMS_OUTPUT.PUT_LINE('nie odpowiada kryteriom');
    END IF;
EXCEPTION
    WHEN no_data_found
    THEN DBMS_OUTPUT.PUT_LINE('Nie znaleziono kota o podanym pseudo');
END;

-- Zadanie 36
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR do_podwyzki IS
        SELECT pseudo, przydzial_myszy, max_myszy
        FROM Kocury NATURAL JOIN Funkcje
        ORDER BY przydzial_myszy
        FOR UPDATE OF przydzial_myszy;
    
    CURSOR kocury_c IS
        SELECT imie, przydzial_myszy
        FROM Kocury
        ORDER BY przydzial_myszy;

    sum_myszy NUMBER;
    next_myszy NUMBER;
    sum_updates NUMBER := 0;
BEGIN
    SELECT SUM(przydzial_myszy) INTO sum_myszy FROM Kocury;

    <<loop1>>LOOP
        FOR re IN do_podwyzki
        LOOP
            next_myszy := LEAST(re.max_myszy, ROUND(1.1 * re.przydzial_myszy));

            UPDATE Kocury
            SET przydzial_myszy = next_myszy
            WHERE pseudo = re.pseudo;
                      
            sum_myszy := sum_myszy + (next_myszy - re.przydzial_myszy);
            
            IF next_myszy <> re.przydzial_myszy THEN
                sum_updates := sum_updates + 1;
            END IF;

            EXIT loop1 WHEN sum_myszy > 1050;
        END LOOP;
    END LOOP loop1;
    
    DBMS_OUTPUT.PUT_LINE('Calk. przydzial w stadku ' || sum_myszy || ' Zmian - ' || sum_updates);

    DBMS_OUTPUT.PUT_LINE(RPAD('IMIE', 15) || RPAD('Myszki po podwyzce', 20));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));

    FOR kocur IN kocury_c
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(kocur.imie, 15) || RPAD(kocur.przydzial_myszy, 20));
    END LOOP;

    ROLLBACK;
END;

-- Zadanie 37
DECLARE
    CURSOR koty IS
        SELECT (przydzial_myszy + NVL(myszy_extra, 0)) zjada, pseudo
        FROM Kocury
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

-- Zadanie 38
DECLARE
    max_depth POSITIVE := '&LiczbaPrzelozonych';
    var_depth POSITIVE;

    CURSOR koty IS
        SELECT imie, szef
        FROM Kocury
        WHERE funkcja IN ('KOT', 'MILUSIA');
    
    kot_tmp koty%ROWTYPE;
BEGIN
    SELECT MAX(LEVEL) - 1 INTO var_depth
    FROM Kocury
    CONNECT BY szef = PRIOR pseudo
    START WITH szef IS NULL;
    
    var_depth := LEAST(var_depth, max_depth);

    -- Header
    DBMS_OUTPUT.PUT('| ' || RPAD('Imie', 15));
    FOR i IN 1..var_depth
    LOOP
        DBMS_OUTPUT.PUT( '| ' || RPAD('Szef ' || i, 15));
    END LOOP;
    DBMS_OUTPUT.NEW_LINE();
    DBMS_OUTPUT.PUT_LINE(RPAD('-', (var_depth + 1) * 15, '-'));
    
    FOR kot IN koty
    LOOP
        DBMS_OUTPUT.PUT( '| ' || RPAD(kot.imie, 15));

        kot_tmp := kot;
        FOR i IN 1..var_depth
        LOOP
            IF  kot_tmp.szef IS NULL THEN
                DBMS_OUTPUT.PUT('| ' || RPAD(' ', 15));
            ELSE
                SELECT imie, szef INTO kot_tmp
                FROM Kocury
                WHERE pseudo = kot_tmp.szef;
                DBMS_OUTPUT.PUT('| ' || RPAD(kot_tmp.imie, 15));
            END IF;
        END LOOP;

        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END; 

-- Zadanie 39
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

    nr_b Bandy.nr_bandy%TYPE := '&Nr';
    nazwa_b Bandy.nazwa%TYPE := '&Nazwa';
    teren_b Bandy.teren%TYPE := '&Teren';
    ilosc_b NUMBER := 0;
    blad VARCHAR(30) := '';
    
    CURSOR bandy_c IS SELECT * FROM Bandy;

    ZLY_NUMER EXCEPTION;
    BANDA_ISTNIEJE EXCEPTION;
BEGIN
    IF nr_b <= 0 THEN
        RAISE ZLY_NUMER;
    END IF;
    
    SELECT COUNT(*) INTO ilosc_b
    FROM Bandy
    WHERE nr_bandy = nr_b;

    IF ilosc_b > 0 THEN
        blad := blad || nr_b;
    END IF;

    SELECT COUNT(*) INTO ilosc_b
    FROM Bandy
    WHERE nazwa = nazwa_b;

    IF ilosc_b > 0 THEN
        blad := blad || ' ' || nazwa_b;
    END IF;

    SELECT COUNT(*) INTO ilosc_b
    FROM Bandy
    WHERE teren = teren_b;
    
    IF ilosc_b > 0 THEN
        blad := blad || ' ' || teren_b;
    END IF;
    
    IF blad IS NOT NULL THEN
        RAISE BANDA_ISTNIEJE;
    END IF;

    INSERT INTO Bandy (nr_bandy, nazwa, teren) values (nr_b, nazwa_b, teren_b);
    
    DBMS_OUTPUT.PUT_LINE(RPAD('Nr bandy', 10) || RPAD('Nazwa', 20) || RPAD('Teren', 20));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 30, '-'));

    FOR b IN bandy_c
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(b.nr_bandy, 10) || RPAD(b.nazwa, 20) || RPAD(b.teren, 20)); 
    END LOOP;
    
    ROLLBACK;
EXCEPTION
    WHEN ZLY_NUMER THEN
        DBMS_OUTPUT.PUT_LINE('Numer bandy musi byc > 0');
    WHEN BANDA_ISTNIEJE THEN
        DBMS_OUTPUT.PUT_LINE(blad || ': juz istnieje');
END;

-- Zadanie 40
CREATE OR REPLACE
PROCEDURE dodaj_bande (
    nr_b Bandy.nr_bandy%TYPE,
    nazwa_b Bandy.nazwa%TYPE,
    teren_b Bandy.teren%TYPE
)
AS
    ilosc_b NUMBER := 0;
    blad VARCHAR(50) := '';

    ZLY_NUMER EXCEPTION;
    BANDA_ISTNIEJE EXCEPTION;
BEGIN
    IF nr_b <= 0 THEN
        RAISE ZLY_NUMER;
    END IF;

    SELECT COUNT(*) INTO ilosc_b
    FROM Bandy
    WHERE nr_bandy = nr_b;

    IF ilosc_b > 0 THEN
        blad := blad || nr_b;
    END IF;

    SELECT COUNT(*) INTO ilosc_b
    FROM Bandy
    WHERE nazwa = nazwa_b;

    IF ilosc_b > 0 THEN
        blad := blad || ' ' || nazwa_b;
    END IF;

    SELECT COUNT(*) INTO ilosc_b
    FROM Bandy
    WHERE teren = teren_b;
    
    IF ilosc_b > 0 THEN
        blad := blad || ' ' || teren_b;
    END IF;
    
    IF blad IS NOT NULL THEN
        RAISE BANDA_ISTNIEJE;
    END IF;

    INSERT INTO Bandy (nr_bandy, nazwa, teren) values (nr_b, nazwa_b, teren_b);
EXCEPTION
    WHEN ZLY_NUMER THEN
        DBMS_OUTPUT.PUT_LINE('Numer bandy musi byc > 0');
    WHEN BANDA_ISTNIEJE THEN
        DBMS_OUTPUT.PUT_LINE(blad || ': juz istnieje');
END;

-- Testy
-- EXECUTE dodaj_bande(-1, 'nowa banda', 'nowy teren');
-- EXECUTE dodaj_bande(1, 'SZEFOSTWO', 'POLE');
-- EXECUTE dodaj_bande(6, 'SZEFOSTWO', 'POLE');
-- EXECUTE dodaj_bande(6, 'NOWA BANDA', 'POLE');
-- EXECUTE dodaj_bande(6, 'NOWA BANDA', 'NOWY TEREN');

SELECT * FROM Bandy;
ROLLBACK;

-- Zadanie 41
CREATE OR REPLACE TRIGGER nr_bandy
BEFORE INSERT ON Bandy
FOR EACH ROW
BEGIN
    SELECT MAX(nr_bandy) + 1 INTO :NEW.nr_bandy FROM Bandy;
END;

EXECUTE dodaj_bande(20, 'NOWA BANDA', 'NOWY TEREN');

SELECT * FROM Bandy;
ROLLBACK;

-- Zadanie 42a
CREATE OR REPLACE PACKAGE virus AS
    running BOOLEAN := FALSE;
    should_update BOOLEAN := FALSE;
    odjac_w_tygrysa BOOLEAN := FALSE;
    przydzial_tygrysa_p NUMBER;
END;

CREATE OR REPLACE TRIGGER przydzial_tygrysa_p
BEFORE UPDATE ON Kocury
BEGIN
    SELECT (przydzial_myszy * 0.1) INTO virus.przydzial_tygrysa_p
    FROM KOCURY
    WHERE PSEUDO = 'TYGRYS';
END;

CREATE OR REPLACE TRIGGER przydzial_milus
BEFORE UPDATE ON Kocury
FOR EACH ROW
BEGIN
    IF :NEW.funkcja = 'MILUSIA' AND NOT virus.running THEN
        virus.should_update := TRUE;

        IF :NEW.przydzial_myszy < :OLD.przydzial_myszy THEN
            :NEW.przydzial_myszy := :OLD.przydzial_myszy;
        END IF;
        
        IF :NEW.przydzial_myszy - :OLD.przydzial_myszy < virus.przydzial_tygrysa_p THEN
            virus.odjac_w_tygrysa := TRUE;

            :NEW.przydzial_myszy := :NEW.przydzial_myszy + virus.przydzial_tygrysa_p;
            :NEW.myszy_extra := NVL(:NEW.myszy_extra, 0) + 5;
        END IF;
    END If;
END;

CREATE OR REPLACE TRIGGER mod_przydzial_tygrysa
AFTER UPDATE ON Kocury
BEGIN
    IF virus.should_update THEN
        virus.running := TRUE;
        virus.should_update := FALSE;

        IF virus.odjac_w_tygrysa THEN
            virus.odjac_w_tygrysa := FALSE;

            UPDATE Kocury
            SET przydzial_myszy = przydzial_myszy - virus.przydzial_tygrysa_p
            WHERE pseudo = 'TYGRYS';
        ELSE
            UPDATE Kocury
            SET myszy_extra = myszy_extra + 5
            WHERE pseudo = 'TYGRYS';
        END IF;
        
        virus.running := FALSE;
    END IF;
END;

-- Test 1
SELECT * FROM Kocury;

UPDATE Kocury
SET przydzial_myszy = przydzial_myszy + 1
WHERE funkcja = 'MILUSIA';

SELECT * FROM Kocury;

ROLLBACK;

-- Test 2
SELECT * FROM Kocury;

UPDATE Kocury
SET przydzial_myszy = przydzial_myszy + 100
WHERE funkcja = 'MILUSIA';

SELECT * FROM Kocury;

ROLLBACK;

ALTER TRIGGER przydzial_tygrysa_p DISABLE;
ALTER TRIGGER przydzial_milus DISABLE;
ALTER TRIGGER mod_przydzial_tygrysa DISABLE;

-- ALTER TRIGGER przydzial_tygrysa_p ENABLE;
-- ALTER TRIGGER przydzial_milus ENABLE;
-- ALTER TRIGGER mod_przydzial_tygrysa ENABLE;


-- Zadanie 42b
CREATE OR REPLACE TRIGGER virus
FOR UPDATE
ON Kocury
COMPOUND TRIGGER
    should_update BOOLEAN := FALSE;
    odjac_w_tygrysa BOOLEAN := FALSE;
    przydzial_tygrysa_p NUMBER;

    BEFORE STATEMENT IS
    BEGIN
        SELECT (przydzial_myszy * 0.1) INTO przydzial_tygrysa_p
        FROM KOCURY
        WHERE PSEUDO = 'TYGRYS';
    END BEFORE STATEMENT;

    BEFORE EACH ROW IS
    BEGIN
        IF :NEW.funkcja = 'MILUSIA' THEN
            should_update := TRUE;

            IF :NEW.przydzial_myszy < :OLD.przydzial_myszy THEN
                :NEW.przydzial_myszy := :OLD.przydzial_myszy;
            END IF;
        
            IF :NEW.przydzial_myszy - :OLD.przydzial_myszy < przydzial_tygrysa_p THEN
                odjac_w_tygrysa := TRUE;

                :NEW.przydzial_myszy := :NEW.przydzial_myszy + przydzial_tygrysa_p;
                :NEW.myszy_extra := NVL(:NEW.myszy_extra, 0) + 5;
            END IF;
        END If;
    END BEFORE EACH ROW;
    
    AFTER STATEMENT IS
    BEGIN
        IF should_update THEN
            should_update := FALSE;

            IF odjac_w_tygrysa THEN
                odjac_w_tygrysa := FALSE;

                UPDATE Kocury
                SET przydzial_myszy = przydzial_myszy - przydzial_tygrysa_p
                WHERE pseudo = 'TYGRYS';
            ELSE
                UPDATE Kocury
                SET myszy_extra = myszy_extra + 5
                WHERE pseudo = 'TYGRYS';
            END IF;
        END IF;
    END AFTER STATEMENT;
END virus;

-- Test 1
SELECT * FROM Kocury;

UPDATE Kocury
SET przydzial_myszy = przydzial_myszy + 1
WHERE funkcja = 'MILUSIA';

SELECT * FROM Kocury;

ROLLBACK;


-- Test 2
SELECT * FROM Kocury;

UPDATE Kocury
SET przydzial_myszy = przydzial_myszy + 100
WHERE funkcja = 'MILUSIA';

SELECT * FROM Kocury;

ROLLBACK;

-- Zadanie 43
DECLARE
    CURSOR funkcje_c IS SELECT funkcja FROM Funkcje;
    CURSOR bandy_c IS SELECT nr_bandy, nazwa FROM Bandy;

    column_1_width NUMBER := 20;
    column_2_width NUMBER := 10;
    column_3_width NUMBER := 7;
    other_column_width NUMBER := 10;
    last_column_width NUMBER := 10;

    suma_funkcja NUMBER;
    suma_calk NUMBER;
    dynamic_query VARCHAR(1000) := '';
    last_row_res VARCHAR(200) := '';

    PROCEDURE podsumowanie_dla_bandy(
        banda bandy_c%ROWTYPE,
        plec_p Kocury.plec%TYPE
    )
    AS
        suma_bandy NUMBER;
        suma_calk_band NUMBER;
        ilosc_kotow NUMBER;
    BEGIN
        SELECT COUNT(*) INTO ilosc_kotow
        FROM Kocury
        WHERE nr_bandy = banda.nr_bandy AND plec = plec_p;

        DBMS_OUTPUT.PUT(RPAD(ilosc_kotow, column_3_width));

        FOR f IN funkcje_c
        LOOP
            SELECT NVL(SUM(przydzial_myszy + NVL(myszy_extra, 0)), 0) INTO suma_bandy
            FROM Kocury
            WHERE nr_bandy = banda.nr_bandy AND plec = plec_p AND funkcja = f.funkcja;

            DBMS_OUTPUT.PUT(RPAD(suma_bandy, other_column_width));
        END LOOP;

        SELECT NVL(SUM(przydzial_myszy + NVL(myszy_extra, 0)), 0) INTO suma_calk_band
        FROM Kocury
        WHERE nr_bandy = banda.nr_bandy AND plec = plec_p;

        DBMS_OUTPUT.PUT(RPAD(suma_calk_band, last_column_width));

        DBMS_OUTPUT.NEW_LINE();
    END;
BEGIN
    -- Header
    DBMS_OUTPUT.PUT(
        RPAD('NAZWA BANDY', column_1_width) ||
        RPAD('PLEC', column_2_width) ||
        RPAD('ILE', column_3_width)
    );
    
    FOR f IN funkcje_c
    LOOP
        DBMS_OUTPUT.PUT(RPAD(f.funkcja, other_column_width));
    END LOOP;
    
    DBMS_OUTPUT.PUT(RPAD('SUMA', last_column_width));
    DBMS_OUTPUT.NEW_LINE();
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 125, '-'));

    FOR banda IN bandy_c
    LOOP
        DBMS_OUTPUT.PUT(RPAD(banda.nazwa, column_1_width));
        DBMS_OUTPUT.PUT(RPAD('Kotka', column_2_width));

        podsumowanie_dla_bandy(banda, 'D');
        
        DBMS_OUTPUT.PUT(RPAD(' ', column_1_width));
        DBMS_OUTPUT.PUT(RPAD('Kocor', column_2_width));
        
        podsumowanie_dla_bandy(banda, 'M');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 125, '-'));
    
    DBMS_OUTPUT.PUT(RPAD('ZJADA RAZEM', column_1_width));
    DBMS_OUTPUT.PUT(RPAD(' ', column_2_width));
    DBMS_OUTPUT.PUT(RPAD(' ', column_3_width));

    
    dynamic_query := 'SELECT ';

    FOR f IN funkcje_c
    LOOP
        dynamic_query := dynamic_query || 'RPAD(TO_CHAR(SUM(DECODE(funkcja,''' || f.funkcja || ''', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0))), ' || other_column_width || ') ||';
    END LOOP;
    

    SELECT NVL(SUM(przydzial_myszy + NVL(myszy_extra, 0)), 0) INTO suma_calk
    FROM Kocury;


    dynamic_query := dynamic_query || 'RPAD(TO_CHAR(SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))), ' || last_column_width || ')';
    dynamic_query := dynamic_query || ' FROM Kocury NATURAL JOIN Bandy';
    EXECUTE IMMEDIATE dynamic_query INTO last_row_res;

    DBMS_OUTPUT.PUT(last_row_res);
    DBMS_OUTPUT.NEW_LINE();
END;

-- Zadanie 44
CREATE OR REPLACE FUNCTION podatek(pseudonim VARCHAR2)
RETURN NUMBER
AS
  podwladni NUMBER;
  wrogowie NUMBER;
  kocur Kocury%ROWTYPE;

  podatek NUMBER := 0;
BEGIN
  SELECT ROUND(CEIL(0.05 * (przydzial_myszy + NVL(myszy_extra, 0)))) INTO podatek
  FROM Kocury
  WHERE pseudo = pseudonim;
 
  SELECT COUNT(*) INTO podwladni
  FROM Kocury
  WHERE szef = pseudonim;
  
  SELECT COUNT(*) INTO wrogowie
  FROM Wrogowie_kocurow
  WHERE pseudo = pseudonim;
  
  IF kocur.plec = 'M' THEN
    podatek := podatek + 1;
  END IF;

  IF podwladni = 0 THEN
    podatek := podatek + 2;
  END IF;

  IF wrogowie = 0 THEN
    podatek := podatek + 1;
  END IF;

  RETURN podatek;
END;

SELECT pseudo,
      (przydzial_myszy + NVL(myszy_extra, 0)) "Calk. przydzial",
      podatek(pseudo) "Podatek"
FROM Kocury;

-- Zadanie 45
CREATE TABLE Dodatki_extra(pseudo VARCHAR2(15), dodatek NUMBER);

CREATE OR REPLACE TRIGGER zemsta_tygrysa
FOR UPDATE ON Kocury
COMPOUND TRIGGER
  should_update BOOLEAN := FALSE;
  exist NUMBER;
  CURSOR milusie_c IS
    SELECT * FROM Kocury WHERE funkcja = 'MILUSIA';
  
  milusia milusie_c%ROWTYPE;

  BEFORE EACH ROW IS
  BEGIN
    IF :NEW.funkcja = 'MILUSIA' AND
        (
            :NEW.przydzial_myszy > :OLD.przydzial_myszy OR
            NVL(:NEW.myszy_extra, 0) > NVL(:OLD.myszy_extra, 0)
        )
        AND NOT SYS.LOGIN_USER = 'TYGRYS'
    THEN
      should_update := TRUE;
    END IF;
  END BEFORE EACH ROW;

  AFTER STATEMENT IS
  BEGIN
    IF should_update THEN
        FOR milusia IN milusie_c
        LOOP
            SELECT COUNT(*) INTO exist
            FROM Dodatki_extra
            WHERE pseudo = milusia.pseudo;
            
            IF exist > 0 THEN
                EXECUTE IMMEDIATE 'UPDATE Dodatki_extra SET dodatek = dodatek - 10 WHERE pseudo = ''' || TO_CHAR(milusia.pseudo) || '''';
            ELSE
                EXECUTE IMMEDIATE 'INSERT INTO Dodatki_extra VALUES (''' || TO_CHAR(milusia.pseudo) ||''', -10)';
            END IF;
        END LOOP;

        should_update := FALSE;
    END IF;
  END AFTER STATEMENT;
END;

UPDATE Kocury
SET przydzial_myszy = przydzial_myszy + 1
WHERE funkcja = 'MILUSIA';

SELECT * FROM Dodatki_extra;
ROLLBACK;

-- Zadanie 46
CREATE TABLE Log(kto VARCHAR2(20), kiedy DATE, kotu VARCHAR2(10), operacja VARCHAR2(2000));

CREATE OR REPLACE TRIGGER log_activity
BEFORE INSERT OR UPDATE ON Kocury
FOR EACH ROW
  DECLARE
    funkcja Funkcje%ROWTYPE;
    operation VARCHAR2(10);
  BEGIN
    SELECT * INTO funkcja
    FROM Funkcje
    WHERE funkcja = :NEW.funkcja;
 
    operation := 'INSERTING';

    IF UPDATING THEN
      operation := 'UPDATING';
    END IF;

    IF :NEW.przydzial_myszy < funkcja.min_myszy OR
       :NEW.przydzial_myszy > funkcja.max_myszy
    THEN
      INSERT INTO Log VALUES (SYS.LOGIN_USER, CURRENT_DATE, :NEW.pseudo, operation);
      
      :NEW.przydzial_myszy := :OLD.przydzial_myszy;
    END IF;
  END;

UPDATE kocury
SET przydzial_myszy = 20
WHERE pseudo = 'PUSZYSTA';

SELECT * FROM Log;

SELECT * FROM kocury
NATURAL JOIN Funkcje
WHERE pseudo = 'PUSZYSTA';

ROLLBACK;
DROP TABLE Log;
