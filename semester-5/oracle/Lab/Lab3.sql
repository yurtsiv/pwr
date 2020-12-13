SET SERVEROUTPUT ON

-- Zad 34

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

-- Zad 35

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