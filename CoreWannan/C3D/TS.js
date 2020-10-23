"use strict";
exports.__esModule = true;
exports.bandera = exports.temporal = exports.simbolo = exports.TablaSimbolos = exports.s = void 0;
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
var intermediate = /** @class */ (function () {
    function intermediate() {
    }
    return intermediate;
}());
