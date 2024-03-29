/* 
Crear la base de dades amb el usuari institut

CREATE DATABASE institut;
CREATE USER institut WITH SUPERUSER CREATEROLE ENCRYPTED PASSWORD 'institut';
ALTER DATABASE institut OWNER TO institut;
GRANT ALL PRIVILEGES ON DATABASE institut TO institut;
*/

/* Creacio taules*/

CREATE TABLE Aula (
    Numero NUMERIC(5) NOT NULL,
    m2 NUMERIC(5,2),

        CONSTRAINT NUM PRIMARY KEY (Numero)
);
CREATE TABLE Assignatura (
    Codi NUMERIC(5) NOT NULL,
    Nom VARCHAR(15),

        CONSTRAINT COD_ASSIG PRIMARY KEY (Codi)
);
CREATE TABLE Modul (
    Codi NUMERIC(5) NOT NULL,
    Nom VARCHAR(15),
    NumeroAula NUMERIC(5) NOT NULL,

        CONSTRAINT COD_MOD_NUMEROAULA PRIMARY KEY (Codi),
        CONSTRAINT NUM_AULA FOREIGN KEY (NumeroAula) REFERENCES Aula(Numero)
);
CREATE TABLE Persona (
    DNI NUMERIC(8) NOT NULL,
    Nom VARCHAR(15),
    PrimerCognom VARCHAR(15),
    SegonCognom VARCHAR(15),
    Adreça VARCHAR(25) NOT NULL,
    Telefon NUMERIC(9) NOT NULL,

        CONSTRAINT DNI PRIMARY KEY (DNI)
);
CREATE TABLE Professor (
    DNI NUMERIC(8) NOT NULL,
    Especialitat VARCHAR(20),

        CONSTRAINT DNI_PROFE PRIMARY KEY (DNI),
        CONSTRAINT DNI_PROFESOR FOREIGN KEY (DNI) REFERENCES Persona(DNI)
);
CREATE TABLE Alumne (
    DNI NUMERIC(8) NOT NULL,
    DataNeixament DATE,
    DNI_Delegat NUMERIC(8),

        CONSTRAINT DNI_ALU PRIMARY KEY (DNI),
        CONSTRAINT DNI_ALUMNE FOREIGN KEY (DNI) REFERENCES Persona(DNI),
        CONSTRAINT DNI_DELEG FOREIGN KEY (DNI) REFERENCES Alumne(DNI)
);
CREATE TABLE Pertany (
    CodModul NUMERIC(5) NOT NULL,
    CodAssig NUMERIC(5) NOT NULL,

        CONSTRAINT CODE_MODUL_ASSIG PRIMARY KEY (CodModul,CodAssig),
        CONSTRAINT COD_ASSIGNATURA FOREIGN KEY (CodAssig) REFERENCES Assignatura(Codi),
        CONSTRAINT COD_MOD FOREIGN KEY (CodModul) REFERENCES Modul(Codi)
);
CREATE TABLE Ensenya (
    DNI_PROFE NUMERIC(8) NOT NULL,
    CodAssig NUMERIC(5) NOT NULL,

        CONSTRAINT CODE_ASSIG_DNI_PROFE PRIMARY KEY (CodAssig, DNI_PROFE),
        CONSTRAINT DNIPROFE FOREIGN KEY (DNI_PROFE) REFERENCES Professor(DNI),
        CONSTRAINT COD_ASSIGNATURA FOREIGN KEY (CodAssig) REFERENCES Assignatura(Codi)
);
CREATE TABLE Matricula (
    DNI_ALUMNE NUMERIC(8) NOT NULL,
    CodAssig NUMERIC(5) NOT NULL,

        CONSTRAINT CODE_ASSIG_DNI_ALUM PRIMARY KEY (CodAssig, DNI_ALUMNE),
        CONSTRAINT DNIALUM FOREIGN KEY (DNI_ALUMNE) REFERENCES Alumne(DNI),
        CONSTRAINT COD_ASSIGNATURA FOREIGN KEY (CodAssig) REFERENCES Assignatura(Codi)
);


/* Per insertar les taules a la base de dades utilitzem la seguent comanda
psql -U institut -W -d institut -h localhost < "F:\GSDAMv\M02-M06 Base de dades i accés a dades\UF2\SQL\EA2 Activitat 2\M2UF2EA2_SanchoJordi.sql"*/