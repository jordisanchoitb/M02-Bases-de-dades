// 1. Consulta de dades utilitzant expressions regulars a la col·lecció "movieDetails".
// a. Cerca totes les pel licules que a la seva sinopsis conté la paraula "Bilbo".
db.movieDetails.find({plot: /Bilbo/i});
// b. Cerca totes les pel·lícules que a la seva sinopsis conté la paraula "Gandalf".
db.movieDetails.find({plot: /Gandalf/i});
// c. Cerca totes les pel licules que a la seva sinopsis conté la paraula "Bilbo", però no la paraula "Gandalf"
db.movieDetails.find({$and: [{plot: /Bilbo/i}, {plot: {$not: /Gandalf/i}}]});
// d. Cerca totes les pel·lícules que a la seva sinopsis conté les paraules "dwarves" o "hobbit"
db.movieDetails.find({$or: [{plot: /dwarves/i}, {plot: /hobbit/i}]});
// e. Cerca totes les pel-licules que al seu titol conté les paraules "gold" i "dragons"
db.movieDetails.find({$and: [{title: /gold/i}, {title: /dragons/i}]});