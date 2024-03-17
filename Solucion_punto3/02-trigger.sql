CREATE OR REPLACE TRIGGER control_actualizacion_casa_matriz
BEFORE UPDATE OF capitalp ON casamatriz
FOR EACH ROW
DECLARE
capital_hijas casahija.capitalh%TYPE;
BEGIN
SELECT SUM(capitalh) INTO capital_hijas FROM casahija
WHERE casapadre = :OLD.id GROUP BY casapadre;

IF :NEW.capitalp < capital_hijas THEN
    RAISE_APPLICATION_ERROR(-20506, 'No se pudo actualizar la casa matriz con el capital: ' || :NEW.capitalp);
ELSE
    DBMS_OUTPUT.PUT_LINE('La casa matriz se ha actualizado con exito!');
END IF;
END;
/

-- Caso de prueba 1 (debe permitir la actualizacion)
UPDATE casamatriz SET capitalp = 990 WHERE id = 1;

-- Caso de prueba 2 (debe generar un error)
UPDATE casamatriz SET capitalp = 949 WHERE id = 1;