
-- Creacion del trigger

CREATE OR REPLACE TRIGGER control_insercion_casa_hija
BEFORE INSERT ON casahija
FOR EACH ROW
DECLARE
capital_hijas casahija.capitalh%TYPE;
capital_matriz casamatriz.capitalp%TYPE;
BEGIN
SELECT SUM(capitalh) INTO capital_hijas FROM casahija
WHERE casapadre = :NEW.casapadre GROUP BY casapadre;

SELECT capitalp INTO capital_matriz FROM casamatriz
WHERE id = :NEW.casapadre;
IF (capital_hijas + :NEW.capitalh) > capital_matriz THEN
    RAISE_APPLICATION_ERROR(-20505, 'No se pudo ingresar la casa hija con el capital: ' || :NEW.capitalh);
ELSE
    DBMS_OUTPUT.PUT_LINE('Casa hija ingresada con exito!');
END IF;
END;
/

-- Caso de prueba 1 (debe generar un error)
INSERT INTO casahija VALUES(9, 125, 2);

-- Caso de prueba 2 (debe permitir el ingreso)
INSERT INTO casahija VALUES(11, 80, 2);
