// 1. Insercio de dades. Inserta els seguents documents dins la col·leccio "movieDetails"
//a.
db.movieDetails.insertOne({title : "Fight Club",
    writer : "Chuck Palahniuk",
    year : 1999,
    actors : [
    "Brad Pitt",
    "Edward Norton"
    ]});
//b.
db.movieDetails.insertOne({title : "Pulp Fiction",
    writer : "Quentin Tarantino",
    year : 1994,
    actors : [
    "John Travolta",
    "Uma Thurman"
    ]});
//c.
db.movieDetails.insertOne({title : "Inglorious Bastards",
    writer : "Quentin Tarantino",
    year : 2009,
    actors : [
    "Brad Pitt",
    "Diane Kruger",
    "Eli Roth"
    ]});
//d.
db.movieDetails.insertOne({title : "The Hobbit: The Desolation of Smaug",
    writer : "J.R.R. Tolkein",
    year : 2013});
//e.

db.movieDetails.insertOne({title : "The Hobbit: The Battle of the Five Armies",
    writer : "J.R.R. Tolkein",
    year : 2012,
    synopsis : "Bilbo and Company are forced to engage in a war against an array of combatants and keep the Lonely Mountain from falling into the hands of a rising darkness."});
//f.
db.movieDetails.insertOne({title : "The Shawshank Redemption",
    writer : "Stephen King",
    year : 1994,
    actors : [
    "Tim Robbins",
    "Morgan Freeman",
    "Bob Gunton"
    ],
    synopsis : "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency." });
//g.
db.movieDetails.insertOne({title : "Avatar",
    writer : "James Cameron",
    year : 2009,
    actors : [
    "Sam Worthington",
    "Zoe Saldana",
    "Sigourney Weaver"
    ],
    synopsis : "A paraplegic marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home."});

// 2. Consulta de dades. Cerca dins de la col·leccio "movieDetails"
// a. Mostra tots els documents
db.movieDetails.find();

// b. Mostra totes les pel·lícules que tinguin com "writers" a ""Quentin Tarantino"
db.movieDetails.find({writers: "Quentin Tarantino"});

// c. Mostra totes les pel·lícules que tinguin el camp "actors" inclòs a "Brad Pitt"
db.movieDetails.find({actors: "Brad Pitt"});

// d. Mostra els documents que tinguin com a "genres" "Action" i "Western"
db.movieDetails.find({genres: {$in :["Action", "Western"]}});

// e. Mostra totes les pel·lícules que es van realitzar als 90
db.movieDetails.find({year: {$gte: 1990, $lte: 1999}});

// f. Mostra totes les pel·lícules que es van realitzar abans del any 2000 i després de l'any 2010.
db.movieDetails.find({$or: [{year: {$lt: 2000}},{year: {$lt: 2000}}]});

// g. Mostra totes les pel·lícules que el segon país del camp "countries" sigui Spain.
db.movieDetails.find({"countries.1": "Spain"});

// h. Mostra totes les pel·lícules que hagin guanyat més de 100 premis (El camp wins del camp awards).
db.movieDetails.find({"awards.wins": {$gt: 100}});

// i. Mostra totes les pel·lícules que tinguin 10 guionistes (writers).
db.movieDetails.find({writers: {$size: 10}});