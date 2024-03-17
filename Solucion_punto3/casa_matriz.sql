
DROP TABLE casamatriz;
CREATE TABLE casamatriz(
id NUMBER(8) PRIMARY KEY,
capitalp NUMBER(8) NOT NULL CHECK(capitalp > 0)
);

INSERT INTO casamatriz VALUES(1, 1000);
INSERT INTO casamatriz VALUES(2, 2000);
INSERT INTO casamatriz VALUES(3, 1000);