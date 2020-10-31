var fs = require('fs');
var parser = require('./WE_C3D');


fs.readFile('./entrada.txt', (err, data) => {
    if (err) throw err;
    var a = parser.parse(data.toString());
    fs.writeFile('./salida.c',a[0],function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
    });
    /*
    var obj = JSON.parse(a[0]);
    //console.log(obj)
    fs.writeFile('./output.json',a[0],function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
    });*/

});
