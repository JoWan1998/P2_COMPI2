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
        this.simbolos = [];
        this.ambitoLevel = 0;
    }
    TablaSimbolos.prototype.printSimbolos = function () {
        for (var _i = 0, _a = this.simbolos; _i < _a.length; _i++) {
            var simbolitos = _a[_i];
            console.log("VARIABLE: " + simbolitos.name + "   |   TIPO: " + simbolitos.tipo + "    |   ROL: " + simbolitos.rol + "  |   AMBITO: " + simbolitos.ambito + "    |   POSITION: " + simbolitos.position + "   |   VALOR: " + simbolitos.valor + "   |   CONSTANTE: " + simbolitos.constante);
        }
    };
    TablaSimbolos.prototype.insert = function (simbolo) {
        this.simbolos.push(simbolo);
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
                    if (simbolito.name == name && simbolito.ambito == 0) {
                        return simbolito;
                    }
                }
                else {
                    return -1;
                }
            }
        }
        else {
            if (ambitoloc) {
                for (var _d = 0, _e = this.simbolos; _d < _e.length; _d++) {
                    var simbolito = _e[_d];
                    if (simbolito instanceof simbolo) {
                        if (simbolito.name == name) {
                            if (simbolito.ambito == this.ambitoLevel) {
                                return simbolito;
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
                            if (simbolito.ambito < this.ambitoLevel && simbolito.ambito > 0) {
                                return simbolito;
                            }
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
    Arreglos.prototype.getTam = function (id, level) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == name) {
                    var count = 1;
                    for (var _b = 0, _c = simbolito.positions; _b < _c.length; _b++) {
                        var pos = _c[_b];
                        if (count == level)
                            return pos;
                        count++;
                    }
                    return null;
                }
            }
            else {
                return null;
            }
        }
    };
    Arreglos.prototype.getValores = function (id) {
        for (var _i = 0, _a = this.valores; _i < _a.length; _i++) {
            var simbolito = _a[_i];
            if (simbolito instanceof arreglo) {
                if (simbolito.name == name) {
                    return simbolito.getValores();
                }
            }
            else {
                return null;
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
    arreglo.prototype.getValores = function () {
        var value = [];
        for (var _i = 0, _a = this.positions; _i < _a.length; _i++) {
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
        for (var _i = 0, val_1 = val; _i < val_1.length; _i++) {
            var pos = val_1[_i];
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
    return arreglo;
}());
exports.arreglo = arreglo;
