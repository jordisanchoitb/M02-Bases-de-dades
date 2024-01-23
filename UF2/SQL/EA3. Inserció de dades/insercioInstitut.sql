
INSERT INTO Aula (Numero, m2) VALUES (101, 75.5);
INSERT INTO Aula (Numero, m2) VALUES (102, 68.2);
INSERT INTO Aula (Numero, m2) VALUES (103, 80.0);
INSERT INTO Aula (Numero, m2) VALUES (104, 65.9);
INSERT INTO Aula (Numero, m2) VALUES (105, 70.7);
    

INSERT INTO Assignatura (Codi, Nom) VALUES (101, 'Matemáticas');
INSERT INTO Assignatura (Codi, Nom) VALUES (102, 'Historia');
INSERT INTO Assignatura (Codi, Nom) VALUES (103, 'Física');
INSERT INTO Assignatura (Codi, Nom) VALUES (104, 'Inglés');
INSERT INTO Assignatura (Codi, Nom) VALUES (105, 'Biología');
    
    
INSERT INTO Modul (Codi, Nom, NumeroAula) VALUES (201, 'Álgebra', 101);
INSERT INTO Modul (Codi, Nom, NumeroAula) VALUES (202, 'Edad Antigua', 102);
INSERT INTO Modul (Codi, Nom, NumeroAula) VALUES (203, 'Termodinámica', 103);
INSERT INTO Modul (Codi, Nom, NumeroAula) VALUES (204, 'Gramática', 104);
INSERT INTO Modul (Codi, Nom, NumeroAula) VALUES (205, 'Genética', 105);


INSERT INTO Persona (DNI, Nom, PrimerCognom, SegonCognom, Adreça, Telefon) VALUES (12345678, 'Juan', 'López', 'García', 'Calle Principal 123', 555123456);
INSERT INTO Persona (DNI, Nom, PrimerCognom, SegonCognom, Adreça, Telefon) VALUES (23456789, 'María', 'Martínez', 'Sánchez', 'Avenida Central 456', 555987654);
INSERT INTO Persona (DNI, Nom, PrimerCognom, SegonCognom, Adreça, Telefon) VALUES (34567890, 'Pedro', 'Fernández', 'Pérez', 'Calle Secundaria 789', 555567890);
INSERT INTO Persona (DNI, Nom, PrimerCognom, SegonCognom, Adreça, Telefon) VALUES (45678901, 'Ana', 'Gómez', 'López', 'Calle Pequeña 234', 555678901);
INSERT INTO Persona (DNI, Nom, PrimerCognom, SegonCognom, Adreça, Telefon) VALUES (56789012, 'Carlos', 'Santos', 'Mendoza', 'Avenida Secundaria 678', 555789012);
INSERT INTO Persona (DNI, Nom, PrimerCognom, SegonCognom, Adreça, Telefon) VALUES (67890123, 'Laura', 'Díaz', 'Vega', 'Calle Principal 345', 555890123);
INSERT INTO Persona (DNI, Nom, PrimerCognom, SegonCognom, Adreça, Telefon) VALUES (78901234, 'José', 'Rodríguez', 'Ortega', 'Avenida Grande 567', 555901234);
INSERT INTO Persona (DNI, Nom, PrimerCognom, SegonCognom, Adreça, Telefon) VALUES (89012345, 'Sara', 'García', 'Jiménez', 'Calle Central 678', 555012345);
INSERT INTO Persona (DNI, Nom, PrimerCognom, SegonCognom, Adreça, Telefon) VALUES (90123456, 'David', 'Torres', 'Ramírez', 'Calle Principal 789', 555123456);
INSERT INTO Persona (DNI, Nom, PrimerCognom, SegonCognom, Adreça, Telefon) VALUES (91234567, 'Elena', 'López', 'Ferrer', 'Avenida Central 890', 555123456);


INSERT INTO Professor (DNI, Especialitat) VALUES (12345678, 'Matemáticas');
INSERT INTO Professor (DNI, Especialitat) VALUES (23456789, 'Historia');
INSERT INTO Professor (DNI, Especialitat) VALUES (34567890, 'Física');
INSERT INTO Professor (DNI, Especialitat) VALUES (45678901, 'Inglés');
INSERT INTO Professor (DNI, Especialitat) VALUES (56789012, 'Biología');
    

INSERT INTO Alumne (DNI, DataNeixament, DNI_Delegat) VALUES (12345678, '2000-05-15', NULL);
INSERT INTO Alumne (DNI, DataNeixament, DNI_Delegat) VALUES (23456789, '2001-08-20', 23456789);
INSERT INTO Alumne (DNI, DataNeixament, DNI_Delegat) VALUES (34567890, '2002-03-10', NULL);
INSERT INTO Alumne (DNI, DataNeixament, DNI_Delegat) VALUES (45678901, '2003-11-05', 45678901);
INSERT INTO Alumne (DNI, DataNeixament, DNI_Delegat) VALUES (56789012, '2004-07-02', NULL);


INSERT INTO Pertany (CodModul, CodAssig) VALUES (201, 101);
INSERT INTO Pertany (CodModul, CodAssig) VALUES (202, 102);
INSERT INTO Pertany (CodModul, CodAssig) VALUES (203, 103);
INSERT INTO Pertany (CodModul, CodAssig) VALUES (204, 104);
INSERT INTO Pertany (CodModul, CodAssig) VALUES (205, 105);


INSERT INTO Ensenya (DNI_PROFE, CodAssig) VALUES (12345678, 101);
INSERT INTO Ensenya (DNI_PROFE, CodAssig) VALUES (23456789, 102);
INSERT INTO Ensenya (DNI_PROFE, CodAssig) VALUES (34567890, 103);
INSERT INTO Ensenya (DNI_PROFE, CodAssig) VALUES (45678901, 104);
INSERT INTO Ensenya (DNI_PROFE, CodAssig) VALUES (56789012, 105);


INSERT INTO Matricula (DNI_ALUMNE, CodAssig) VALUES (12345678, 101);
INSERT INTO Matricula (DNI_ALUMNE, CodAssig) VALUES (23456789, 102);
INSERT INTO Matricula (DNI_ALUMNE, CodAssig) VALUES (34567890, 103);
INSERT INTO Matricula (DNI_ALUMNE, CodAssig) VALUES (45678901, 104);
INSERT INTO Matricula (DNI_ALUMNE, CodAssig) VALUES (56789012, 105);
