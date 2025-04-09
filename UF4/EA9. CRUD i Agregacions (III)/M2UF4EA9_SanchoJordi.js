// Exercici 1. Eliminacions
// a) Elimina totes les persones que el nom continguin l'expressió regular "berl". 
//Has de tenir en compte el case sensitive.
db.people.deleteMany({"name":/berl/i})

// b) Elimina el camp <«latitude» de tots els documents de la col·lecció.
db.people.updateMany({},{$unset:{"latitude":""}})

// c) Elimina el tag "enim" del camp "tags" de la persona anomenda "Aubrey Calhoun".
db.people.updateOne({"name":"Aubrey Calhoun"}, {$pull : {"tags": "enim"}})

// d) Elimina l'últim element del camp tags de la persona anomenada "Caroline Webster".
db.people.updateOne({"name":"Aubrey Calhoun"}, {$pop : {"tags": 1}})

// Exercici 2. Agregacions
// a) Mostra totes les persones que tinguin 7 o més etiquetes (tags). 
// Utilitza l'estructura aggregate. Utilitza les funcions $project i $match, i 
// mostra només el nom de la persona i número d'etiquetes.

db.people.aggregate([{$project:{"name":1,"tags":1,"numTags":{$size:"$tags"}}},{$match:{"numTags":{$gte:7}}}])

