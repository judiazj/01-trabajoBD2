--Creacion tabla producto

DROP TABLE producto;
CREATE TABLE producto(
id NUMBER(8) PRIMARY KEY,
p XMLTYPE NOT NULL);

INSERT INTO producto VALUES
(1, XMLTYPE('<Producto plNro="100">
            <Marca>Micerdito Azul</Marca>
            <Tipoprod>Carnico</Tipoprod>
            </Producto>'));

INSERT INTO producto VALUES
(4, XMLTYPE('<Producto plNro="111">
            <Marca>Acme</Marca>
            <Tipoprod>Mueble de Oficina</Tipoprod>
            </Producto>'));