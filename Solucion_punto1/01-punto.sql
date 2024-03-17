
-- Solucion Punto 1

CREATE OR REPLACE PROCEDURE informe_mes_anio(mes IN NUMBER, anio IN NUMBER)
IS 
CURSOR extract_fecha IS ();
mes_invalido EXCEPTION;
BEGIN
WHEN mes < 0 OR mes > 12 THEN
    RAISE mes_invalido;
DBMS_OUTPUT.PUT_LINE('Informe para ' || mes ||'-' || anio);




SELECT v.jventa.fecha FROM venta v;