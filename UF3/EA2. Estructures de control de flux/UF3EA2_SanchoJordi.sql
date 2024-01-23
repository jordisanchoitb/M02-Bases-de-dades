
/*Exercici 1. Escriu un programa PL/SQL que introduirem per teclat dos números.
Els dos números han de ser positius, en cas contrari s’ha de mostrar a l’usuari
el missatge corresponent. S’ha de realitzar la següent operació amb aquests números:
dividir entre ells i sumar-li el segon i mostrar el resultat de l'operació.*/

do $$
    declare
        num1 integer = :"Donem un numero";
        num2 integer = :"Donem un segon numero";
        result integer;
    begin
        if num1 >= 0 and num2 >= 0 then
            result = (num1 / num2) + num2;
            raise notice 'El resultat es: %', result;
        else
            raise notice 'Un dels dos numeros que has introduit no es positiu';
        end if;
    end;
$$;



/*Exercici 2. Escriu el mateix programa PL/SQL de l’exercici 1, però ara també s’ha de controlar que el
primer número sigui més gran que el segon. En cas contrari s’ha de mostrar el següent missatge:
‘Error! el primer número ha de ser més gran que el segon’.*/
do $$
    declare
        num1 integer = :"Donem un numero";
        num2 integer = :"Donem un segon numero";
        result integer;
    begin
        if num1 >= 0 and num2 >= 0 then
            if num1 > num2 then
                result = (num1 / num2) + num2;
                raise notice 'El resultat es: %', result;
            else
                raise  notice  'Error! el primer número ha de ser més gran que el segon';
            end if;
        else
            raise notice 'Un dels dos numeros que has introduit no es positiu';
        end if;
    end;
$$;


/*Exercici 3. Escriu un programa PL/SQL que demani a l’usuari la seva edat i mostri el missatge
corresponent, si:
a) Entre 0 i 17 mostres 'Ets menor de edat!'
b) Entre 18 i 40 mostres 'Ja ets major de edat!'
d) > 40 mostres 'ja ets força gran'
e) Si és negatiu (<0) mostres 'L ́edat no pot ser negativa'.*/

do $$
    declare
        edad integer = :'Donem la teva edad';
    begin
        if edad > 0 and edad <= 17 then
            raise notice 'Ets menor de edat!';
        elsif edad >= 18 and edad <= 40 then
            raise notice 'Ja ets major de edat!';
        elsif edad > 40 then
            raise notice 'Ja ets força gran';
        else
            raise notice 'L ́edat no pot ser negativa';
        end if;
    end;
$$;

/*Exercici 4. Escriu un programa PL/SQL que demani quina operació es farà:
opció 1 SUMAR, opció 2 RESTAR, opció 3 MULTIPLICAR, opció 4 DIVIDIR .
Després el programa també demana dos números i ha de realitzar la operació escollida amb els dos
números introduits per teclat. S’ha de mostrar l’operació escollida, els números introduïts i el resultat.*/

do $$
    declare
        optionuser integer = :'Que vols fer:\n opció 1 SUMAR,\n opció 2 RESTAR,\n opció 3 MULTIPLICAR,\n opció 4 DIVIDIR?';
        num1 integer = :"Donem el primer numero de la operacio que vols fer";
        num2 integer = :"Donem el segon numero de la operacio que vols fer";
    begin
        if optionuser = 1 then
            raise notice 'El resultat de la suma es: %', (num1 + num2);
        elsif optionuser = 2 then
            raise notice 'El resultat de la resta es: %', (num1 - num2);
        elsif optionuser = 3 then
            raise notice 'El resultat de la multiplicacio es: %', (num1 * num2);
        elsif optionuser = 4 then
            raise notice 'El resultat de la divisio es: %', (num1 / num2);
        else
            raise notice 'Error no has donat el numero correcta de la operacio que vols fer';
        end if;
    end;
$$;

/*Exercici 5. Escriu un programa PL/SQL que ens mostri els números entre un rang. El rang mínim és 1
i el màxim se li ha de preguntar a l’usuari i no pot ser menor que 2. Si no és 2 o més gran es mostra un
missatge a l'usuari i finalitza el programa.
a. Utilitza l’estructura FOR.
b. Utilitza l’estructura WHILE.*/

/* WHILE */
do $$
    declare
        rangmin integer = 1;
        rangmax integer = :'Donem el valor maxim del rang (no pot ser menor que 2):';
    begin
        if rangmax >= 2 then
            raise notice 'El rang de numero es:';
            while rangmin <= rangmax loop
                raise notice '%', rangmin;
                rangmin = rangmin + 1;
            end loop;
        else
            raise notice 'El numero introduit no es mes gran o igual a 2';
        end if;

    end;
$$;

/* FOR */
do $$
    declare
        rangmin integer = 1;
        rangmax integer = :'Donem el valor maxim del rang (no pot ser menor que 2):';
    begin
        if rangmax >= 2 then
            raise notice 'El rang de numero es:';
            for i in rangmin..rangmax loop
                raise notice '%', i;
            end loop;
        else
            raise notice 'El numero introduit no es mes gran o igual a 2';
        end if;

    end;
$$;

/*Exercici 6. Escriu un programa PL/SQL que mostri els números entre un rang amb un salt. Tant el
rang mínim, com el màxim i el salt se li ha de preguntar a l’usuari. A més, s’ha de tenir en compte
que el rang mínim sempre ha de ser més petit que el rang màxim i que el el salt ha de ser més gran
que 1. En cas contrari s’ha de mostrar el missatge corresponent i acabar el programa.*/

do $$
    declare
        rangmin integer = :'Donem el valor minim del rang';
        rangmax integer = :'Donem el valor maxim del rang';
        salt integer = :'Donem el salt del rang';
    begin
        if rangmin < rangmax then
            if salt > 1 then
                WHILE rangmin <= rangmax LOOP
                    raise notice '%', rangmin;
                    rangmin = rangmin + salt;
                END LOOP;
            else
                raise notice 'El valor del salt a de ser mes gran que 1';
            end if;
        else
            raise notice 'El rang minim a de ser mes petit que el rang maxim';
        end if;
    end;
$$