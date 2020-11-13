"use strict";
exports.__esModule = true;
exports.arreglo = exports.Arreglos = exports.bandera = exports.temporal = exports.simbolo = exports.TablaSimbolos = exports.s = void 0;
var s;
(function (s) {
    s[s["S_ASIGNATION"] = 0] = "S_ASIGNATION";
    s[s["S_DECLARATION"] = 1] = "S_DECLARATION";
    s[s["S_IF"] = 2] = "S_IF";
    s[s["S_FOR"] = 3] = "S_FOR";
    s[s["S_FORIN"] = 4] = "S_FORIN";
    s[s["S_FOROF"] = 5] = "S_FOROF";
    s[s["S_SWITCH"] = 6] = "S_SWITCH";
    s[s["S_DOWHILE"] = 7] = "S_DOWHILE";
    s[s["S_WHILE"] = 8] = "S_WHILE";
    s[s["S_EXPRESSION"] = 9] = "S_EXPRESSION";
    s[s["S_NATIVE"] = 10] = "S_NATIVE";
    s[s["S_STRINGNATIVE"] = 11] = "S_STRINGNATIVE";
})(s = exports.s || (exports.s = {}));
var TablaSimbolos = /** @class */ (function () {
    function TablaSimbolos() {
        this.entornoactual = '';
        this.simbolos = [];
        this.ambitoLevel = 0;
    }
    TablaSimbolos.prototype.printSimbolos = function () {
        for (var _i = 0, _a = this.simbolos; _i < _a.length; _i++) {
            var simbolitos = _a[_i];
            console.log("VARIABLE: " + simbolitos.name + "   |   TIPO: " + simbolitos.tipo + "    |   ROL: " + simbolitos.rol + "  |   AMBITO: " + simbolitos.ambito + "    |   POSITION: " + simbolitos.position + "   |   VALOR: " + simbolitos.valor + "   |   CONSTANTE: " + simbolitos.constante + " | ENTORNO: " + simbolitos.entorno);
        }
    };
    TablaSimbolos.prototype.insert = function (simbolo) {
        if (this.ambitoLevel == 0 && simbolo.entorno == '') {
            simbolo.entorno = 'global';
        }
        this.simbolos.push(simbolo);
    };
    TablaSimbolos.prototype.deleteAmbitoLast = function () {
        var simbols = [];
        var amb = this.ambitoLevel - 1;
        for (var _i = 0, _a = this.simbolos; _i < _a.length; _i++) {
            var a = _a[_i];
            if (a instanceof simbolo) {
                if (a.ambito <= amb || a.ambito == 0 || a.rol == 'funcion')
                    simbols.push(a);
            }
        }
        this.simbolos = [];
        for (var _b = 0, simbols_1 = simbols; _b < simbols_1.length; _b++) {
            var b = simbols_1[_b];
            this.simbolos.push(b);
        }
    };
    TablaSimbolos.prototype.update = function (name, simbolor) {
        var ambitoglob = true;
        var ambitoloc = false;
        for (var _i = 0, _a = this.simbolos; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof simbolo) {
                if (simbolito.name == name) {
                    if (simbolito.ambito == this.ambitoLevel && this.ambitoLevel > 0 && simbolito.ambito > 0) {
                        ambitoglob = false;
                        ambitoloc = true;
                    }
                    else if (simbolito.ambito < this.ambitoLevel && this.ambitoLevel > 0 && simbolito.ambito > 0) {
                        ambitoglob = false;
                    }
                }
            }
        }
        if (ambitoglob) {
            for (var _b = 0, _c = this.simbolos; _b < _c.length; _b++) {
                var simbolito = _c[_b];
                if (simbolito instanceof simbolo) {
                    if (simbolito.name == name && simbolito.ambito == 0 && simbolito.rol != 'funcion') {
                        simbolito = simbolor;
                        return true;
                    }
                }
            }
        }
        else {
            if (ambitoloc) {
                for (var _d = 0, _e = this.simbolos; _d < _e.length; _d++) {
                    var simbolito = _e[_d];
                    if (simbolito instanceof simbolo) {
                        if (simbolito.name == name) {
                            if (simbolito.ambito == this.ambitoLevel && simbolito.rol != 'funcion') {
                                simbolito = simbolor;
                                return true;
                            }
                        }
                    }
                }
            }
            else {
                for (var _f = 0, _g = this.simbolos; _f < _g.length; _f++) {
                    var simbolito = _g[_f];
                    if (simbolito instanceof simbolo) {
                        if (simbolito.name == name) {
                            if (simbolito.ambito < this.ambitoLevel && simbolito.ambito > 0 && simbolito.rol != 'funcion') {
                                simbolito = simbolor;
                                return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    };
    TablaSimbolos.prototype.getPosition = function (name) {
        for (var _i = 0, _a = this.simbolos; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof simbolo) {
                if (simbolito.name == name) {
                    return simbolito.position;
                }
            }
            else {
                return -1;
            }
        }
        return null;
    };
    TablaSimbolos.prototype.getPositionAmbito = function (name) {
        /*
        let ambitoglob = true;
        let ambitoloc = false;
        for(let simbolito of this.simbolos) {
            if (simbolito instanceof simbolo) {
                if (simbolito.name == name) {

                    if(simbolito.ambito == this.ambitoLevel && this.ambitoLevel>0 && simbolito.ambito >0)
                    {
                        ambitoglob = false;
                        ambitoloc = true;
                    }
                    else if(simbolito.ambito < this.ambitoLevel && this.ambitoLevel>0 && simbolito.ambito >0)
                    {
                        ambitoglob = false;
                    }
                }
            }
        }
        */
        var ambitoglob = true;
        var ambitoloc = false;
        for (var _i = 0, _a = this.simbolos; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof simbolo) {
                if (simbolito.name == name) {
                    if (simbolito.ambito == this.ambitoLevel && this.ambitoLevel > 0 && simbolito.ambito > 0) {
                        ambitoglob = false;
                        ambitoloc = true;
                    }
                    else if (simbolito.ambito < this.ambitoLevel && this.ambitoLevel > 0 && simbolito.ambito > 0) {
                        ambitoglob = false;
                    }
                }
            }
        }
        //if(name == 'k') console.log(this.ambitoLevel)
        if (ambitoglob) {
            for (var _b = 0, _c = this.simbolos; _b < _c.length; _b++) {
                var simbolito = _c[_b];
                if (simbolito instanceof simbolo) {
                    if (simbolito.name == name && simbolito.rol != 'funcion') {
                        return simbolito;
                    }
                }
            }
        }
        else {
            if (ambitoloc) {
                for (var _d = 0, _e = this.simbolos; _d < _e.length; _d++) {
                    var simbolito = _e[_d];
                    if (simbolito instanceof simbolo) {
                        if (simbolito.name == name && simbolito.ambito == this.ambitoLevel && simbolito.rol != 'funcion') {
                            return simbolito;
                        }
                    }
                }
            }
            else {
                for (var _f = 0, _g = this.simbolos; _f < _g.length; _f++) {
                    var simbolito = _g[_f];
                    if (simbolito instanceof simbolo) {
                        if (simbolito.name == name && simbolito.ambito < this.ambitoLevel && simbolito.ambito > 0 && simbolito.rol != 'funcion') {
                            return simbolito;
                        }
                    }
                }
            }
        }
        return null;
    };
    TablaSimbolos.prototype.getSimbolo = function (name) {
        for (var _i = 0, _a = this.simbolos; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof simbolo) {
                if (simbolito.name == name) {
                    return simbolito;
                }
            }
            else {
                return null;
            }
        }
    };
    TablaSimbolos.prototype.getFunctions = function () {
        var vals = [];
        for (var _i = 0, _a = this.simbolos; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof simbolo) {
                if (simbolito.rol == 'funcion')
                    vals.push(simbolito.name);
            }
        }
        return vals;
    };
    TablaSimbolos.prototype.getFunction = function (name) {
    };
    return TablaSimbolos;
}());
exports.TablaSimbolos = TablaSimbolos;
var simbolo = /** @class */ (function () {
    function simbolo() {
        this.ambito = -1;
        this.name = "";
        this.position = -1;
        this.rol = "";
        this.direccion = -1;
        this.direccionrelativa = -1;
        this.tipo = '';
        this.constante = false;
        this.entorno = '';
        this.params = -1;
    }
    return simbolo;
}());
exports.simbolo = simbolo;
var temporal = /** @class */ (function () {
    function temporal() {
        this.temporales = [];
    }
    temporal.prototype.getTemporalAnt = function () {
        return this.temporales[this.temporales.length - 1];
    };
    temporal.prototype.getTemporal = function () {
        this.temporales.push('t' + (this.temporales.length + 1));
        return this.temporales[(this.temporales.length - 1)];
    };
    return temporal;
}());
exports.temporal = temporal;
var bandera = /** @class */ (function () {
    function bandera() {
        this.banderas = [];
    }
    bandera.prototype.getBanderaAnt = function () {
        return this.banderas[this.banderas.length - 1];
    };
    bandera.prototype.getBandera = function () {
        this.banderas.push('L' + (this.banderas.length + 1));
        return this.banderas[this.banderas.length - 1];
    };
    return bandera;
}());
exports.bandera = bandera;
var Arreglos = /** @class */ (function () {
    function Arreglos() {
        this.valores = [];
    }
    Arreglos.prototype.insert = function (val) {
        this.valores.push(val);
    };
    Arreglos.prototype.update = function (id, val) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    val.name = simbolito.name;
                    simbolito = val;
                }
            }
        }
    };
    Arreglos.prototype.get = function (id) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    return simbolito;
                }
            }
        }
    };
    Arreglos.prototype.getProf = function (id) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    var vals = simbolito.valor;
                    if (vals[0] instanceof arreglo) {
                        if (vals[0].valor instanceof Array) {
                            if (vals[0].valor[0] instanceof arreglo) {
                                return 1 + this.getProf1(vals[0].valor[0]);
                            }
                            else {
                                return 1;
                            }
                        }
                        else {
                            return 1;
                        }
                    }
                    else {
                        return 1;
                    }
                }
            }
        }
        return -1;
    };
    Arreglos.prototype.getProf1 = function (vals1) {
        if (vals1 instanceof arreglo) {
            var vals = vals1.valor;
            if (vals[0] instanceof arreglo) {
                if (vals[0].valor instanceof Array) {
                    if (vals[0].valor[0] instanceof arreglo) {
                        return 1 + this.getProf1(vals[0].valor[0]);
                    }
                    else {
                        return 1;
                    }
                }
                else {
                    return 1;
                }
            }
            else {
                return 1;
            }
        }
        else {
            return 1;
        }
    };
    Arreglos.prototype.getTampos = function (id, level, pos) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    var vals = simbolito.valor;
                    if (vals instanceof Array) {
                        if (vals.length >= pos) {
                            var count = 1;
                            if (level == count)
                                return this.getsize(simbolito.valor, pos);
                            return this.getTampos1(simbolito.valor[0], level, count + 1, pos);
                        }
                    }
                }
            }
        }
        return -1;
    };
    Arreglos.prototype.getTamposd = function (id) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    var vals = simbolito.valor;
                    return vals.length;
                }
            }
        }
        return -1;
    };
    Arreglos.prototype.getsize = function (vals1, pos) {
        if (vals1 instanceof Array) {
            if (vals1.length >= pos) {
                if (vals1[pos] instanceof arreglo) {
                    if (vals1[pos].valor instanceof Array) {
                        return vals1[pos].valor;
                    }
                    else {
                        return vals1[pos];
                    }
                }
            }
        }
        return -1;
    };
    Arreglos.prototype.getsize1 = function (vals1, pos) {
        if (vals1[0] instanceof arreglo) {
            if (vals1[0].valor.length >= pos) {
                if (vals1[0].valor[pos] instanceof arreglo) {
                    if (vals1[0].valor[pos].valor instanceof Array) {
                        return vals1[0].valor[pos].valor;
                    }
                    else {
                        return vals1[0].valor[pos];
                    }
                }
            }
        }
        return -1;
    };
    Arreglos.prototype.getTampos1 = function (vals1, level, count, pos) {
        if (vals1 instanceof arreglo) {
            var vals = vals1.valor;
            if (vals[0] instanceof arreglo) {
                if (vals[0].valor instanceof Array) {
                    if (level == count)
                        return this.getsize(vals[0].valor, pos);
                    return this.getTampos1(vals[0].valor, level, count + 1, pos);
                }
            }
        }
        return -1;
    };
    Arreglos.prototype.getTam = function (id, level) {
        var count = 1;
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    var vals = simbolito.valor;
                    if (id == 'e')
                        console.log(vals);
                    if (vals instanceof Array) {
                        if (level == count)
                            return simbolito.valor.length;
                        return this.getTam1(simbolito.valor[0], level, count + 1);
                    }
                    else {
                        return simbolito.valor.length;
                    }
                }
            }
        }
        return -1;
    };
    Arreglos.prototype.getTam1 = function (vals1, level, count) {
        if (vals1 instanceof arreglo) {
            var vals = vals1.valor;
            if (vals[0] instanceof arreglo) {
                if (vals[0].valor instanceof Array) {
                    if (level == count)
                        return vals[0].valor.length;
                    return this.getTam1(vals[0].valor, level, count + 1);
                }
                else {
                    return vals1.valor.length;
                }
            }
            else {
                return vals1.valor.length;
            }
        }
        else {
            if (vals1[0] instanceof arreglo) {
                if (vals1[0].valor instanceof Array) {
                    if (level == count) {
                        if (vals1[0].valor instanceof Array) {
                            var va = vals1[0].valor[0];
                            if (va instanceof arreglo) {
                                return va.positions[0];
                            }
                        }
                    }
                }
            }
        }
        return -1;
    };
    Arreglos.prototype.getValores = function (id) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    return simbolito.getValores();
                }
            }
            else {
                return null;
            }
        }
    };
    Arreglos.prototype.getValoresL = function (id) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    return simbolito.getValoresL();
                }
            }
            else {
                return null;
            }
        }
    };
    Arreglos.prototype.changeValue = function (id, data, pos) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    simbolito.changeData(data, pos);
                    //console.log(simbolito.getValores());
                }
            }
        }
    };
    Arreglos.prototype.getValue = function (id, pos) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    return simbolito.getData(pos);
                    //console.log(simbolito.getValores());
                }
            }
        }
    };
    return Arreglos;
}());
exports.Arreglos = Arreglos;
var arreglo = /** @class */ (function () {
    function arreglo() {
        this.positions = [];
        this.valor = [];
        this.name = '';
        this.c3d = '';
    }
    arreglo.prototype.getValoresL = function () {
        var value = [];
        //console.log(this.valor);
        for (var _i = 0, _a = this.valor; _i < _a.length; _i++) {
            var pos = _a[_i];
            if (pos instanceof Array) {
                var aux = this.getValoresL1(pos);
                value.push(aux);
            }
            else if (pos instanceof arreglo) {
                var aux = pos.getValoresL();
                value.push(aux);
            }
            else {
                value.push(pos);
            }
        }
        return value;
    };
    arreglo.prototype.getValoresL1 = function (val) {
        var value = [];
        for (var _i = 0, val_1 = val; _i < val_1.length; _i++) {
            var pos = val_1[_i];
            if (pos instanceof Array) {
                var aux = this.getValoresL1(pos);
                value.push(aux);
            }
            else if (pos instanceof arreglo) {
                var aux = pos.getValoresL();
                value.push(aux);
            }
            else {
                value.push(pos);
            }
        }
        return value;
    };
    arreglo.prototype.getValores = function () {
        var value = [];
        //console.log(this.valor);
        for (var _i = 0, _a = this.valor; _i < _a.length; _i++) {
            var pos = _a[_i];
            if (pos instanceof Array) {
                var aux = this.getValores1(pos);
                for (var _b = 0, aux_1 = aux; _b < aux_1.length; _b++) {
                    var posaux = aux_1[_b];
                    value.push(posaux);
                }
            }
            else if (pos instanceof arreglo) {
                var aux = pos.getValores();
                for (var _c = 0, aux_2 = aux; _c < aux_2.length; _c++) {
                    var posaux = aux_2[_c];
                    value.push(posaux);
                }
            }
            else {
                value.push(pos);
            }
        }
        return value;
    };
    arreglo.prototype.getValores1 = function (val) {
        var value = [];
        for (var _i = 0, val_2 = val; _i < val_2.length; _i++) {
            var pos = val_2[_i];
            if (pos instanceof Array) {
                var aux = this.getValores1(pos);
                for (var _a = 0, aux_3 = aux; _a < aux_3.length; _a++) {
                    var posaux = aux_3[_a];
                    value.push(posaux);
                }
            }
            else if (pos instanceof arreglo) {
                var aux = pos.getValores();
                for (var _b = 0, aux_4 = aux; _b < aux_4.length; _b++) {
                    var posaux = aux_4[_b];
                    value.push(posaux);
                }
            }
            else {
                value.push(pos);
            }
        }
        return value;
    };
    arreglo.prototype.changeData = function (data, pos) {
        var posd = 0;
        var posi = pos[posd];
        posd++;
        if (pos.length > posd) {
            //console.log(this.valor[posi])
            if (this.valor[posi] instanceof arreglo) {
                this.valor[posi].valor[0].valor = this.changeData1(this.valor[posi].valor[0].valor, data, pos, posd);
            }
        }
        else {
            //console.log(this.valor[posi]);
            if (this.valor[posi] instanceof arreglo) {
                this.valor[posi].valor[0] = data;
            }
        }
        return this.valor;
    };
    arreglo.prototype.changeData1 = function (arr, data, pos, posd) {
        var posi = pos[posd];
        posd++;
        //console.log('l', posi, pos);
        if (pos.length > posd) {
            if (arr[posi] instanceof arreglo) {
                //console.log('l',arr.valor[posi].valor[0])
                //console.log('l1',arr.valor[0].valor[posi])
                //console.log('l2',arr.valor[0].valor[0].valor[posi])
                arr[posi].valor = this.changeData1(arr[posi].valor, data, pos, posd);
                return arr;
            }
        }
        else {
            //console.log(arr[0]);
            if (arr[0] instanceof arreglo) {
                arr[0].valor[posi].valor[0] = data;
                return arr;
            }
        }
        return arr;
    };
    arreglo.prototype.getData = function (pos) {
        var posd = 0;
        var posi = pos[posd];
        posd++;
        if (pos.length > posd) {
            //console.log(this.valor[posi])
            if (this.valor[posi] instanceof arreglo) {
                return this.getData1(this.valor[posi].valor[0].valor, pos, posd);
            }
        }
        else {
            //console.log(this.valor[posi]);
            return this.valor[posi];
        }
        return null;
    };
    arreglo.prototype.getData1 = function (arr, pos, posd) {
        var posi = pos[posd];
        posd++;
        //console.log('l', posi, pos);
        if (pos.length > posd) {
            if (arr[posi] instanceof arreglo) {
                //console.log('l',arr.valor[posi].valor[0])
                //console.log('l1',arr.valor[0].valor[posi])
                //console.log('l2',arr.valor[0].valor[0].valor[posi])
                return this.getData1(arr[posi].valor, pos, posd);
            }
        }
        else {
            return arr[posi];
        }
        return null;
    };
    return arreglo;
}());
exports.arreglo = arreglo;
