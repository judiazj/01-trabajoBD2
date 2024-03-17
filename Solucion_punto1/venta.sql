--Creacion tabla venta

DROP TABLE venta;
CREATE TABLE venta(
id NUMBER(8) PRIMARY KEY,
jventa JSON NOT NULL
);

INSERT INTO venta VALUES(1,
'{
    "codventa": 66,
    "fecha": "29-11-2023",
    "codcliente": 445,
    "items": [
        {
            "codproducto": 100,
            "nrounidades": 3,
            "totalpesos": 75
        },
        {
            "codproducto": 111,
            "nrounidades": 1,
            "totalpesos": 1000
        },
        {
            "codproducto": 100,
            "nrounidades": 1,
            "totalpesos": 26
        }
    ]
}');
