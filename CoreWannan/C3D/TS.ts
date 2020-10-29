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
    constructor() {
        this.simbolos = [];
        this.ambitoLevel = 0;
    }
    printSimbolos()
    {
        for(let simbolitos of this.simbolos)
        {
            console.log(`VARIABLE: ${simbolitos.name}   |   TIPO: ${simbolitos.tipo}    |   ROL: ${simbolitos.rol}  |   AMBITO: ${simbolitos.ambito}    |   POSITION: ${simbolitos.position}   |   VALOR: ${simbolitos.valor}   |   CONSTANTE: ${simbolitos.constante}`);
        }
    }
    insert(simbolo:any)
    {
        this.simbolos.push(simbolo);
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

    constructor() {
        this.ambito = -1;
        this.name = "";
        this.position = -1;
        this.rol = "";
        this.direccion = -1;
        this.direccionrelativa = -1;
        this.tipo = '';
        this.constante = false;
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
    getTam(id,level)
    {
        for(let simbolito of this.valores)
        {
            if(simbolito instanceof arreglo)
            {
                if(simbolito.name == name)
                {
                    let count = 1;
                    for(let pos of simbolito.positions)
                    {
                        if(count == level) return pos;
                        count++;
                    }
                    return null;
                }
            }
            else
            {
                return null;
            }
        }
    }
    getValores(id)
    {
        for(let simbolito of this.valores)
        {
            if(simbolito instanceof arreglo)
            {
                if(simbolito.name == name)
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
        for(let pos of this.positions)
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

}
