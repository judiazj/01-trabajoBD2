--Creacion tabla cliente

DROP TABLE cliente;
CREATE TABLE cliente(
id NUMBER(8) PRIMARY KEY,
c XMLTYPE NOT NULL);

INSERT INTO cliente VALUES
(1, XMLTYPE('<Cliente clNro="445">
            <Estrato>5</Estrato>
            <Genero>m</Genero>
            </Cliente>'));


INSERT INTO cliente VALUES
(2, XMLTYPE('<Cliente clNro="800">
            <Estrato>88</Estrato>
            <Genero>x</Genero>
            </Cliente>'));
