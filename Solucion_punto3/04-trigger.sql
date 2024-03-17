-- Control del maximo de casas hijas para una casa matriz

CREATE OR REPLACE TRIGGER control_numero_hijas
BEFORE INSERT ON casahija
FOR EACH ROW
DECLARE
numero_hijas casahija.capitalh%TYPE;
BEGIN 
SELECT COUNT(*) INTO numero_hijas FROM casahija
WHERE casapadre = :NEW.casapadre GROUP BY casapadre;

IF numero_hijas >= 5 THEN 
    RAISE_APPLICATION_ERROR(-20508, 'No se pudo ingresar la casa hija por superar el limite permitido!');
ELSE
    DBMS_OUTPUT.PUT_LINE('La casa hija ha sido ingresada con exito!');
END IF;
END;
/

SELECT COUNT(*) FROM casahija
WHERE casapadre = 1 GROUP BY casapadre;

-- Caso de prueba 1 (debe permitir el ingreso)
INSERT INTO casahija VALUES(6, 10, 1);

-- Caso de prueba 2 (debe permitir el ingreso)
INSERT INTO casahija VALUES(7, 10, 1);

-- Caso de prueba 3 (debe generar un error)
INSERT INTO casahija VALUES(8, 10, 1);


-- Control para no permitir que una casa hija cambie de casa matriz

CREATE OR REPLACE TRIGGER control_cambio_casa_matriz
BEFORE UPDATE OF casapadre ON casahija
FOR EACH ROW
WHEN (NEW.casapadre != OLD.casapadre)
BEGIN
    RAISE_APPLICATION_ERROR(-20509, 'No se puede actualizar la casa matriz de una casa hija!');
END;
/

-- Caso de prueba 1 (debe generar un error)
UPDATE casahija SET casapadre = 1 WHERE id = 1;