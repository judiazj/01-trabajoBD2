CREATE OR REPLACE TRIGGER control_actualizacion_casa_hija
BEFORE UPDATE OF capitalh ON casahija
FOR EACH ROW
DECLARE
pragma autonomous_transaction;
capital_hijas casahija.capitalh%TYPE;
capital_matriz casamatriz.capitalp%TYPE;
BEGIN 
SELECT capitalp INTO capital_matriz FROM casamatriz
WHERE id = :OLD.casapadre;

SELECT SUM(capitalh) INTO capital_hijas FROM casahija
WHERE (casapadre = :OLD.casapadre AND id != :OLD.id) GROUP BY casapadre;

IF (capital_hijas + :NEW.capitalh) > capital_matriz THEN
    RAISE_APPLICATION_ERROR(-20507, 'No se pudo actualizar la casa hija con el capital: ' || :NEW.capitalh);
ELSE
    DBMS_OUTPUT.PUT_LINE('El capital de la casa hija se ha actualizado con exito!');
END IF;
END;
/

-- Caso de prueba 1 (debe generar un error)
UPDATE casahija SET capitalh = 400 WHERE id = 1;

-- Caso de prueba 2 (debe permitir la actualizacion)
UPDATE casahija SET capitalh = 349 WHERE id = 1;
