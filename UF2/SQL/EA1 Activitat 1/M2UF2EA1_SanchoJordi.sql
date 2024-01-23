/* 
Crear la base de dades amb el usuari empleats

CREATE DATABASE empleats;
CREATE USER empleats WITH SUPERUSER CREATEROLE ENCRYPTED PASSWORD 'empleats';
ALTER DATABASE empleats OWNER TO empleats;
GRANT ALL PRIVILEGES ON DATABASE empleats TO empleats;
*/

/* Creacio taules*/

CREATE TABLE Region (
    CodRegion NUMERIC(5) NOT NULL,
    Nombre VARCHAR(12),
        CONSTRAINT COD_REG PRIMARY KEY (CodRegion)
);

CREATE TABLE Provincia (
    CodProvincia NUMERIC(5) NOT NULL,
    Nombre VARCHAR(12),
    CodRegion NUMERIC(5) NOT NUll,
        
        CONSTRAINT COD_PROV PRIMARY KEY (CodProvincia),
        CONSTRAINT COD_REG FOREIGN KEY (CodRegion) REFERENCES Region(CodRegion)
);
CREATE TABLE Localidad (
    CodLocalidad NUMERIC(5) NOT NULL,
    Nombre VARCHAR(12),
    CodProvincia NUMERIC(5) NOT NUll,
        
        CONSTRAINT COD_LOC PRIMARY KEY (CodLocalidad),
        CONSTRAINT COD_PROVINCIA FOREIGN KEY (CodProvincia) REFERENCES Provincia(CodProvincia)
);
CREATE TABLE Empleado (
    ID NUMERIC(5) NOT NULL,
    DNI NUMERIC(8) UNIQUE,
    Nombre VARCHAR(12),
    FechaNac DATE,
    Telefon NUMERIC(9),
    Salario NUMERIC(7),
    CodLocalidad NUMERIC(5) NOT NULL,

        CONSTRAINT ID_EMPLE PRIMARY KEY (ID),
        CONSTRAINT COD_LOCALIDAD FOREIGN KEY (CodLocalidad) REFERENCES Localidad(CodLocalidad)
)

/* Per insertar les taules a la base de dades utilitzem la seguent comanda
psql -U empleats -W -d empleats -h localhost < "F:\GSDAMv\M02-M06 Base de dades i accés a dades\UF2\SQL\EA1\M2UF2EA1_SanchoJordi.sql"
*/