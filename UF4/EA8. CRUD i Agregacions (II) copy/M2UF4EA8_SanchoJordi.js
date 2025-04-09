// Exercici 1. Actualitzacions
// a) Afegeix un nou camp anomenat "longitude" a totes les persones que en la seva adreça contingui la paraula "Berkeley". 
//El valor d'aquest nou camp serà de 1. Has de tenir en compte el case sensitive.
db.people.updateMany({"address":/berkeley/i},{$set:{"longitude":1}})
// b) Afegeix un altre tag anomenat "foot", a la persona anomenada "Bella Carrington".
db.people.updateOne({"name":"Bella Carrington"}, {$push:{"tags":"foot"}})

// c) Afegeix un altre subdocument (amic) al camp «friends» de la persona anomenada "Julia Young". 
//El nou subdocument té al camp "id" el valor "1" i al camp "name" el valor "Trinity Ford".
db.people.updateOne({"name":"Julia Young"}, {$push:{"friends":{"id":1,"name":"Trinity Ford"}}})

// d) Modifica el segon tag de la persona anomenada "Ava Miers"", el segon tag s'ha de dir "sunt".
db.people.updateOne({"name":"Ava Miers"}, {$set:{"tags.1":"sunt"}})

// Exercici 2. Agregacions
// a) Calcula la mitjana d'edat del homes i la mitjana d'edat de les dones. Utilitza l'estructura aggregate, i 
// utilitza les funcions $group i $avg. 
//Mostra el gènere (camp "gender") i la mitjana d'edat del gènere (camp "age").
db.people.aggregate({$group:{"_id":"$gender", "avgGender":{$avg:"$age"}}})
