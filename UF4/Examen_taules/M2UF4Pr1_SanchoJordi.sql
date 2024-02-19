/* Examen Creacio taulas amb objectes a posgresql */

/* Activitat 1*/
CREATE DATABASE transresJordi;

CREATE TYPE Adreça_type AS (
    carrer VARCHAR(50),
    numero INT4,
    cp INT4,
    ciutat VARCHAR(40)
);

CREATE TYPE Generedors_type AS (
    cif VARCHAR(15),
    nom VARCHAR(50),
    adreça Adreça_type,
    telefon VARCHAR(15),
    mail VARCHAR(45),
    activitat VARCHAR(250)
);

CREATE DOMAIN tipus_activitat_domain AS VARCHAR(50)
CHECK (VALUE IN ('Quimic', 'Organic', 'Plastic', 'Vidre', 'Paper', 'Radioactiu'));

CREATE TYPE Recicladors_type AS (
    cif VARCHAR(15),
    nom VARCHAR(50),
    adreça Adreça_type,
    telefon VARCHAR(15),
    mail VARCHAR(45),
    activitat tipus_activitat_domain
);

CREATE TYPE Residus_type AS (
    codi NUMERIC(15),
    nom VARCHAR(50),
    tipus tipus_activitat_domain
);

CREATE TYPE Vehicles_type AS (
    matricula VARCHAR(25),
    marca VARCHAR(30),
    model VARCHAR(30),
    capacitat NUMERIC(20,2),
    conductor VARCHAR(15)
);

CREATE TYPE Conductors_type AS (
    nif VARCHAR(15),
    nom VARCHAR(50),
    cognom1 VARCHAR(50),
    cognom2 VARCHAR(50),
    adreça Adreça_type,
    telefon VARCHAR(15),
    mail VARCHAR(45)
);

CREATE TYPE Transport_type AS (
    codi NUMERIC(20),
    generador VARCHAR(15),
    reciclador VARCHAR(15),
    residu NUMERIC(15),
    quantitat NUMERIC(20,2),
    preu NUMERIC(8,2),
    data DATE,
    vehicle VARCHAR(50)
);

CREATE TABLE generadors of Generedors_type (
    PRIMARY KEY (cif)
);
CREATE TABLE recicladors of Recicladors_type (
    PRIMARY KEY (cif)
);
CREATE TABLE residus of Residus_type (
    PRIMARY KEY (codi)
);
CREATE TABLE conductors of Conductors_type (
    PRIMARY KEY (nif)
);
CREATE TABLE vehicles of Vehicles_type (
    PRIMARY KEY (matricula),
        CONSTRAINT fk_vehicle_conductor FOREIGN KEY (conductor) REFERENCES conductors(nif)
);

CREATE TABLE transport of Transport_type (
    PRIMARY KEY (codi),
    generador NOT NULL,
    reciclador default null,
    residu NOT NULL,
    vehicle default null,
        CONSTRAINT fk_transport_generador FOREIGN KEY (generador) REFERENCES generadors(cif),
        CONSTRAINT fk_transport_reciclador FOREIGN KEY (reciclador) REFERENCES recicladors(cif),
        CONSTRAINT fk_transport_residu FOREIGN KEY (residu) REFERENCES residus(codi),
        CONSTRAINT fk_transport_vehicle FOREIGN KEY (vehicle) REFERENCES vehicles(matricula)
);

/* Activitat 2 Herencia */

CREATE DOMAIN nivell_domain AS VARCHAR(7)
CHECK (VALUE IN ('alta', 'mitja', 'baixa'));

CREATE TABLE residutox (
    toxicitat nivell_domain,
    tractament VARCHAR(40),
    PRIMARY KEY (codi)
) INHERITS (residus);

CREATE TABLE vehicleadp (
    seguretat nivell_domain,
    kms NUMERIC(40),
    PRIMARY KEY (matricula)
) INHERITS (vehicles);

CREATE TYPE Transport_Toxic_type AS (
    codi NUMERIC(20),
    generador VARCHAR(15),
    reciclador VARCHAR(15),
    residutox NUMERIC(15),
    quantitat NUMERIC(20,2),
    preu NUMERIC(8,2),
    data DATE,
    vehicleadp VARCHAR(50)
);

CREATE TABLE transportox of Transport_Toxic_type (
    PRIMARY KEY (codi),
        CONSTRAINT fk_transportox_generador FOREIGN KEY (generador) REFERENCES generadors(cif),
        CONSTRAINT fk_transportox_reciclador FOREIGN KEY (reciclador) REFERENCES recicladors(cif),
        CONSTRAINT fk_transportox_residutox FOREIGN KEY (residutox) REFERENCES residutox(codi),
        CONSTRAINT fk_transportox_vehicleadp FOREIGN KEY (vehicleadp) REFERENCES vehicleadp(matricula)
);