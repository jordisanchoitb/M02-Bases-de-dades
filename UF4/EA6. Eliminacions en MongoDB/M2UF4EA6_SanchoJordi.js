// 1. Eliminar Documents de la col·lecció "movieDetails".
// a. Elimina la pel-licula que en el titol tingui Star Trek.
db.movieDetails.deleteOne({title: "Star Trek"});

// b. Elimina la pel·lícula Love Actually.
db.movieDetails.deleteOne({title: "Love Actually"});

// c. Elimina les pellicules que en el camp rated tingui "G".
db.movieDetails.deleteMany({rated: "G"});

// d. Elimina les pel·lícules que siguin etiquetades com "Western".
db.movieDetails.deleteMany({genres: "Western"});

// e. Elimina les pel·lícules que no hagin guanyat cap premi.
db.movieDetails.deleteMany({"awards.win": 0});