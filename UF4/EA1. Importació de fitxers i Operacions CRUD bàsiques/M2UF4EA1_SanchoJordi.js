/* Primer he seguit el tutorial per importar els fitxers i per poder utilitzat
el datagrip per el mongodb */
/*Ejercicio 1

    Levantar el servidor de MongoDB
    Conectarse al cliente de MongoDB
    Crear una base de datos con el nombre catalogo
    Crear la colección productos
    Crear los siguientes documentos de a uno

{"name": "MacBook Pro"}
{"name": "MacBook Air"}
{"name": "MacBook"})

    Listar las bases de datos disponibles
    Listar las colecciones disponibles para la base de datos catalogo
    Desconectar el cliente de MongoDB
    Volver a levantar el cliente de MongoDB pero en esta oportunidad queremos que se conecte directamente a la base de catalogo sin pasar por la base de test
*/

// 1. Levantar el servidor de MongoDB
// Abrimos la maquina virtual
// 2. Conectarse al cliente de MongoDB
// Abrimos la terminal y ejecutamos el siguiente comando: mongo
// 3. Crear una base de datos con el nombre catalogo
use catalogo
// 4. Crear la colección productos
db.createCollection("productos")

// 5. Crear los siguientes documentos de a uno
db.productos.insert({"name": "MacBook Pro"})
db.productos.insert({"name": "MacBook Air"})
db.productos.insert({"name": "MacBook"})

// 6. Listar las bases de datos disponibles
show dbs

// 7. Listar las colecciones disponibles para la base de datos catalogo
show collections

// 8. Desconectar el cliente de MongoDB
exit

// 9. Volver a levantar el cliente de MongoDB pero en esta oportunidad queremos que se conecte directamente a la base de catalogo sin pasar por la base de test
mongo catalogo

/*Ejercicio 2

    Levantar el cliente de MongoDB en la base de datos catalogo
    Buscar todos los documentos de la colección productos
    Buscar el documento que tiene la propiedad name con el valor MacBook Air
 */

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Buscar todos los documentos de la colección productos
db.productos.find()

// 3. Buscar el documento que tiene la propiedad name con el valor MacBook Air
db.productos.find({"name": "MacBook Air"})

/*Ejercicio 3

    Levantar el cliente de MongoDB en la base de datos catalogo
    Buscar todos los documentos de la colección productos utilizando un cursor
    Iterar sobre los documento utilizando hasNext y next para cada documento
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Buscar todos los documentos de la colección productos utilizando un cursor
var cursor = db.productos.find()

// 3. Iterar sobre los documento utilizando hasNext y next para cada documento
while(cursor.hasNext()){
    cursor.next()
}
// El bucle while funciona pero sol es mostra l'ultim resultat ja que el bucle es va repetint fins arribar al final i sol es mostra l'ultim resultat
// ja que el cursor.hasNext() ens va donant true fins arribar al final que ens donara false i el while es para

/*Ejercicio 4
Levantar el cliente de MongoDB en la base de datos catalogo
Insertar los siguientes documentos en la colección productos utilizando un sólo comando de MongoDB
{"name": "iPhone 8"}
{"name": "iPhone 6s"}
{"name": "iPhone X"}
{"name": "iPhone SE"}
{"name": "iPhone 7"}
Listar todos los documentos de la colección productos
Buscar el docuemnto que tiene la propiedad name con el valor iPhone 7
Buscar el docuemnto que tiene la propiedad name con el valor MacBook
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Insertar los siguientes documentos en la colección productos utilizando un sólo comando de MongoDB
db.productos.insertMany([{"name": "iPhone 8"}, {"name": "iPhone 6s"}, {"name": "iPhone X"}, {"name": "iPhone SE"}, {"name": "iPhone 7"}])

// 3. Listar todos los documentos de la colección productos
db.productos.find()

// 4. Buscar el docuemnto que tiene la propiedad name con el valor iPhone 7
db.productos.find({"name": "iPhone 7"})
// 5. Buscar el docuemnto que tiene la propiedad name con el valor MacBook
db.productos.find({"name": "MacBook"})


/*Ejercicio 5
Levantar el cliente de MongoDB en la base de datos catalogo
Borrar la colección productos
Borrar la base de datos catalogo
Crear la base de datos catalogo y colección productos de nuevo
Insertar los siguientes documentos utilizando un sólo comando de MongoDB
{"name": "iPhone 8"}
{"name": "MacBook Pro"}
{"name": "iPhone 6s"}
{"name": "MacBook Air"}
{"name": "iPhone X"}
{"name": "iPhone SE"}
{"name": "MacBook"})
{"name": "iPhone 7"}
Buscar el producto que tiene la propiedad name con el valor iPhone X */

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Borrar la colección productos
db.productos.drop()

