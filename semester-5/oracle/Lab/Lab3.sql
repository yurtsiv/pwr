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
    CURSOR do_podwyzki IS
        SELECT pseudo, przydzial_myszy, max_myszy
        FROM Kocury NATURAL JOIN Funkcje
        ORDER BY przydzial_myszy
        FOR UPDATE OF przydzial_myszy;

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
END;

SELECT imie, przydzial_myszy "Myszki po podwyzce"
FROM Kocury
ORDER BY przydzial_myszy;

ROLLBACK;

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
    max_depth POSITIVE := 3; -- '&Maks';
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
    nr_b Bandy.nr_bandy%TYPE := 10; -- '&Nr'
    nazwa_b Bandy.nazwa%TYPE := 'hello'; -- '&Nazwa'
    teren_b Bandy.teren%TYPE := 'hello'; -- '&Teren'
    ilosc_b NUMBER := 0;
    blad VARCHAR(30) := '';

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

ROLLBACK;

-- Zadanie 40
