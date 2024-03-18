CREATE OR REPLACE PROCEDURE informe_ventas_por_tipo(
    p_tipo_producto IN VARCHAR2
)
IS
    total_no_registrados NUMBER := 0; -- Inicializamos la variable total_no_registrados
BEGIN
    -- Verificamos si el tipo de producto existe
    BEGIN
        SELECT id INTO v_tipo_producto_id
        FROM producto
        WHERE Tipoprod = UPPER(p_tipo_producto); -- Convertimos el tipo de producto a mayúsculas

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No existe');
            RETURN; -- Salir del procedimiento si el tipo de producto no existe
    END;

    DBMS_OUTPUT.PUT_LINE('Informe para ' || p_tipo_producto || ' por año y marca:');

    -- Calcular el total de los productos no registrados en la tabla de productos
    SELECT NVL(SUM(JSON_VALUE(p.column_value, '$.totalpesos')), 0) INTO total_no_registrados
    FROM venta v
    LEFT JOIN producto pr ON JSON_VALUE(p.column_value, '$.codproducto') = pr.id,
         JSON_TABLE(v.jventa, '$.items[*]' COLUMNS (
            totalpesos PATH '$.totalpesos', 
            codproducto PATH '$.codproducto' 
         )) p
    WHERE pr.id IS NULL
    AND pr.Tipoprod = UPPER(p_tipo_producto);

    -- Imprimir el total de los productos no registrados en la tabla producto
    DBMS_OUTPUT.PUT_LINE('Total de los productos no registrados en la tabla producto: ' || total_no_registrados);
    
    -- Imprimir los resultados de las ventas por tipo
    FOR c IN (
        SELECT EXTRACT(YEAR FROM TO_DATE(JSON_VALUE(v.jventa, '$.fecha'), 'dd-mm-yyyy')) AS anio,
               totalpesos AS total_pesos, 
               codproducto AS codproducto, 
               EXTRACTVALUE(p.column_value, '/Producto/Marca') AS marca
        FROM venta v
        JOIN producto pr ON JSON_VALUE(p.column_value, '$.codproducto') = pr.id,
             JSON_TABLE(v.jventa, '$.items[*]' COLUMNS (
                PATH '$'
             )) p
        WHERE pr.Tipoprod = UPPER(p_tipo_producto)
        ORDER BY anio, marca
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(c.anio || ' ' || c.marca || ' ' || c.total_pesos);
    END LOOP;
END;
/


EXECUTE informe_ventas_por_tipo('mueble de oficina');

DROP PROCEDURE informe_ventas_por_tipo;