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

    constructor() {
        this.ambito = -1;
        this.name = "";
        this.position = -1;
        this.rol = "";
        this.direccion = -1;
        this.direccionrelativa = -1;
        this.tipo = '';
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

class intermediate
{
    C3D:string;
    label:string;
    temporal:string;

}
