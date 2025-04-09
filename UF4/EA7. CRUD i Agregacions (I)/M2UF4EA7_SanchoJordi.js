// Exercici 1. Insercions
/* Inserta els dos registres que trobaras al fitxer dadesInserts.json dins la col·lecció "people". Si hi ha algun registre que no pots insertar degut a la sintaxis, corregeix el que sigui necessari per insertar el registre.*/
db.people.insertOne({

	"isActive" : false,
	"balance" : "$7,640.00",
	"picture" : "http://placehold.cat/32x32",
	"age" : 46,
	"name" : "Manuel Pares",
	"company" : "Tutor",
	"phone" : "843-729-40809",
	"email" : "mpares@tutor.com",
	"address" : "33785, Rome,Rescue aveniu",
	"about" : "Ad nostrud aliquip elit labore. Tempor consequat laboris incididunt consequat. Minim ex magna mollit laborum occaecat aliqua enim veniam. In culpa eiusmod irure do et et laborum non exercitation consequat sit voluptate exercitation id.\r\n",
	"registered" : "2000-02-12T01:35:45 -01:00",
	"latitude" : -12,
	"tags" : [
		"do",
		"qui",
		"adipisicing",
		"siusmod",
		"dolore",
		"magna",
		"reprehenderit"
	],
	"friends" : [
		{
			"id" : 1,
			"name": "Alyssa Oldman"
		},
		{
			"id" : 2,
			"name" : "Serenity Oswald"
		},
		{
			"id" : 3,
			"name" : "Sofia Webster"
		}
	],
	"gender" : "male",
	"randomArrayItem" : "teacher",
})

db.people.insertOne({
	"isActive" : false,
	"balance" : "$6,540.00",
	"picture" : "http://placehold.it/32x32",
	"age" : 39,
	"name" : "Aly Sheldon",
	"company" : "Cobbs",
	"phone" : "655-733-32802",
	"email" : "asheldon@cobbs.com",
	"address" : "32687, Cincinnati,,Alisson street",
	"about" : "Ad nostrud aliquip elit labore. Tempor consequat laboris incididunt consequat. Minim ex magna mollit laborum occaecat aliqua enim veniam. In culpa eiusmod irure do et et laborum non exercitation consequat sit voluptate exercitation id.\r\n",
	"registered" : "1994-05-29T03:14:10 -02:00",
	"latitude" : -9,
	"tags" : [
		"do",
		"qui",
		"incididunt",
		"siusmod",
		"dolore",
		"qui",
		"reprehenderit"
	],
	"friends" : [
		{
			"id" : 1,
			"name" : "Mariah Campbell"
		},
		{
			"id" : 2,
			"name" : "Serenity Oswald"
		},
		{
			"id" : 3,
			"name" : "Layla WifKinson"
		}
	],
	"gender" : "female",
	"randomArrayItem" : "student"
})

// Exercici 2. Consultes
// a) Mostra les persones que el camp "name" acabi amb la lletra "n" però mostra només el camp "email".
db.people.find({"name":/n$/i},{"email":1, "_id":0})

// b) Mostra les persones que tinguin dins el camp "tags" o la paraula "qui" o la paraula "sunt". Limita que es mostrin només 8 documents, i que es vegin en un format "bonic".
db.people.find({"tags":{$in:["qui","sunt"]}}).limit(8).pretty()

// c) Mostra les persones que tenen com a amiga a "Serenity Nelson". Mostra els resultats en un format "bonic".
db.people.find({"friends.name":"Serenity Nelson"}).pretty()

// d) Quantes persones s'han registrat entre l'any 2001 i 2018 (inclosos) i que en el camp "company" aparegui l'expressió regular "jam"? Has de mostrar el número de persones.
db.people.find({"registered":{$gte:"2001-01-01",$lte:"2018-12-31"},"company":/jam/i}).count()

// e) Mostra les persones que no tinguin com tags ni "tempor" ni "nulla". Mostra només el camp "tags".
db.people.find({"tags":{$nin:["tempor","nulla"]}},{"tags":1, "_id":0})

// f) Mostra totes les persones de sexe femeni que tinguin 3 amics i que no estiguin actives. Mostra els resultats en un format "bonic".
db.people.find({"gender": "female","friends":{$size:3},"isActive":false}).pretty()


// Exercici 3. Agregacions
// a) Mostra una llista amb el nom de tots els amics de les persones. Utilitza l'estructura aggregate.
db.people.aggregate([{$unwind:"$friends"},{$group:{"_id":"$friends.name"}}])
// b) Cada persona té un array d'etiquetes (tags). Mostra quantes vegades apareix cada etiqueta. Utilitza l'estructura aggregate.
db.people.aggregate([{$unwind:"$tags"},{$group:{"_id":"$tags",count:{$sum:1}}}])