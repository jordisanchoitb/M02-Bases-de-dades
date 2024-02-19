// firstname,lastname1,lastname2,dni,gender,email,phone,phone_aux,birth_year
// 1. Busqueu els estudiants de gènere masculí
db.students.find({"gender":"H"})

/*2. Busqueu el estudiants de gènere femení */
db.students.find({"gender":"M"})

/*3. Busqueu els estudiants nascuts l'any 1993 */
db.students.find({"birth_year":1993})

/*4. Busqueu els estudiants de gènere masculí nascuts a l'any 1993 */
db.students.find({"birth_year":1993, "gender":"H"})

/*5. Busqueu els estudiant nascuts a la dècada dels 90 */
db.students.find({"birth_year":{$gte:1990, $lte:1999}})

//6. Busqueu els estudiants de gènere masculí nascuts abans del l'any 90 
db.students.find({"birth_year":{$lt : 1990}, "gender":"H"})

//7. Busqueu els estudiants de gènere femení nascuts abans del l'any 90 
db.students.find({"birth_year":{$lt : 1990}, "gender":"M"})

//8. Busqueu els estudiants nascuts a la dècada dels 90 
db.students.find({"birth_year":{$gte:1990, $lte:1999}})

//9. Busqueu els estudiants de gènere masculí nascuts a la dècada dels 80 
db.students.find({"birth_year":{$gte:1980, $lte:1989}, "gender":"H"})

//10. Busqueu els estudiants de gènere femení nascuts a la dècada dels 80 
db.students.find({"birth_year":{$gte:1980, $lte:1989}, "gender":"M"})

//11. Busqueu els estudiants que no han nascut a l'han 1985 
db.students.find({"birth_year":{$ne:1985}})

//12. Busqueu els estudiants nascuts als anys 1970, 1980 o 1990 
db.students.find({"birth_year":{$in:[1970,1980,1990]}})

//13. Busqueu els estudiants no nascuts als anys 1970, 1980 o 1990 
db.students.find({"birth_year":{$nin:[1970,1980,1990]}})

//14. Busqueu els estudiants nascuts en any parell 
db.students.find({"birth_year":{$mod:[2,0]}})

//15. Busqueu els estudiants nascuts en any múltiple de 10 
db.students.find({"birth_year":{$mod:[10,0]}})

//16. Busqueu els estudiants que tinguin telèfon auxiliar 
db.students.find({"phone_aux":{$ne:""}})

//17. Busqueu els estudiants que no tinguin segon cognom 
db.students.find({"lastname2": ""})

//18. Busqueu els estudiants que tinguin telèfon auxiliar i un sol cognom 
db.students.find({"phone_aux":{$ne:""}, "lastname2":""})

//19. Busqueu els estudiants que tinguin un email que acabi en .net 
db.students.find({"email":/\.net$/})

//20. Busqueu els estudiants que tinguin un nom que comenci per vocal 
db.students.find({ "firstname": /^[aeiou]/i})

//21. Busqueu els estudiants que tinguin un nom més llarg de 13 caràcters 
db.students.find({ "firstname": {$regex:'.{13,}'}})

//22. Busqueu els estudiants que tinguin un nom amb més de 3 vocals 
db.students.find({ "firstname": /[aeiou].*[aeiou].*[aeiou].*[aeiou]/i})

//23. Busqueu els estudiants que tinguin un dni que comenci per lletra 
// amb la seguent comanda es filtran tots els dni que comencin per una lletra pero tambe mostre el null
db.students.find({"dni": /^[a-z]/i })
// amb la seguent commanda has filtran tots els dni que comencin per lletra i que no siguin nulls
db.students.find({$and : [{"dni":/^[a-z]/i}, {"dni":{$ne:"NULL"}}]})

//24. Busqueu els estudiants que tinguin un dni que comenci i acabi per lletra 
// amb la seguent comanda es filtran tots els dni que comencin i acabin per una lletra pero tambe mostre el null
db.students.find({ "dni": /^[a-z].*[a-z]$/i})
// amb la seguent commanda has filtran tots els dni que comencin i acabin per una lletra i que no siguin nulls
db.students.find({$and : [{ "dni": /^[a-z].*[a-z]$/i}, {"dni":{$ne:"NULL"}}]})

//25. Busqueu els estudiants que tinguin telèfon que comenci per 622 
db.students.find({ "phone": /^622/ })