// 3. Borrar la base de datos catalogo
db.dropDatabase()

// 4. Crear la base de datos catalogo y colección productos de nuevo
use catalogo

// 5. Insertar los siguientes documentos utilizando un sólo comando de MongoDB
db.productos.insertMany([{"name": "iPhone 8"}, 
                        {"name": "MacBook Pro"}, 
                        {"name": "iPhone 6s"}, 
                        {"name": "MacBook Air"}, 
                        {"name": "iPhone X"}, 
                        {"name": "iPhone SE"}, 
                        {"name": "MacBook"},
                        {"name": "iPhone 7"}])

// 6. Buscar el producto que tiene la propiedad name con el valor iPhone X
db.productos.find({"name": "iPhone X"})

/*  Ejercicio 6
Importar el archivos de documentos products.json en la base de datos catalogo y utilizar la colección productos
Al importar los datos se deben borrar todos los datos anteriores de la colección
Buscar todos los documentos importados
Mostrar los resultados de una forma más linda y fácil de ver
Buscar los documentos que tienen la propiedad price con el valor de 329
Buscar los documentos que tienen la propiedad stock con el valor de 100
Buscar los documentos que tienen la propiedad name con el valor de Apple Watch Nike+
*/

// 1. Importar el archivos de documentos products.json en la base de datos catalogo y utilizar la colección productos
// --db: nombre de la base de datos
// --collection: nombre de la colección
// --drop: borra los datos anteriores de la colección
// --file: nombre del archivo que queremos importar
// mongoimport --db catalogo --collection products --drop --file productos.json

// 2. Buscar todos los documentos importados
db.productos.find()

// 3. Mostrar los resultados de una forma más linda y fácil de ver
db.productos.find().pretty()

// 4. Buscar los documentos que tienen la propiedad price con el valor de 329
db.productos.find({"price": 329})

// 5. Buscar los documentos que tienen la propiedad stock con el valor de 100
db.productos.find({"stock": 100})

// 6. Buscar los documentos que tienen la propiedad name con el valor de Apple Watch Nike+
db.productos.find({"name": "Apple Watch Nike+"})

