export enum s {
    S_ASIGNATION,
    S_DECLARATION,
    S_IF,
    S_FOR,
    S_FORIN,
    S_FOROF,
    S_SWITCH,
    S_DOWHILE,
    S_WHILE,
    S_EXPRESSION,
    S_NATIVE,
    S_STRINGNATIVE
}

export class TablaSimbolos
{
    simbolos: any[];
    ambitoLevel: number;
    entornoactual:string;
    constructor() {
        this.entornoactual = '';
        this.simbolos = [];
        this.ambitoLevel = 0;
    }
    printSimbolos()
    {
        for(let simbolitos of this.simbolos)
        {
            console.log(`VARIABLE: ${simbolitos.name}   |   TIPO: ${simbolitos.tipo}    |   ROL: ${simbolitos.rol}  |   AMBITO: ${simbolitos.ambito}    |   POSITION: ${simbolitos.position}   |   VALOR: ${simbolitos.valor}   |   CONSTANTE: ${simbolitos.constante} | ENTORNO: ${simbolitos.entorno}`);
        }
    }
    insert(simbolo:any)
    {
        if(this.ambitoLevel == 0 && simbolo.entorno == '')
        {
            simbolo.entorno = 'global';
        }
        this.simbolos.push(simbolo);
    }
    deleteAmbitoLast()
    {
        let simbols = [];
        for(let a of this.simbolos)
        {
            if(a instanceof simbolo)
            {
                if(a.ambito == 0) simbols.push(a);
            }
        }
        this.simbolos = [];
        for(let b of simbols)
        {
            this.simbolos.push(b);
        }
    }
    update(name:string, simbolor:any):boolean
    {
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

        if(ambitoglob)
        {
            for(let simbolito of this.simbolos)
            {
                if(simbolito instanceof simbolo)
                {
                    if(simbolito.name == name && simbolito.ambito == 0)
                    {
                        simbolito = simbolor;
                        return true;
                    }
                }
            }
        }
        else
        {
            if(ambitoloc)
            {
                for(let simbolito of this.simbolos)
                {
                    if (simbolito instanceof simbolo)
                    {
                        if (simbolito.name == name)
                        {
                            if(simbolito.ambito == this.ambitoLevel)
                            {
                                simbolito = simbolor;
                                return true;
                            }
                        }
                    }
                }
            }
            else
            {
                for(let simbolito of this.simbolos)
                {
                    if (simbolito instanceof simbolo)
                    {
                        if (simbolito.name == name)
                        {
                            if(simbolito.ambito < this.ambitoLevel && simbolito.ambito >0)
                            {
                                simbolito = simbolor;
                                return true;
                            }
                        }
                    }
                }

            }
        }
        return false;
    }
    getPosition(name:string): number
    {
        for(let simbolito of this.simbolos)
        {
            if(simbolito instanceof simbolo)
            {
                if(simbolito.name == name)
                {
                    return simbolito.position;
                }
            }
            else
            {
                return -1;
            }
        }
        return null;
    }
    getPositionAmbito(name:string)
    {
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

        if(ambitoglob)
        {
            for(let simbolito of this.simbolos)
            {
                if(simbolito instanceof simbolo)
                {
                    if(simbolito.name == name && simbolito.ambito == 0)
                    {
                        return simbolito;
                    }
                }
                else
                {
                    return -1;
                }
            }
        }
        else
        {
            if(ambitoloc)
            {
                for(let simbolito of this.simbolos)
                {
                    if (simbolito instanceof simbolo)
                    {
                        if (simbolito.name == name)
                        {
                            if(simbolito.ambito == this.ambitoLevel)
                            {
                                return simbolito;
                            }
                        }
                    }
                }
            }
            else
            {
                for(let simbolito of this.simbolos)
                {
                    if (simbolito instanceof simbolo)
                    {
                        if (simbolito.name == name)
                        {
                            if(simbolito.ambito < this.ambitoLevel && simbolito.ambito >0)
                            {
                                return simbolito
                            }
                        }
                    }
                }

            }
        }

        return null;


    }
    getSimbolo(name:string): any
    {
        for(let simbolito of this.simbolos)
        {
            if(simbolito instanceof simbolo)
            {
                if(simbolito.name == name)
                {
                    return simbolito;
                }
            }
            else
            {
                return null;
            }
        }
    }
}
export class simbolo
{
    ambito:number;
    name:string;
    position:number;
    rol:string;
    direccion:number;
    direccionrelativa:number;
    tipo:string;
    constante:boolean;
    valor:any;
    entorno:string;

