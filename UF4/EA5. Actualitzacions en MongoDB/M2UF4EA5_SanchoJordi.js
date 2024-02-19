// 1. Actualització de Documents dins de la col·lecció "movieDetails".
/* a. Afegeix un camp anomenat "synopsis" al film "The Hobbit: An Unexpected Journey" amb aquest valor:
"A reluctant hobbit, Bilbo Baggins, sets out to the Lonely Mountain with a spirited group of dwarves to reclaim their mountain home and the gold within it - from the dragon Smaug."*/
db.movieDetails.updateOne({title: "The Hobbit: An Unexpected Journey"}, {$set: {"synopsis": "A reluctant hobbit, Bilbo Baggins, sets out to the Lonely Mountain with a spirited group of dwarves to reclaim their mountain home and the gold within it - from the dragon Smaug."}});

//b. Afegeix un actor anomenat "Samuel L. Jackson" al film "Pulp Fiction",
db.movieDetails.updateOne({title: "Pulp Fiction"}, {$push:
{actors: "Samuel L. Jackson"}});

//c. Elimina el camp type de tots els documents de la col·lecció "movieDetails".
db.movieDetails.updateMany({}, {$unset: {type: 1}});

//d. Modifica el cinquè guionista (writer) de la pel·lícula amb títol (title): "The World Is Not Enough", el cinquè gionista s'ha de dir "Bruce Harris".
db.movieDetails.updateOne({title: "The World Is Not Enough"}, {$set: {"writers.4": "Bruce Harris"}});

//e. Flimina l'últim element del camp genres de la pel-licula amb titol "Whisper of the Heart".
db.movieDetails.updateOne({title: "Whisper of the Heart"}, {$pop: {genres: 1}});