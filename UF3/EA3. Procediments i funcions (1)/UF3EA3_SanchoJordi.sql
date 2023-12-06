/*Exercici 1. Realitzar un programa que contingui una funció que dupliqui la quantitat rebuda com a
paràmetre. La funció rebrà el nom de FUNC_DUPLICAR_QUANTITAT. S’ha de programar un bloc
principal que demani per teclat la quantitat i que cridi a la funció FUNC_DUPLICAR_QUANTITAT
passant el paràmetre corresponent.*/

CREATE FUNCTION FUNC_DUPLICAR_QUANTITAT (usernumber decimal(10,2))
RETURNS decimal
AS $$
    DECLARE
        resultat DECIMAL(10, 2);
    BEGIN
        resultat = usernumber*2;
        RETURN resultat;
    END;
$$ LANGUAGE plpgsql;

select FUNC_DUPLICAR_QUANTITAT(2);


/*Exercici 2. Realitzar un programa que contingui una funció que calculi el factorial d’un número que
es passa com a paràmetre. La funció rebrà el nom de FUNC_FACTORIAL. S’ha de programar un
bloc principal que pregunti a l’usuari pel número a calcular i cridi a la funció FUNC_FACTORIAL,
passant el paràmetre corresponent.*/




/*Exercici 3. Realitzar un procediment que s’anomeni PROC_EMP_INFO i que es passi com a paràmetre
l’Id d’un empleat i mostri el seu ID, el seu nom, el seu càrrec (job_title) i el seu salari. Has de canviar els
nom de les columnes perquè sigui (codi_empleat, nom_empleat, càrrec, salari). Per realitzar aquest
exercici has de fer servir una variable de tipus %rowtype. S’ha de programar un bloc principal que
pregunti a l’usuari pel ID de l’empleat i cridi al procediment PROC_EMP_INFO, passant el paràmetre
corresponent.*/



/*Exercici 4. Realitzar un programa que contingui un procediment anomenat PROC_ALTA_JOB que doni
d’alta un nou ofici (JOB) a la taula jobs. Totes les dades del nou ofici s’han de passat com com a
paràmetre. S’ha de programar un bloc principal que pregunti a l’usuari totes les dades del nou ofici i cridi
el procediment PROC_ALTA_JOB. Abans d’inserir s’ha de comprovar que el valor màxim i mínim del
salari no sigui negatiu i a més, que el salari mínim sigui més petit que el salari màxim. Mostra els
missatges d’error corresponents.*/