    constructor() {
        this.ambito = -1;
        this.name = "";
        this.position = -1;
        this.rol = "";
        this.direccion = -1;
        this.direccionrelativa = -1;
        this.tipo = '';
        this.constante = false;
        this.entorno  = '';
    }


}

export class temporal
{
    temporales: any[];

    constructor() {
        this.temporales = [];
    }

    getTemporalAnt():string
    {
        return this.temporales[this.temporales.length-1]
    }
    getTemporal():string
    {
        this.temporales.push('t'+(this.temporales.length+1));
        return this.temporales[(this.temporales.length-1)];
    }
}
export class bandera
{
    banderas: any[];

    constructor() {
        this.banderas = [];
    }

    getBanderaAnt():string
    {
        return this.banderas[this.banderas.length-1]
    }

    getBandera():string
    {
        this.banderas.push('L'+(this.banderas.length+1));
        return this.banderas[this.banderas.length-1]
    }
}

export class Arreglos
{
    valores: any [];

    constructor() {
        this.valores = [];
    }
    insert(val)
    {
        this.valores.push(val);
    }
    update(id,val)
    {
        for(let simbolito of this.valores) {
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    val.name = simbolito.name;
                    simbolito = val;
                }
            }
        }
    }
    get(id)
    {
        for(let simbolito of this.valores) {
            if (simbolito instanceof arreglo) {
                if (simbolito.name == id) {
                    return simbolito;
                }
            }
        }
    }

    getProf(id) : number
    {
        for(let simbolito of this.valores)
        {
            if(simbolito instanceof arreglo)
            {

                if(simbolito.name == id)
                {
                    let vals = simbolito.valor
                    if(vals[0] instanceof arreglo)
                    {
                        if(vals[0].valor instanceof Array)
                        {
                            if(vals[0].valor[0] instanceof arreglo)
                            {
                                return 1 + this.getProf1(vals[0].valor[0]);
                            }
                            else
                            {
                                return 1;
                            }
                        }
                        else
                        {
                            return 1;
                        }
                    }
                    else
                    {
                        return 1;
                    }

                }
            }
        }
        return -1;
    }
    getProf1(vals1): number
    {
        if(vals1 instanceof arreglo)
        {
            let vals = vals1.valor
            if(vals[0] instanceof arreglo)
            {
                if(vals[0].valor instanceof Array)
                {
                    if(vals[0].valor[0] instanceof arreglo)
                    {
                        return 1 + this.getProf1(vals[0].valor[0]);
                    }
                    else
                    {
                        return 1;
                    }
                }
                else
                {
                    return 1;
                }
            }
            else
            {
                return 1;
            }
        }
        else
        {
            return 1;
        }
    }

    getTampos(id,level, pos) : number
    {
        for(let simbolito of this.valores)
        {
            if(simbolito instanceof arreglo)
            {
                if(simbolito.name == id)
                {
                    let vals = simbolito.valor
                    if(vals instanceof Array)
                    {
                        if(vals.length >= pos)
                        {
                            let count = 1;
                            if(level==count) return this.getsize(simbolito.valor, pos);
                            return this.getTampos1(simbolito.valor[0], level, count+1, pos)
                        }
                    }

                }
            }
        }
        return -1;
    }
    getTamposd(id) : number
    {
        for(let simbolito of this.valores)
        {
            if(simbolito instanceof arreglo)
            {
                if(simbolito.name == id)
                {
                    let vals = simbolito.valor
                    return vals.length;
                }
            }
        }
        return -1;
    }
    getsize(vals1, pos)
    {
        if(vals1 instanceof Array)
        {
            if(vals1.length >= pos)
            {
                if(vals1[pos] instanceof arreglo)
                {
                    if(vals1[pos].valor instanceof Array)
                    {
                        return vals1[pos].valor;
                    }
                    else
                    {
                        return vals1[pos];
                    }
                }
            }
        }
        return -1;

    }
    getsize1(vals1, pos)
    {
        if(vals1[0] instanceof arreglo)
        {
            if(vals1[0].valor.length >= pos)
            {
                if(vals1[0].valor[pos] instanceof arreglo)
                {
                    if(vals1[0].valor[pos].valor instanceof Array)
                    {
                        return vals1[0].valor[pos].valor;
                    }
                    else
                    {
                        return vals1[0].valor[pos];
                    }
                }
            }
        }
        return -1;

    }

    getTampos1(vals1, level, count, pos): number
    {

        if(vals1 instanceof arreglo)
        {
            let vals = vals1.valor

            if(vals[0] instanceof arreglo)
            {
                if(vals[0].valor instanceof Array)
                {
                    if(level==count) return this.getsize(vals[0].valor,pos);
                    return this.getTampos1(vals[0].valor, level, count+1, pos)
                }
            }
        }
        return -1;
    }

    getTam(id,level) : number
    {
        let count = 1;
        for(let simbolito of this.valores)
        {
            if(simbolito instanceof arreglo)
            {
                if(simbolito.name == id)
                {
                    let vals = simbolito.valor
                    if(id=='e') console.log(vals);
                    if(vals instanceof Array)
                    {

                        if(level==count) return simbolito.valor.length;
                        return this.getTam1(simbolito.valor[0], level, count+1)
                    }
                    else
                    {
                        return simbolito.valor.length;
                    }
                }
            }
        }
        return -1;
    }

    getTam1(vals1, level, count): number
    {
        if(vals1 instanceof arreglo)
        {
            let vals = vals1.valor

            if(vals[0] instanceof arreglo)
            {
                if(vals[0].valor instanceof Array)
                {
                    if(level==count) return vals[0].valor.length;
                    return this.getTam1(vals[0].valor, level, count+1)
                }
                else
                {
                    return vals1.valor.length;
                }
            }
            else
            {
                return vals1.valor.length;
            }
        }
        else
        {
            if(vals1[0] instanceof arreglo)
            {
                if(vals1[0].valor instanceof Array)
                {
                    if(level==count)
                    {
                        if(vals1[0].valor instanceof Array)
                        {
                            let va = vals1[0].valor[0];
                            if(va instanceof arreglo)
                            {
                                return va.positions[0];
                            }
                        }
                    }
                }
            }
        }
        return -1;
    }
    getValores(id)
    {
        for(let simbolito of this.valores)
        {
            if(simbolito instanceof arreglo)
            {
                if(simbolito.name == id)
                {
                    return simbolito.getValores();
                }
            }
            else
            {
                return null;
            }
        }
    }
    changeValue(id,data, pos)
    {
        for(let simbolito of this.valores)
        {
            if(simbolito instanceof arreglo)
            {
                if(simbolito.name == id)
                {
                    simbolito.changeData(data, pos);
                    //console.log(simbolito.getValores());
                }
            }
        }
    }
}