/* Ejercicio 7
Levantar el cliente de MongoDB en la base de datos catalogo
Buscar los productos que tienen la propiedad name con el valor 1 y la propiedad price con el valor 1
Buscar los productos que tienen las categorías macbook y notebook
Buscar los productos que tienen la categoría watch
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Buscar los productos que tienen la propiedad name con el valor 1 y la propiedad price con el valor 1
db.productos.find({"name": 1, "price": 1})

// 3. Buscar los productos que tienen las categorías macbook y notebook
db.productos.find({"categories": ["macbook", "notebook"]})

// 4. Buscar los productos que tienen la categoría watch
db.productos.find({"categories": "watch"})

/* Ejercicio 8
Levantar el cliente de MongoDB en la base de datos catalogo
Buscar los productos que tienen la propiedad price con el valor 2399 y mostrar sólo la propiedad name en el resultado
Buscar los productos que tienen la propiedad categories con el valor iphone y ocultar las propiedad stock y picture del resultado
Repetir todas las búsquedas anteriores y ocultar la propiedad _id en todas ellas
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Buscar los productos que tienen la propiedad price con el valor 2399 y mostrar sólo la propiedad name en el resultado
db.productos.find({"price": 2399}, {"name": 1, "_id": 0})

// 3. Buscar los productos que tienen la propiedad categories con el valor iphone y ocultar las propiedad stock y picture del resultado
db.productos.find({"categories": "iphone"}, {"stock": 0, "picture": 0})

// 4. Repetir todas las búsquedas anteriores y ocultar la propiedad _id en todas ellas
db.productos.find({"price": 2399}, {"name": 1, "_id": 0})

db.productos.find({"categories": "iphone"}, {"stock": 0, "picture": 0, "_id": 0})

/* Ejercicio 9
Levantar el cliente de MongoDB en la base de datos catalogo
Buscar los productos que tienen la propiedad price mayor a 2000
Buscar los productos que tienen la propiedad price menor a 500
Buscar los productos que tienen la propiedad price menor o igual que 500
Buscar los productos que tienen la propiedad price en el rango de 500 a 1000
Buscar los productos que tienen la propiedad price con alguno de los siguientes valores 399 o 699 o 1299 (hacer en un solo query)
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Buscar los productos que tienen la propiedad price mayor a 2000
db.productos.find({"price": {$gt: 2000}})

// 3. Buscar los productos que tienen la propiedad price menor a 500
db.productos.find({"price": {$lt: 500}})

// 4. Buscar los productos que tienen la propiedad price menor o igual que 500
db.productos.find({"price": {$lte: 500}})

// 5. Buscar los productos que tienen la propiedad price en el rango de 500 a 1000
db.productos.find({"price": {$gte: 500, $lte: 1000}})

// 6. Buscar los productos que tienen la propiedad price con alguno de los siguientes valores 399 o 699 o 1299 (hacer en un solo query)
db.productos.find({"price": {$in: [399, 699, 1299]}})

/* Ejercicio 10
Levantar el cliente de MongoDB en la base de datos catalogo
Buscar los productos que tienen la propiedad stock con el valor 200 Y tienen la categoría iphone (utlizar el operador and)
Buscar los productos que tienen la propiedad price con el valor 329 O tienen la categoría tv (utlizar el operador or)
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Buscar los productos que tienen la propiedad stock con el valor 200 Y tienen la categoría iphone (utlizar el operador and)
db.productos.find({$and: [{"stock": 200}, {"categories": "iphone"}]})

// 3. Buscar los productos que tienen la propiedad price con el valor 329 O tienen la categoría tv (utlizar el operador or)
db.productos.find({$or: [{"price": 329}, {"categories": "tv"}]})

/* Ejercicio 11
Levantar el cliente de MongoDB en la base de datos catalogo
Actualizar el producto que tiene la propiedad name con el valor Mac mini y establecer la propiedad stock con el valor 50
Actualizar el producto que tiene la propiead name con el valor iPhone X y agregarle la propiedad prime con el valor true
Buscar los documentos actualizados y listarlos mostrando los datos de forma más linda y ocultando las propiedades stock, categories y _id
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Actualizar el producto que tiene la propiedad name con el valor Mac mini y establecer la propiedad stock con el valor 50
db.productos.update({"name": "Mac mini"}, {$set: {"stock": 50}})

// 3. Actualizar el producto que tiene la propiead name con el valor iPhone X y agregarle la propiedad prime con el valor true
db.productos.update({"name": "iPhone X"}, {$set: {"prime": true}})

// 4. Buscar los documentos actualizados y listarlos mostrando los datos de forma más linda y ocultando las propiedades stock, categories y _id
db.productos.find({"name": "Mac mini"}, {"stock": 0, "categories": 0, "_id": 0}).pretty()

/* Ejercicio 12
Levantar el cliente de MongoDB en la base de datos catalogo
Actualizar el producto con la propiedad name y el valor iPad Pro agregadole una categoría nueva llamada prime
Actualizar el producto con la propiedad name y el valor iPad Pro sacar la categoría agregada (último elemento de la propiedad categories)
Actualizar el producto con la propiedad name y el valor iPhone SE sacar la primer categoría que tiene asignada
Actualizat todos los documentos que tienen la propiedad price mayor a 2000 y agregarle la categoría expensive
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Actualizar el producto con la propiedad name y el valor iPad Pro agregadole una categoría nueva llamada prime
db.productos.updateOne({"name": "iPad Pro"}, {$push: {"categories": "prime"}})

// 3. Actualizar el producto con la propiedad name y el valor iPad Pro sacar la categoría agregada (último elemento de la propiedad categories)
db.productos.updateOne({"name": "iPad Pro"}, {$pop: {"categories": 1}})

// 4. Actualizar el producto con la propiedad name y el valor iPhone SE sacar la primer categoría que tiene asignada
db.productos.updateOne({"name": "iPhone SE"}, {$pop: {"categories": -1}})

// 5. Actualizat todos los documentos que tienen la propiedad price mayor a 2000 y agregarle la categoría expensive
db.productos.updateMany({"price": {$gt: 2000}}, {$push: {"categories": "expensive"}})

/* Ejercicio 13
Levantar el cliente de MongoDB en la base de datos catalogo
Borrar todos los productos que tienen la categoía tv
Borrar el producto que tiene la propiedad name con el valor Apple Watch Series 1
Obtener la propiedad _id del producto que tiene la propiedad name con el valor Mac mini
Utilizar el _id buscado para borrar el producto utilizando ese criterio
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Borrar todos los productos que tienen la categoía tv
db.productos.deleteMany({"categories": "tv"})

// 3. Borrar el producto que tiene la propiedad name con el valor Apple Watch Series 1
db.productos.deleteOne({"name": "Apple Watch Series 1"})

// 4. Obtener la propiedad _id del producto que tiene la propiedad name con el valor Mac mini
// Utilizar el _id buscado para borrar el producto utilizando ese criterio
var id = db.productos.findOne({"name": "Mac mini"})._id
db.productos.deleteOne({"_id": id})

/*Ejercicio 14
Importar el archivos de documentos products.json en la base de datos catalogo y utilizar la colección productos
Al importar los datos se deben borrar todos los datos anteriores de la colección
Buscar todos los documentos importados
*/

