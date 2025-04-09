// Exercici 1
//a)
db.restaurants.insertOne({
    "address" : {
        "building" : "6870",
        "coord" : [
            -73.997415,
            40.7272948
        ],
        "street" : "Bleecker Street",
        "zipcode" : "10012"
    },
   "borough" : "Manhattan",
   "cuisine" : "Café/Coffee/Tea",
   "grades" :
        {
           "date" : ISODate("2015-01-10T00:00:00.000Z"),
           "grade" : "Z",
           "score" : 20
        },
   "name" : "Cafe Javi Linde, el cafe que te pone!",
   "restaurant_id" : "999999992"
})

///b)
db.restaurants.insertOne({
    "address" : {
       "building" : "3850",
       "street" : "Richmond Avenue",
       "zipcode" : 10312
    },
   "borough" : "Staten Island",
   "cuisine" : "Pizza",
   "name" : "David Vaquer - El pizzero espagnol",
   "restaurant_id" : "99999999"
})


//c)

db.restaurants.insertOne({
    "address" : {
        "building" : "24",
        "coord" : [
            -73.9812198,
            40.7509706
        ],
        "street" : "East   39 Street",
        "zipcode" : "10016"
    },
    "borough" : "Manhattan",
    "cuisine" : "American ",
    "name" : "Joan_Gomez's» Hamburgers ",
    "restaurant_id" : "999999991"
})

// Exercici 2
// a) Mostra tots els productes que siguin de la categoria "watch" o "tv".
db.products.find({$or: [{categories: "watch"}, {categories: "tv"}]})

// b) Mostra el nom i el preu dels productes que el seu stock sigui més gran de 25 i que tingui la categoria de "ipad".
db.products.find({stock: {$gt: 25}, categories: "ipad"}, {name: 1, price: 1})

// c) Mostra tots els restaurants que estiguin ubicats al al barri (borough) del Bronx i que sigui de cuina chinese o Gelato.
db.restaurants.find({borough: "Bronx", $or: [{cuisine: "Chinese"}, {cuisine: "Gelato"}]})

// d) Mostra els restaurants que el zipcode sigui 11209 i cuisine = Delicatessen. 
//Ordena els resultats de manera ascendent pel restaurant_id.
db.restaurants.find({"address.zipcode": "11209", cuisine: "Delicatessen"}).sort({restaurant_id: 1})

// e) Mostra tots els restaurants que el seu tipus de cuina contingui les lletres "w" i "f" (has de tenir en compte el case sensitive).
db.restaurants.find({cuisine: /w|f/i})

// f) Mostra tots els productes que el preu estigui entre 500 i 1000 (ambdos inclosos). 
//Mostra el resultat ordenat pel camp "name" de manera descendent i en format bonic.
db.products.find({price: {$gte: 500, $lte: 1000}}).sort({name: -1}).pretty()

// g) Mostra els restaurants que el camp "name" acabi amb la lletra "o" però mostra només els camps "cuisine" i "street". Limita que es veguin només 5 restaurants.
db.restaurants.find({name: /o$/}, {cuisine: 1, "address.street": 1}).limit(5)



// Exercici 3
// a) Modifica les coordenades del restaurant amb "restaurant_id": "40368271". 
// Les noves coordenades són: "-61.886970, 38.72532".
db.restaurants.updateOne({restaurant_id: "40368271"}, {$set:{"address.coord.0" : -61.886970, "address.coord.1":38.72532}})

// b) Modifica la categoria del producte amb nom "MacBook Pro", 
// ja no té la categoria "notebook" la nova categoria és "ipad".
db.products.updateOne({name:"MacBook Pro", categories: "notebook"},{$set:{"categories.$":"ipad"}})

// c) Afegeix una altra categoria al producte amb nom "iPhone 6s" la categoria es diu "Superphone".
db.products.updateOne({name:"iPhone 6s"},{$push:{categories:"Superphone"}})

// d) Afegeix un nou camp anomenat "Likes" als restaurans que siguin de 
// cuina tipus "Caribbean" i ubicats al barri (borough) de "Manhattan" amb el valor "10000".
db.restaurants.updateMany({"cuisine":"Caribbean", borough:"Manhattan"},{$set:{"Likes":10000}})

// Exercici 4. 
// a) Elimina tots els productes que el stock sigui més petit de 20.
db.products.deleteMany({stock: {$lt: 20}})

// b) Elimina la primera categoria del producte amb nom "iPad Pro"
db.products.updateOne({name:"iPad Pro"},{$pop:{categories:-1}})

// c) Elimina tots els productes que tinguin la categoria de "phone".
db.products.deleteMany({categories: "phone"})

// d) Elimina el camp "cuisine" tots els restaurants situats al "Bronx".
db.restaurants.updateMany({borough: "Bronx"},{$unset:{cuisine:1}})

// Exercici 5.
// a) Mostra el número de categories que té cada producte.
db.products.aggregate([{$project:{_id: 0, name:1, numCategories:{$size:"$categories"}}}])

// b) De la col·lecció "restaurants" mostra els noms dels carrers per cada codi postal.
db.restaurants.aggregate([{$group:{_id:"$address.zipcode", streets:{$addToSet:"$address.street"}}}])

// c) Mostra el número de vegades que apareix cada categoria a la col·lecció productes. 
// Mostra només el nom del producte i el número de categories.
db.products.aggregate([{$unwind:"$categories"},{$group:{_id:"$name", numCategories:{$sum:1}}}])

// d) Mostra la mitjana del preu de tots els productes.
db.products.aggregate([{$group:{_id:0, avgPrice:{$avg:"$price"}}}])