export class arreglo
{
    positions:any [];
    valor:any [];
    name:string;
    tipo:string;
    c3d:string;
    temporal:string;
    bandera:string;

    constructor() {
        this.positions = [];
        this.valor = [];
        this.name = '';
        this.c3d = '';
    }


    getValores(): any[]
    {
        let value = [];
        //console.log(this.valor);
        for(let pos of this.valor)
        {
            if(pos instanceof Array)
            {
                let aux = this.getValores1(pos);
                for(let posaux of aux)
                {
                    value.push(posaux);
                }
            }
            else if(pos instanceof arreglo)
            {
                let aux = pos.getValores();
                for(let posaux of aux)
                {
                    value.push(posaux);
                }
            }
            else
            {
                value.push(pos);
            }
        }
        return value;
    }
    getValores1(val):any[]
    {
        let value = []
        for(let pos of val)
        {
            if(pos instanceof Array)
            {
                let aux = this.getValores1(pos);
                for(let posaux of aux)
                {
                    value.push(posaux);
                }
            }
            else if(pos instanceof arreglo)
            {
                let aux = pos.getValores();
                for(let posaux of aux)
                {
                    value.push(posaux);
                }
            }
            else
            {
                value.push(pos);
            }
        }
        return value;
    }
    changeData(data,pos)
    {
        let posd = 0
        let posi = pos[posd];
        posd++;

        if(pos.length>posd)
        {
            //console.log(this.valor[posi])
            if(this.valor[posi] instanceof arreglo)
            {
                this.valor[posi].valor[0].valor = this.changeData1(this.valor[posi].valor[0].valor,data,pos, posd);
            }
        }
        else
        {
            //console.log(this.valor[posi]);
            if(this.valor[posi] instanceof arreglo)
            {
                this.valor[posi].valor[0] = data;
            }
        }
        return this.valor;
    }
    changeData1(arr, data, pos, posd)
    {
        let posi = pos[posd];
        posd++;
        //console.log('l', posi, pos);
        if(pos.length>posd)
        {
            if(arr[posi] instanceof arreglo)
            {
                //console.log('l',arr.valor[posi].valor[0])
                //console.log('l1',arr.valor[0].valor[posi])
                //console.log('l2',arr.valor[0].valor[0].valor[posi])
                arr[posi].valor = this.changeData1(arr[posi].valor,data,pos,posd);
                return arr;
            }
        }
        else
        {
            //console.log(arr[0]);
            if(arr[0] instanceof arreglo)
            {
                arr[0].valor[posi].valor[0] = data;
                return arr;
            }
        }
        return arr;
    }

}
