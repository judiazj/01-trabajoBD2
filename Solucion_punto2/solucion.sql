DROP PROCEDURE informe_ventas_por_tipo;

CREATE OR REPLACE PROCEDURE informe_ventas_por_tipo(
    p_tipo_producto IN VARCHAR2
)
IS
BEGIN
    -- Verificar si el tipo de producto existe
    DECLARE
        v_tipo_producto_id NUMBER;
    BEGIN
        SELECT id INTO v_tipo_producto_id
        FROM producto
        WHERE Tipoprod = p_tipo_producto;

        -- Si el tipo de producto existe, imprimir el informe
        DBMS_OUTPUT.PUT_LINE('Informe para ' || p_tipo_producto || ' por año y marca:');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------');

        FOR c IN (
            SELECT EXTRACT(YEAR FROM TO_DATE(JSON_VALUE(v.jventa, '$.fecha'), 'dd-mm-yyyy')) AS anio,
                   XMLCAST(JSON_VALUE(v.jventa, '$.items[' || (i+1) || '].totalpesos') AS NUMBER) AS total_pesos,
                   XMLCAST(XMLQuery('/Producto/Marca/text()' PASSING p AS "p" RETURNING CONTENT) AS VARCHAR2(100)) AS marca
            FROM venta v,
                 XMLTable('$' PASSING v.jventa CROSS JOIN JSON_TABLE(v.jventa, '$.items[*]' COLUMNS PATH '$') p) p,
                 producto pr
            WHERE JSON_VALUE(v.jventa, '$.items[' || (i+1) || '].codproducto') = pr.id
            AND pr.Tipoprod = p_tipo_producto
            ORDER BY anio, marca
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(c.anio || ' ' || c.marca || ' ' || c.total_pesos);
        END LOOP;

        -- Imprimir el total de los productos no registrados en la tabla de productos
        SELECT NVL(SUM(XMLCAST(JSON_VALUE(v.jventa, '$.items[' || (i+1) || '].totalpesos') AS NUMBER)), 0) AS total_no_registrados
        INTO total_no_registrados
        FROM venta v
        LEFT JOIN producto pr ON JSON_VALUE(v.jventa, '$.items[' || (i+1) || '].codproducto') = pr.id
        WHERE pr.id IS NULL;

        DBMS_OUTPUT.PUT_LINE('Total de los productos no registrados en la tabla producto: ' || total_no_registrados);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No existe');
    END;
END;
/


EXECUTE informe_ventas_por_tipo('mueble de oficina');