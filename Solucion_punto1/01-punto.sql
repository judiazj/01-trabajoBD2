CREATE OR REPLACE PROCEDURE informe_estrato_genero(
    mes IN NUMBER,
    anio IN NUMBER
)
IS 
    fecha_inicio DATE := TO_DATE(anio || '-' || mes || '-01', 'YYYY-MM-DD');
    fecha_fin DATE := ADD_MONTHS(fecha_inicio, 1) - 1;
    estrato VARCHAR2(100);
    genero VARCHAR2(100);
    total_pesos NUMBER;
    total_pesos_por_estrato_genero SYS_REFCURSOR;
BEGIN 
    -- Verificar si el mes ingresado es válido
    IF (mes < 1 OR mes > 12) THEN
        RAISE_APPLICATION_ERROR(-20503, 'El mes ingresado no es válido: ' || mes);
    END IF;

    -- Imprimir el encabezado del informe
    DBMS_OUTPUT.PUT_LINE('Informe para ' || mes || '-' || anio ||':');
    DBMS_OUTPUT.PUT_LINE('totalpesos estrato genero');

    -- Calcular el total de pesos vendido a cada estrato y género
    OPEN total_pesos_por_estrato_genero FOR
    SELECT NVL(EXTRACTVALUE(c.c, '/Cliente/Estrato'), 'Ausente') AS estrato,
           NVL(EXTRACTVALUE(c.c, '/Cliente/Genero'), 'Ausente') AS genero,
           SUM(ROUND(XMLCAST(JSON_VALUE(v.jventa, '$.items[*].totalpesos') AS NUMBER))) AS total_pesos
    FROM venta v
    LEFT JOIN cliente c ON JSON_VALUE(v.jventa, '$.codcliente')  = EXTRACTVALUE(c.c, '/Cliente/@clNro').getStringVal()
    WHERE TO_DATE(JSON_VALUE(v.jventa, '$.fecha'), 'DD-MM-YYYY') BETWEEN fecha_inicio AND fecha_fin
    GROUP BY ROLLUP(EXTRACTVALUE(c.c, '/Cliente/Estrato'), EXTRACTVALUE(c.c, '/Cliente/Genero'));

    -- Imprimir los resultados
    LOOP
        FETCH total_pesos_por_estrato_genero INTO estrato, genero, total_pesos;
        EXIT WHEN total_pesos_por_estrato_genero%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(RPAD(total_pesos, 10) || ' ' || RPAD(estrato, 8) || ' ' || genero);
    END LOOP;

    -- Cerrar el cursor
    CLOSE total_pesos_por_estrato_genero;
END;
/

EXECUTE informe_estrato_genero(11, 2023);

DROP PROCEDURE informe_estrato_genero;
