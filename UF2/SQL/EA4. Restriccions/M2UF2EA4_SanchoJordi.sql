/* 
Crear la base de dades amb el usuari restriccions

CREATE DATABASE restriccions;
CREATE USER restriccions WITH SUPERUSER CREATEROLE ENCRYPTED PASSWORD 'restriccions';
ALTER DATABASE restriccions OWNER TO restriccions;
GRANT ALL PRIVILEGES ON DATABASE restriccions TO restriccions;
*/

/* Creacio taules*/

CREATE TABLE Fabricant (
    COD_FABRICANT NUMERIC(3),
    NOM VARCHAR(15),
    PAIS VARCHAR(15),


        CONSTRAINT PK_FABRICANT PRIMARY KEY (COD_FABRICANT),
        CONSTRAINT CHK_UpperNom CHECK (NOM = UPPER(NOM)),
        CONSTRAINT CHK_UpperPais CHECK (PAIS = UPPER(PAIS))
        

);
CREATE TABLE Article (
    COD_ARTICLE VARCHAR(20),
    COD_FABRICANT NUMERIC(3),
    PES NUMERIC(3),
    CATEGORIA VARCHAR(10),
    PREU_VENDA DECIMAL(6,2),
    PREU_COST DECIMAL(6,2),
    STOCK NUMERIC(5),


        CONSTRAINT PK_ARTICLE PRIMARY KEY (COD_ARTICLE,COD_FABRICANT,PES,CATEGORIA),
        CONSTRAINT FK_CodFabricant FOREIGN KEY (COD_FABRICANT) REFERENCES Fabricant(COD_FABRICANT),
        CONSTRAINT CHK_PesGran0 CHECK (PES > 0),
        CONSTRAINT CHK_PreuVendaGran0 CHECK (PREU_VENDA > 0),
        CONSTRAINT CHK_PreuCostGran0 CHECK (PREU_COST > 0),
        CONSTRAINT CHK_Categoria CHECK (CATEGORIA IN ('Primera', 'Segona', 'Tercera'))
);


/* Per insertar les taules a la base de dades utilitzem la seguent comanda
psql -U restriccions -W -d restriccions -h localhost < "F:\GSDAMv\M02-M06 Base de dades i accés a dades\UF2\SQL\EA4. Restriccions\M2UF2EA4_SanchoJordi.sql"
*/