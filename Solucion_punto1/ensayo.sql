DROP PROCEDURE informe_ventas;

CREATE OR REPLACE PROCEDURE informe_ventas(
    p_mes IN NUMBER,
    p_anio IN NUMBER
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Informe para ' || LPAD(p_mes, 2, '0') || '-' || p_anio || ':');
    DBMS_OUTPUT.PUT_LINE('totalpesos estrato genero');
    DBMS_OUTPUT.PUT_LINE('------------------------------------');

    FOR c IN (
        SELECT NVL(c.Estrato, 'Ausente') AS estrato,
               NVL(c.Genero, 'Ausente') AS genero,
               SUM(ROUND(XMLCAST(JSON_VALUE(v.jventa, '$.items[' || (i+1) || '].totalpesos') AS NUMBER))) AS total
        FROM venta v
        LEFT JOIN cliente c ON JSON_VALUE(v.jventa, '$.codcliente') = TO_NUMBER(XMLCAST(c.c.extract('/Cliente/@clNro') AS VARCHAR2(10)))
        WHERE TO_CHAR(TO_DATE(JSON_VALUE(v.jventa, '$.fecha'), 'dd-mm-yyyy'), 'MM') = LPAD(p_mes, 2, '0')
        AND TO_CHAR(TO_DATE(JSON_VALUE(v.jventa, '$.fecha'), 'dd-mm-yyyy'), 'YYYY') = p_anio
        GROUP BY ROLLUP(c.Estrato, c.Genero)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(c.total, 10) || ' ' || RPAD(c.estrato, 8) || ' ' || c.genero);
    END LOOP;
END;
/

EXECUTE informe_ventas(11, 2023);