// 1. Importar el archivos de documentos products.json en la base de datos catalogo y utilizar la colección productos
// mongoimport --db catalogo --collection products --drop --file productos.json

// 2. Buscar todos los documentos importados
db.productos.find()

/* Ejercicio 15
Levantar el cliente de MongoDB en la base de datos catalogo
Buscar todos los productos y ordenarlos por la propiedad price ascendente
Buscar todos los productos y ordenarlos por la propiedad price descendente
Buscar todos los productos y ordenarlos por la propiedad stock ascendente
Buscar todos los productos y ordenarlos por la propiedad stock descendente
Buscar todos los productos y ordenarlos por la propiedad name ascendente
Buscar todos los productos y ordenarlos por la propiedad name descendente
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Buscar todos los productos y ordenarlos por la propiedad price ascendente
db.productos.find().sort({"price": 1})

// 3. Buscar todos los productos y ordenarlos por la propiedad price descendente
db.productos.find().sort({"price": -1})

// 4. Buscar todos los productos y ordenarlos por la propiedad stock ascendente
db.productos.find().sort({"stock": 1})

// 5. Buscar todos los productos y ordenarlos por la propiedad stock descendente
db.productos.find().sort({"stock": -1})

// 6. Buscar todos los productos y ordenarlos por la propiedad name ascendente
db.productos.find().sort({"name": 1})

// 7. Buscar todos los productos y ordenarlos por la propiedad name descendente
db.productos.find().sort({"name": -1})

/* Ejercicio 16
Levantar el cliente de MongoDB en la base de datos catalogo
Mostrar sólo la propiedad name de los primeros 2 productos
Mostrar sólo la propiedad name de los primeros 5 productos ordenados por nombre
Mostrar sólo la propiedad name de los últimos 5 productos ordenados por nombre
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Mostrar sólo la propiedad name de los primeros 2 productos
db.productos.find({}, {"name": 1, "_id": 0}).limit(2)

// 3. Mostrar sólo la propiedad name de los primeros 5 productos ordenados por nombre
db.productos.find({}, {"name": 1, "_id": 0}).sort({"name": 1}).limit(5)

// 4. Mostrar sólo la propiedad name de los últimos 5 productos ordenados por nombre
db.productos.find({}, {"name": 1, "_id": 0}).sort({"name": -1}).limit(5)

/* Ejercicio 17
Levantar el cliente de MongoDB en la base de datos catalogo
Mostrar todos los documentos de la colección products utilizando un paginador
El tamaño de la página tiene que ser de 5 documentos
*/

// 1. Levantar el cliente de MongoDB en la base de datos catalogo
mongo catalogo

// 2. Mostrar todos los documentos de la colección products utilizando un paginador
// El tamaño de la página tiene que ser de 5 documentos
for (var i = 0; i < db.productos.count(); i += 5){
    db.productos.find().skip(i).limit(5)
}
// el for funciona pero sol mostra l'ultim resultat ja que hi han 21 documents i el for va mostrar de 5 en 5 fins arribar al final que sol mostre 1
// les iteracions que fa el for son les seguents:
db.productos.find().skip(0).limit(5)
db.productos.find().skip(5).limit(5)
db.productos.find().skip(10).limit(5)
db.productos.find().skip(15).limit(5)
db.productos.find().skip(20).limit(5)
db.productos.find().skip(25).limit(5)