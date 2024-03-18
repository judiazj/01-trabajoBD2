    CREATE OR REPLACE PROCEDURE informe_estrato_genero(mes IN NUMBER, anio IN NUMBER)
    IS 
    fecha DATE;
    CURSOR f_ventas IS SELECT v.jventa.fecha FROM venta v;
    BEGIN 
        IF (mes < 0 OR mes > 12) THEN
            RAISE_APPLICATION_ERROR(-20503, 'El mes ingresado no es valido: ' || mes);
        END IF;
        DBMS_OUTPUT.PUT_LINE('Informe para ' || mes || '-' || anio ||':');
        fecha := TO_DATE(anio || '-' || mes || '01', 'YYYY-MM-DD');
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(fecha, 'YYYY-MM-DD'));
        -- FOR f IN f_ventas LOOP
        --     DBMS_OUTPUT.PUT_LINE(TO_CHAR(f, 'YYYY-MM-DD'));
        -- END LOOP;
    END;
    /

EXECUTE informe_estrato_genero(11, 2023);

SELECT v.jventa.fecha FROM venta v;