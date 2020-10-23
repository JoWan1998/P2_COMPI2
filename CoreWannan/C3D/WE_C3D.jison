//  UNIVERSIDAD DE SAN CARLOS DE GUATEMALA
//  JOSE ORLANDO WANNAN ESCOBAR - 2020
//  GRAMATICA RECURSIVIDAD POR LA IZQUIERDA
//  tam heap -> 42.90.000000, tam stack -> 4290000000

%{
    var lexicos = [];
    var sintacticos = [];
    var semanticos = [];
    var ast = [];
    var intermedia = require('./TS.js');
    var tab = new intermedia.TablaSimbolos();
    var Temp = new intermedia.temporal();
    var Label = new intermedia.bandera();
    var pos = 0;
    var C3D = '';
    var posS = 5000000;
    var posA = 500000000;
%}
// ANALISIS LEXICO
%lex
%options case-sensitive
%%

"//".*                          /* ignore comment*/
"/*"[^"*/"]* "*/"               /* ignore c-style comment*/
\s+                             /* skip whitespace */
\\r                              /* skip retorno de carro */
\\n                              /* skip salto linea */
\\t                              /* skip tabulacion */

"null"                          return 'NULLTOKEN'
"true"                          return 'TRUETOKEN'
"false"                         return 'FALSETOKEN'

"const"                         return 'CONST'
"let"                           return 'LET'
"var"                           return 'VAR'
"number"                        return 'NUMBERS'
"boolean"                       return 'BOOLEAN'
"string"                        return 'STRING'
"void"                          return 'VOID'
"type"                          return 'TYPE'
"Array"                         return 'ARRAYS'
"new"                           return 'NEWT'

'console'                       return 'CONSOLE'
'log'                           return 'LOG'

"break"                         return 'BREAK'
"continue"                      return 'CONTINUE'
"default"                       return 'DEFAULT'
"case"                          return 'CASE'
"switch"                        return 'SWITCH'
"function"                      return 'FUNCTION'
"if"                            return 'IF'
"Do"                            return 'DO'
"While"                         return 'WHILE'
"else"                          return 'ELSE'
"for"                           return 'FOR'
"of"                            return 'OFTOKEN'
"in"                            return 'INTOKEN'
"return"                        return 'RETURN'

"Length"                        return 'LENGTH'
"CharAt"                        return 'CHARAT'
"ToLowerCase"                   return 'TOLOWER'
"ToUpperCase"                   return 'TOUPPER'
"Concat"                        return 'CONCAT'

"+="                            return '+='
"-="                            return '-='
"/="                            return '/='
"*="                            return '*='
"^="                            return '^='
"%="                            return '%='

"=="                            return 'EQQ'
"!="                            return 'NOEQQ'
">="                            return 'MAQ'
"<="                            return 'MIQ'
">"                             return '>'
"<"                             return '<'

"||"                            return 'OR'
"&&"                            return 'AND'
"!"                             return '!'

"++"                            return 'PLUSPLUS'
"--"                            return 'MINSMINS'
"**"                             return 'POTENCIA'

"+"                             return '+'
"-"                             return '-'
"*"                             return '*'
"/"                             return '/'
"%"                             return '%'

[a-zA-Z_\$][a-zA-Z0-9_\$]*      return 'IDENT'
[0-9]+("."[0-9]+)?\b            return 'NUMBER';
\"[^\"]*\"				        { yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
\'[^\']*\'                      { yytext = yytext.substr(1,yyleng-2); return 'CADENA2'; }


'='                             return '='
';'                             return ';'
':'                             return ':'
','                             return ','
'.'                             return '.'
'('                             return '('
')'                             return ')'
'['                             return '['
']'                             return ']'
'{'                             return 'OPENBRACE'
'}'                             return 'CLOSEBRACE'
'?'                             return '?'

<<EOF>>                         return 'EOF';
.                               {
                                   console.error('Error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column+';');
                                   lexicos.push('{\"token\":\"' + yytext + '\", \"linea\": \"' + yylloc.first_line + '\", \"columna\": \"' + yylloc.first_column+'\"}');
                                }

/lex

// OPERATORS PRECEDENCE

%left '+' '-'
%left '*' '/'
%left POTENCIA
%left UMINUS


%nonassoc IF_WITHOUT_ELSE
%nonassoc ELSE

%start S

%%

// ANALISIS SINTACTICO

S
    : Source1
    {
        console.log('----- CODIGO ------')
        console.log(C3D);
        console.log('----- ERRORES LEXICOS ------');
        for(let m of lexicos)
        {
            console.log(m);
        }
        console.log('----- ERRORES SINTACTICOS ------');
        for(let m of sintacticos)
        {
            console.log(m);
        }
        console.log('----- ERRORES SEMANTICOS ------');
        for(let m of semanticos)
        {
            console.log(m);
        }
    }
    | EOF
;


Source1
    :  Statement
    {
        if($1 instanceof Array)
        {
            C3D = $1[3] + C3D;
        }
    }
    |  Statement Source1
    {
        if($1 instanceof Array)
        {
            C3D = $1[3] + C3D;
        }

    }
    |  EOF

;


Statement
    : Declaration_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | Assignation_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | Function_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | Native_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | Block_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | If_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | Iteration_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | Return_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | Break_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | Continue_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | Switch_statements
    {
        var r = [];
        r[0]  = $1[0];
        r[1] = $1[1];
        r[2] = $1[2];
        r[3] = $1[3];
        $$ = r;
    }
    | Empty_statements
    | error
;

Native_statements
    : CONSOLE '.' LOG '(' Expr ')' ';'
    {
        //0 -> tipo
        //1 -> temporal
        //2 -> label
        //3 -> C3D
        //4 -> nameVariable (if exists)


        var r = [];
        if($5[0] == "STRING")
        {

        }
        else if($5[0] == "NUMBER")
        {
            var valor = $5[3];
            valor += '\n';
            valor += 'printf("%d",'+$5[1]+');';
            r[3] = valor;
        }
        else if($5[0] == "FLOAT")
        {
            var valor = $5[3];
            valor += '\n';
            valor += 'printf("%f",'+$5[1]+');';
            r[3] = valor;
        }
        else if($5[0] == "BOOLEAN")
        {
            //convert ASCII
            var valor = $5[3];
            valor += '\n';
            valor += 'printf("%f",'+$5[1]+');';
            r[3] = valor;
        }
        else
        {
            if($5[4] != '')
            {
                var n = tab.getPositionAmbito($5[4]);
                if(n!=null && n!=undefined)
                {
                    if(n.rol.toUpperCase() == "ARREGLO")
                    {

                    }
                    else if(n.rol.toUpperCase() == "VARIABLE")
                    {
                        if(n.tipo.toUpperCase() == "NUMBER")
                        {
                            var valor = '';
                            valor += '\n';
                            var temp = Temp.getTemporal();
                            valor = temp+' = stack['+n.position+'];';
                            valor += '\n';
                            valor += 'printf("%d",'+temp+');';
                            r[3] = valor;
                        }
                        else if(n.tipo.toUpperCase() == "FLOAT")
                        {
                            var valor = '';
                            valor += '\n';
                            var temp = Temp.getTemporal();
                            valor = temp+' = stack['+n.position+'];';
                            valor += '\n';
                            valor += 'printf("%f",'+temp+');';
                            r[3] = valor;
                        }
                        else if(n.tipo.toUpperCase() == "STRING")
                        {
                            var valor = '';
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor = temp + ' = stack['+n.position+'];';

                            var temp1 = Temp.getTemporal();
                            valor += '\n';
                            valor += temp1 + '= stack['+temp+'];';
                            valor += temp1 + ' = '+ temp1 + ' + 1;';

                            var temp2  = Temp.getTemporal();
                            valor += '\n';
                            valor += temp2 + '= stack['+temp1+'];';

                            var temp3 = Temp.getTemporal();
                            valor += '\n';
                            valor += temp3 + ' = 1;';

                            var label = Label.getBandera();
                            valor += '\n';
                            valor += label + ':';
                            var label1 = Label.getBandera();

                            valor += '\n';
                            valor += 'if(' + temp3 + '==' + temp2 + ') goto '+label1+';';
                            valor += '\n';

                            var temp4 = Temp.getTemporal();
                            valor += temp4 + ' = ' + temp3 + ' + ' + temp2 + ';';
                            valor += '\n';
                            valor += temp3 + ' = ' + temp3 + ' + 1;';
                            valor += '\n';

                            var temp5 = Temp.getTemporal();
                            valor += temp5 + ' = stack[' + temp4 + '];';
                            valor += '\n';
                            valor += 'printf("%c",' + temp5 + ');';
                            valor += '\n';
                            valor += 'goto ' + label + ';';
                            valor += '\n';
                            valor += label1 + ':';
                            valor += '\n';
                            r[3] = valor;
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error Semantico en la linea: ${(yylineno+1)}, no existe la variable ${$5[4]}`+'\"}');
                    r[3] = '';
                }
            }
        }
        $$ = r;
    }
    | CONSOLE '.' LOG '(' Expr ')'
;

Expr_statements
    : ExprNB ';'
    | ExprNB
;

Empty_statements
    : ';'
;

Block_statements
    : OPENBRACE CLOSEBRACE
    | OPENBRACE Source2 CLOSEBRACE
;

Assignation_statements
    : IDENT initialNo ';'
    | IDENT initialNo
    | Expr1_statements
;
CallExprNoIn
    : CallExprNoIn Arguments
    | CallExprNoIn ArrList
    | CallExprNoIn '.' IDENT
    | '.' IDENT
    | ArrList
;

Expr1_statement
    : Expr1_statement ArrList
    | Expr1_statement '.' IDENT
    | '.' IDENT
    | ArrList
;



ArrList
    : Arr ArrList
    | Arr
;

Arr
    : '[' Expr ']'
;

Declaration_statements
    : TypeV IDENT ':' Type
    {
        if(tab.getPositionAmbito($2)==null)
        {
            if($1.toUpperCase() == 'CONST')
            {
                semanticos.push('{\"valor\":\"'+`Error Semantico en la linea: ${(yylineno+1)}, necesita asignar un valor a una variable de tipo CONST`+'\"}');
                $$ = ['','','',''];
            }
            else
            {
                var temp1 = Temp.getTemporal();

                var valor = '';
                valor += '\n';
                valor += temp1 + ' = ' + pos +';';
                valor += '\n';
                var temp2 = Temp.getTemporal();
                if($1.toUpperCase() == 'NUMBER')
                {
                    valor += temp2 + ' = 0;';
                }
                else if($1.toUpperCase() == 'BOOLEAN')
                {
                    valor += temp2 + ' = 0;';
                }
                else
                {
                    valor += temp2 + ' = -1;';
                }

                valor += '\n';
                valor += 'stack[' + temp1 + '] = ' + temp2 +';';

                var r = [];
                r[3] = valor;
                r[0] = '';
                r[1] = temp2;
                r[2] = '';
                r[4] = '';
                r[5] = '';
                r[6] = '';
                r[7] = '';

                var sym = new intermedia.simbolo();
                sym.ambito = tab.ambitoLevel;
                sym.name = $2;
                sym.position = pos;
                sym.rol = 'variable';
                sym.direccion = pos;
                sym.direccionrelativa = pos;
                sym.tipo = $4;
                tab.insert(sym);
                $$ = r;
                if(pos >0 && pos != 0) pos++;
                if (pos == 0) pos++;
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, ya existe una variable con el nombre ${$2};`+'\"}');
            $$ = ['','','',''];
        }
    }
    | TypeV IDENT
    {
        if(tab.getPositionAmbito($2)==null)
        {
            if($1.toUpperCase() == 'CONST')
            {
                semanticos.push('{\"valor\":\"'+`Error Semantico en la linea: ${(yylineno+1)}, necesita asignar un valor a una variable de tipo CONST`+'\"}');
                $$ = ['','','',''];
            }
            else
            {
                var temp1 = Temp.getTemporal();

                var valor = '';
                valor += '\n';
                valor += temp1 + ' = ' + pos +';';
                valor += '\n';
                var temp2 = Temp.getTemporal();
                if($1.toUpperCase() == 'NUMBER')
                {
                    valor += temp2 + ' = 0;';
                }
                else if($1.toUpperCase() == 'BOOLEAN')
                {
                    valor += temp2 + ' = 0;';
                }
                else
                {
                    valor += temp2 + ' = -1;';
                }
                valor += '\n';
                valor += 'stack[' + temp1 + '] = ' + temp2 +';';

                var r = [];
                r[3] = valor;
                r[0] = '';
                r[1] = temp2;
                r[2] = '';
                r[4] = '';
                r[5] = '';
                r[6] = '';
                r[7] = '';

                var sym = new intermedia.simbolo();
                sym.ambito = tab.ambitoLevel;
                sym.name = $2;
                sym.position = pos;
                sym.rol = 'variable';
                sym.direccion = pos;
                sym.direccionrelativa = pos;
                sym.tipo = '';
                tab.insert(sym);
                $$ = r;
                if(pos >0 && pos != 0) pos++;
                if (pos == 0) pos++;
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, ya existe una variable con el nombre ${$2};`+'\"}');
            $$ = ['','','',''];
        }
    }
    | TypeV IDENT Array ':' Type '=' NEWT ARRAYS '(' Expr ')'
    {
        if(tab.getPositionAmbito($2)==null)
        {
                var temp1 = Temp.getTemporal();

                var u = $10;
                if(u[0].toUpperCase() == 'NUMBER')
                {
                    var valor = '';
                    valor += u[3];
                    valor += '\n';
                    valor += temp1 + ' = ' + pos +';';
                    valor += '\n';
                    var temp2 = Temp.getTemporal();
                    valor += temp2 + ' = '+posA+';';
                    valor += '\n';
                    valor += 'stack[' + temp1 + '] = ' + temp2 +';';
                    valor += '\n';
                    valor += 'stack[' + temp2 + '] = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor = valor  + temp2 + ' = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor += 'stack[' + temp2 + '] = ' + u[1] + ';';
                    valor += '\n';
                    var temp3 = Temp.getTemporal();
                    valor += temp3 + ' = 0;';
                    valor += '\n';
                    var label = Label.getBandera();
                    var label1 = Label.getBandera();
                    valor += label + ': ';
                    valor += '\n';
                    valor += '\t' + 'if( ' + temp3 + ' == ' + u[1] + ' ) goto ' + label1 + ';';
                    valor += '\n';
                    valor += '\t' + temp2 + ' = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor += '\t' + temp3 + ' = ' + temp3 + ' + 1;';
                    valor += '\n';
                    valor += '\t' + 'stack['+temp2+'] = -1;';
                    valor += '\n';
                    valor += '\t' + 'goto ' + label + ';';
                    valor += '\n';
                    valor += label1 + ': ';

                    var r = [];
                    r[3] = valor;
                    r[0] = '';
                    r[1] = temp3;
                    r[2] = label1;
                    r[4] = '';
                    r[5] = '';
                    r[6] = '';
                    r[7] = '';

                    var sym = new intermedia.simbolo();
                    sym.ambito = tab.ambitoLevel;
                    sym.name = $2;
                    sym.position = pos;
                    sym.rol = 'arreglo';
                    sym.direccion = pos;
                    sym.direccionrelativa = pos;
                    sym.tipo = $1;
                    tab.insert(sym);

                    $$ = r;

                    if(pos >0 && pos != 0) pos++;
                    if (pos == 0) pos++;
                    posA += 50000;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar un tamaño  de tipo ${u[0]};`+'\"}');
                    $$ = ['','','',''];
                }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, ya existe una variable con el nombre ${$2};`+'\"}');
            $$ = ['','','',''];
        }
    }
    | TypeV IDENT  ':' Type Array '=' NEWT ARRAYS '(' Expr ')'
    {
        if(tab.getPositionAmbito($2)==null)
        {
                var temp1 = Temp.getTemporal();

                var u = $10;
                if(u[0].toUpperCase() == 'NUMBER')
                {
                    var valor = '';
                    valor += u[3];
                    valor += '\n';
                    valor += temp1 + ' = ' + pos +';';
                    valor += '\n';
                    var temp2 = Temp.getTemporal();
                    valor += temp2 + ' = '+posA+';';
                    valor += '\n';
                    valor += 'stack[' + temp1 + '] = ' + temp2 +';';
                    valor += '\n';
                    valor += 'stack[' + temp2 + '] = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor = valor  + temp2 + ' = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor += 'stack[' + temp2 + '] = ' + u[1] + ';';
                    valor += '\n';
                    var temp3 = Temp.getTemporal();
                    valor += temp3 + ' = 0;';
                    valor += '\n';
                    var label = Label.getBandera();
                    var label1 = Label.getBandera();
                    valor += label + ': ';
                    valor += '\n';
                    valor += '\t' + 'if( ' + temp3 + ' == ' + u[1] + ' ) goto ' + label1 + ';';
                    valor += '\n';
                    valor += '\t' + temp2 + ' = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor += '\t' + temp3 + ' = ' + temp3 + ' + 1;';
                    valor += '\n';
                    valor += '\t' + 'stack['+temp2+'] = -1;';
                    valor += '\n';
                    valor += '\t' + 'goto ' + label + ';';
                    valor += '\n';
                    valor += label1 + ': ';

                    var r = [];
                    r[3] = valor;
                    r[0] = '';
                    r[1] = temp3;
                    r[2] = label1;
                    r[4] = '';
                    r[5] = '';
                    r[6] = '';
                    r[7] = '';

                    var sym = new intermedia.simbolo();
                    sym.ambito = tab.ambitoLevel;
                    sym.name = $2;
                    sym.position = pos;
                    sym.rol = 'arreglo';
                    sym.direccion = pos;
                    sym.direccionrelativa = pos;
                    sym.tipo = $1;
                    tab.insert(sym);

                    $$ = r;

                    if(pos >0 && pos != 0) pos++;
                    if (pos == 0) pos++;
                    posA += 50000;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar un tamaño  de tipo ${u[0]};`+'\"}');
                    $$ = ['','','',''];
                }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, ya existe una variable con el nombre ${$2};`+'\"}');
            $$ = ['','','',''];
        }
    }
    | TypeV IDENT Array '=' NEWT ARRAYS '(' Expr ')'
    {
        if(tab.getPositionAmbito($2)==null)
        {
                var temp1 = Temp.getTemporal();

                var u = $8;
                if(u[0].toUpperCase() == 'NUMBER')
                {
                    var valor = '';
                    valor += u[3];
                    valor += '\n';
                    valor += temp1 + ' = ' + pos +';';
                    valor += '\n';
                    var temp2 = Temp.getTemporal();
                    valor += temp2 + ' = '+posA+';';
                    valor += '\n';
                    valor += 'stack[' + temp1 + '] = ' + temp2 +';';
                    valor += '\n';
                    valor += 'stack[' + temp2 + '] = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor = valor  + temp2 + ' = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor += 'stack[' + temp2 + '] = ' + u[1] + ';';
                    valor += '\n';
                    var temp3 = Temp.getTemporal();
                    valor += temp3 + ' = 0;';
                    valor += '\n';
                    var label = Label.getBandera();
                    var label1 = Label.getBandera();
                    valor += label + ': ';
                    valor += '\n';
                    valor += '\t' + 'if( ' + temp3 + ' == ' + u[1] + ' ) goto ' + label1 + ';';
                    valor += '\n';
                    valor += '\t' + temp2 + ' = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor += '\t' + temp3 + ' = ' + temp3 + ' + 1;';
                    valor += '\n';
                    valor += '\t' + 'stack['+temp2+'] = -1;';
                    valor += '\n';
                    valor += '\t' + 'goto ' + label + ';';
                    valor += '\n';
                    valor += label1 + ': ';

                    var r = [];
                    r[3] = valor;
                    r[0] = '';
                    r[1] = temp3;
                    r[2] = label1;
                    r[4] = '';
                    r[5] = '';
                    r[6] = '';
                    r[7] = '';

                    var sym = new intermedia.simbolo();
                    sym.ambito = tab.ambitoLevel;
                    sym.name = $2;
                    sym.position = pos;
                    sym.rol = 'arreglo';
                    sym.direccion = pos;
                    sym.direccionrelativa = pos;
                    sym.tipo = $1;
                    tab.insert(sym);

                    $$ = r;

                    if(pos >0 && pos != 0) pos++;
                    if (pos == 0) pos++;
                    posA += 50000;
                }
                else if(u[0] == '')
                {
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar un tamaño  de tipo ${u[0]};`+'\"}');
                    $$ = ['','','',''];
                }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, ya existe una variable con el nombre ${$2};`+'\"}');
            $$ = ['','','',''];
        }
    }
    | TypeV IDENT ':' Type '=' AssignmentExpr
    {
        if(tab.getPositionAmbito($2)==null)
        {
            if($4.toUpperCase() == $6[0].toUpperCase())
            {
                switch($4.toUpperCase())
                {
                    case "STRING":
                        var val = $6[5].toString();
                        var valor = '';
                        var temp = Temp.getTemporal();
                        valor += temp + ' = ' + pos + ';';
                        valor += '\n';

                        var temp1 = Temp.getTemporal();
                        valor += temp1 + ' = ' + posS + ';';
                        valor += '\n';
                        valor += 'stack['+temp+'] = ' + temp1 + ';';
                        valor += '\n';
                        valor += temp1 + ' = ' + temp1 + ' + 1;';
                        valor += '\n';
                        var temp2 = Temp.getTemporal();
                        valor += temp2 + ' = '+ val.length + ';';
                        valor += '\n';
                        valor += 'stack['+temp1+'] = ' + temp2 + ';';
                        valor += '\n';
                        valor += $6[1] + ' = ' + temp1 + ';';
                        //valor += '\n';
                        valor += $6[3];

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp3;
                        r[2] = label1;
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';

                        var sym = new intermedia.simbolo();
                        sym.ambito = tab.ambitoLevel;
                        sym.name = $2;
                        sym.position = pos;
                        sym.rol = 'variable';
                        sym.direccion = pos;
                        sym.direccionrelativa = pos;
                        sym.tipo = $4;
                        tab.insert(sym);

                        $$ = r;

                        if(pos >0 && pos != 0) pos++;
                        if (pos == 0) pos++;
                        posS += 50000;

                        break;
                    case "NUMBER":
                }

            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$6[0]}, a una variable de tipo ${$4};`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, ya existe una variable con el nombre ${$2};`+'\"}');
            $$ = ['','','',''];
        }
    }
    | TypeV IDENT  '=' AssignmentExpr
    | TypeV IDENT Array ':' Type '=' AssignmentExpr
    | TypeV IDENT  ':' Type Array '=' AssignmentExpr
    | TypeV IDENT Array '=' AssignmentExpr
;

ValStatement1
    : TypeV IDENT ':' Type initialNo
    | TypeV IDENT  initialNo
;

initialNo
    : AssignmentOperator AssignmentExpr
;

AssignmentOperator
    : '='
    | '+='
    | '-='
    | '*='
    | '/='
    | '^='
    | '%='
;
Function_statements
    : FUNCTION IDENT '(' ')' OPENBRACE Source2 CLOSEBRACE
    | FUNCTION IDENT '(' ParameterList ')' OPENBRACE Source2 CLOSEBRACE
    | FUNCTION IDENT '(' ')' ':' Type OPENBRACE Source2 CLOSEBRACE
    | FUNCTION IDENT '(' ParameterList ')' ':' Type OPENBRACE Source2 CLOSEBRACE
    | FUNCTION IDENT '(' ')' OPENBRACE  CLOSEBRACE
    | FUNCTION IDENT '(' ParameterList ')' OPENBRACE  CLOSEBRACE
    | FUNCTION IDENT '(' ')' ':' Type OPENBRACE  CLOSEBRACE
    | FUNCTION IDENT '(' ParameterList ')' ':' Type OPENBRACE  CLOSEBRACE
;
FunctionExpr
    : FUNCTION '(' ')' OPENBRACE Source2 CLOSEBRACE
    | FUNCTION '(' ParameterList ')' OPENBRACE Source2 CLOSEBRACE
    | FUNCTION IDENT '(' ')' OPENBRACE Source2 CLOSEBRACE
    | FUNCTION IDENT '(' ParameterList ')' OPENBRACE Source2 CLOSEBRACE
    | FUNCTION '(' ')' OPENBRACE  CLOSEBRACE
    | FUNCTION '(' ParameterList ')' OPENBRACE Source2 CLOSEBRACE
    | FUNCTION IDENT '(' ')' OPENBRACE  CLOSEBRACE
    | FUNCTION IDENT '(' ParameterList ')' OPENBRACE  CLOSEBRACE
;
Source2
    :  Statement1
    |  Statement1 Source2
    |  EOF
;

Statement1
    : Declaration_statements
    | Assignation_statements
    | Native_statements
    | Block_statements
    | If_statements
    | Iteration_statements
    | Return_statements
    | Break_statements
    | Continue_statements
    | Switch_statements
    | Empty_statements
    | error
;

Continue_statements
    : CONTINUE ';'
    | CONTINUE
;

Break_statements
    : BREAK ';'
    | BREAK
;

Return_statements
    : RETURN ';'
    | RETURN
    | RETURN Expr ';'
    | RETURN Expr
;

Switch_statements
    : SWITCH '(' Expr ')' CaseBlock
;

CaseBlock
    : OPENBRACE CaseClausesOpt CLOSEBRACE
;

CaseClausesOpt
    :
    | CaseClauses1
;

CaseClauses
    : CaseClause CaseClauses1
;

CaseClauses1
    : CaseClause CaseClauses1
    | CaseClause
;

CaseClause
    : CASE Expr ':'
    | CASE Expr ':' Source2
    | DEFAULT ':'
    | DEFAULT ':' Source2
;

DefaultClause
    : DEFAULT ':'
    | DEFAULT ':' Source2
;

If_statements
    : IF '(' Expr ')' Statement %prec IF_WITHOUT_ELSE
    | IF '(' Expr ')' Statement ELSE Statement
;
Iteration_statements
    : DO Statement WHILE '(' Expr ')' ';'
    | DO Statement WHILE '(' Expr ')'
    | WHILE '(' Expr ')' Statement
    | FOR '(' ValStatement1 ';' ExprOpt ';' ExprOpt ')' Statement
    | FOR '(' LeftHandSideExpr INTOKEN Expr ')' Statement
    | FOR '(' TypeV IDENT INTOKEN Expr ')' Statement
    | FOR '(' LeftHandSideExpr OFTOKEN Expr ')' Statement
    | FOR '(' TypeV IDENT OFTOKEN Expr ')' Statement
;

ExprOpt
    :Expr
;

ExprNoInOpt
    :ExprNoIn
;

Expr
    : AssignmentExpr
    | Expr ',' AssignmentExpr
;

ExprNoIn
    : AssignmentExprNoIn
    | ExprNoIn ',' AssignmentExprNoIn
;

ExprNB
    : AssignmentExprNoBF
    | ExprNB ',' AssignmentExprNoBF
;

ParameterList
    : Parameter ',' ParameterList
    | Parameter
;

Parameter
    : IDENT ':' Type
    | IDENT
;

TypeV
    : STRING
    | NUMBERS
    | BOOLEAN
    | VOID
    | VAR
    | CONST
    | TYPE
    | IDENT
    | LET
;

Type
    : TypeV ArrayList
    | TypeV
;

ArrayList
    : Array ArrayList1
    | Array
;
ArrayList1
    : Array ArrayList1
    | Array
    | EOF
;

Array
    : '[' ']'
;


Elements
    : Element ',' Elements
    | Element
;

Element
    : Expr
;

Literal
    : NULLTOKEN
    | TRUETOKEN
    {
        var r = [];
        r[0] = 'BOOLEAN';
        var temp = Temp.getTemporal();
        r[1] = temp;
        r[2] = '';
        var valor = '\n';
        valor += temp + ' = 1;';
        r[3] = valor;
        r[4] = '';
        r[5] = 1;
        $$ = r;
    }
    | FALSETOKEN
    {
        var r = [];
        r[0] = 'BOOLEAN';
        var temp = Temp.getTemporal();
        r[1] = temp;
        r[2] = '';
        var valor = '\n';
        valor += temp + ' = 0;';
        r[3] = valor;
        r[4] = '';
        r[5] = 1;
        $$ = r;
    }
    | NUMBER
    {
        var r = [];
        r[0] = "NUMBER";
        var temp = Temp.getTemporal();
        r[1] = temp;
        r[2] = '';
        var valor = '\n';
        valor += temp + ' = ' + $1 + ';';
        r[3] = valor;
        r[4] = '';
        r[5] = $1;
        r[6] = '';
        $$ = r;

    }
    | CADENA
    {
        var temp = Temp.getTemporal();
        var r = [];
        r[0] = "STRING";
        r[1] = temp;
        r[2] = '';

        var valor = '';
        for(var a = 0; a<$1.length; a++)
        {
            valor += temp + ' = ' + temp + ' + 1;';
            valor += '\n';
            valor += 'stack['+temp+'] = ' + $1.charCodeAt(a) + ';';
            valor += '\n';
        }
        r[3] = valor;
        r[4] = '';
        r[5] = $1;
        r[6] = '';

        $$ = r;

    }
    | CADENA2
    {
        var temp = Temp.getTemporal();
        var r = [];
        r[0] = "STRING";
        r[1] = temp;
        r[2] = '';

        var valor = '';
        for(var a = 0; a<$1.length; a++)
        {
            valor += temp + ' = ' + temp + ' + 1;';
            valor += '\n';
            valor += 'stack['+temp+'] = ' + $1.charCodeAt(a) + ';';
            valor += '\n'
        }
        r[3] = valor;
        r[4] = '';
        r[5] = $1;
        r[6] = '';

        $$ = r;

    }
;

Property
    : IDENT ':' AssignmentExpr
    | IDENT ':' TypeV
    | EOF
;

PropertyList
    : Property
    | Property ',' PropertyList
;

PrimaryExpr
    : PrimaryExprNoBrace
    {
        $$ = $1;
    }
    | OPENBRACE CLOSEBRACE
    | OPENBRACE PropertyList CLOSEBRACE
;

PrimaryExprNoBrace
    : Literal
    {
        $$ = $1;
    }
    | ArrayLiteral
    | IDENT
    {
        var r = [];
        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = '';
        r[4] = $1;
        r[5] = '';
        r[6] = '';
        $$ = r;
    }
    | '(' Expr ')'
    | Expr1_statements
;

Expr1_statements
    : IDENT Expr1_statement
    | IDENT  PLUSPLUS
    | IDENT  MINSMINS
    | IDENT '.' CHARAT '(' Expr ')'
    | IDENT '.' TOLOWER '(' ')'
    | IDENT '.' TOUPPER '(' ')'
    | IDENT '.' CONCAT '(' Expr ')'
    | MINSMINS IDENT
    | PLUSPLUS IDENT
    | IDENT Expr1_statement PLUSPLUS
    | IDENT Expr1_statement MINSMINS
    | MINSMINS IDENT Expr1_statement
    | PLUSPLUS IDENT Expr1_statement
    | IDENT '.' LENGTH
    | IDENT Expr1_statement '.' LENGTH
    | IDENT Expr1_statement initialNo ';'
    | IDENT Expr1_statement initialNo
;

ArrayLiteral
    : '[' ']'
    | '[' ElementList ']'
;
ArrayLiterals
    : '[' ElementList ']' ArrayLiterals
    | '[' ElementList ']'
;

ElementList
    : AssignmentExpr
    | ElementList ',' AssignmentExpr
;


MemberExpr
    : PrimaryExpr
    {
        $$ = $1;
    }
    | FunctionExpr
    | MemberExpr '[' Expr ']'
    | MemberExpr '.' IDENT
;

MemberExprNoBF
    : PrimaryExprNoBrace
    {
        $$ = $1;
    }
    | MemberExprNoBF '[' Expr ']'
    | MemberExprNoBF '.' IDENT
;



CallExpr
    : IDENT
    {
        var r = [];
        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = '';
        r[4] = $1;
        r[5] = '';
        r[6] = '';
        $$ = r;
    }
    | CallExpr Arguments
    | CallExpr '[' Expr ']'
    | CallExpr '.' IDENT
;

CallExprNoBF
    : IDENT
    {
        var r = [];
        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = '';
        r[4] = $1;
        r[5] = '';
        r[6] = '';
        $$ = r;
    }
    | CallExprNoBF Arguments
    | CallExprNoBF '[' Expr ']'
    | CallExprNoBF '.' IDENT
;

Arguments
    : '(' ')'
    | '(' ArgumentList ')'
;

ArgumentList
    : AssignmentExpr
    | ArgumentList ',' AssignmentExpr
;

LeftHandSideExpr
    : MemberExpr
    {
        $$ = $1;
    }
    | CallExpr
    {
        $$ = $1;
    }
;

LeftHandSideExprNoBF
    : MemberExpr
    {
        $$ = $1;
    }
    | CallExprNoBF
    {
        $$ = $1;
    }
;

PostfixExpr
    : LeftHandSideExpr
    {
        $$ = $1;
    }
;

PostfixExprNoBF
    : LeftHandSideExprNoBF
    {
        $$ = $1;
    }
;

UnaryExprCommon
    : '+' UnaryExpr
    | '-' UnaryExpr
    | '!' UnaryExpr
;

UnaryExpr
    : PostfixExpr
    {
        $$ = $1;
    }
    | UnaryExprCommon
    {
        $$ = $1;
    }
;

UnaryExprNoBF
    : PostfixExprNoBF
    {
        $$ = $1;
    }
    | UnaryExprCommon
    {
        $$ = $1;
    }
;

MultiplicativeExpr
    : UnaryExpr
    {
        $$ =  $1;
    }
    | MultiplicativeExpr '*' UnaryExpr
    | MultiplicativeExpr '/' UnaryExpr
    | MultiplicativeExpr POTENCIA UnaryExpr
    | MultiplicativeExpr '%' UnaryExpr
;

MultiplicativeExprNoBF
    : UnaryExprNoBF
    {
        $$ = $1;
    }
    | MultiplicativeExprNoBF '*' UnaryExpr
    | MultiplicativeExprNoBF '/' UnaryExpr
    | MultiplicativeExprNoBF POTENCIA UnaryExpr
    | MultiplicativeExprNoBF '%' UnaryExpr
;

AdicionExpr
    : MultiplicativeExpr
    {
        $$ = $1;
    }
    | AdicionExpr '+' MultiplicativeExpr
    {
        if($1[0] == 'STRING'  && $3[0] == 'STRING')
        {
            var r = [];
            r[0] = "STRING";
            r[1] = $1[1];
            var valor = '' + '\n';
            valor += $1[3];
            for(var a = 0; a<$3[5].length; a++)
             {
                 valor += $1[1] + ' = ' + $1[1] + ' + 1;';
                 valor += '\n';
                 valor += 'stack['+$1[1]+'] = ' + $3[5].charCodeAt(a) + ';';
                 valor += '\n'
             }
            r[2] = '';
            r[3] = valor;
            r[4] = '';
            r[5] = $1[5] + $3[5];
            r[6] = '';
            $$ = r;
        }
        else if($1[0] == 'STRING' && $1[0] != '')
        {
             var r = [];
             r[0] = "STRING";
             r[1] = $1[1];
             var valor = '' + '\n';
             valor += $1[3];
             var val = $3[5].toString();
             for(var a = 0; a<val.length; a++)
              {
                  valor += $1[1] + ' = ' + $1[1] + ' + 1;';
                  valor += '\n';
                  valor += 'stack['+$1[1]+'] = ' + val.charCodeAt(a) + ';';
                  valor += '\n'
              }
             r[2] = '';
             r[3] = valor;
             r[4] = '';
             r[5] = $1[5] + $3[5].toString();
             r[6] = '';
             $$ = r;
        }
        else if($1[0] != '' && $1[0] == 'STRING')
        {
             var r = [];
             r[0] = "STRING";
             r[1] = $1[1];
             var valor = '' + '\n';
             var val = $1[5].toString();
             for(var a = 0; a<val.length; a++)
              {
                  valor += $1[1] + ' = ' + $1[1] + ' + 1;';
                  valor += '\n';
                  valor += 'stack['+$1[1]+'] = ' + val.charCodeAt(a) + ';';
                  valor += '\n'
              }
              valor += $3[3];
             r[2] = '';
             r[3] = valor;
             r[4] = '';
             r[5] = $1[5].toString() + $3[5];
             r[6] = '';
             $$ = r;
        }
    }
    | AdicionExpr '-' MultiplicativeExpr
;

AdicionExprNoBF
    : MultiplicativeExprNoBF
    {
        $$ = $1;
    }
    | AdicionExprNoBF '+' MultiplicativeExpr
    | AdicionExprNoBF '-' MultiplicativeExpr
;

RelacionalExpr
    : AdicionExpr
    {
        $$ = $1;
    }
    | RelacionalExpr '<' AdicionExpr
    | RelacionalExpr '>' AdicionExpr
;

RelacionalExprNoIn
    : AdicionExpr
    {
        $$ = $1;
    }
    | RelacionalExprNoIn '<' AdicionExpr
    | RelacionalExprNoIn '>' AdicionExpr
;

RelacionalExprNoBF
    : AdicionExprNoBF
    {
        $$ = $1;
    }
    | RelacionalExprNoBF '<' AdicionExprNoBF
    | RelacionalExprNoBF '>' AdicionExprNoBF
;

IgualdadExpr
    : RelacionalExpr
    {
        $$ = $1;
    }
    | IgualdadExpr EQQ RelacionalExpr
    | IgualdadExpr NOEQQ RelacionalExpr
    | IgualdadExpr MAQ RelacionalExpr
    | IgualdadExpr MIQ RelacionalExpr
;

IgualdadExprNoIn
    : RelacionalExprNoIn
    {
        $$ = $1;
    }
    | IgualdadExprNoIn EQQ RelacionalExprNoIn
    | IgualdadExprNoIn NOEQQ RelacionalExprNoIn
    | IgualdadExprNoIn MAQ RelacionalExprNoIn
    | IgualdadExprNoIn MIQ RelacionalExprNoIn
;

IgualdadExprNoBF
    : RelacionalExprNoBF
    {
        $$ = $1;
    }
    | IgualdadExprNoBF EQQ RelacionalExpr
    | IgualdadExprNoBF NOEQQ RelacionalExpr
    | IgualdadExprNoBF MAQ RelacionalExpr
    | IgualdadExprNoBF MIQ RelacionalExpr
;


LogicaYYExpr
    : IgualdadExpr
    {
        $$ = $1;
    }
    | LogicaYYExpr AND IgualdadExpr
;

LogicaYYExprNoIn
    : IgualdadExprNoIn
    {
        $$ = $1;
    }
    | LogicaYYExprNoIn AND IgualdadExprNoIn
;

LogicaYYExprNoBF
    : IgualdadExprNoBF
    {
        $$ = $1;
    }
    | LogicaYYExprNoBF AND IgualdadExprNoBF
;

LogicaOOExpr
    : LogicaYYExpr
    {
        $$ = $1;
    }
    | LogicaOOExpr OR LogicaYYExpr
;

LogicaOOExprNoIn
    : LogicaYYExprNoIn
    {
        $$ = $1;
    }
    | LogicaOOExprNoIn OR LogicaYYExprNoIn
;

LogicaOOExprNoBF
    : LogicaYYExprNoBF
    {
        $$ = $1;
    }
    | LogicaOOExprNoBF OR LogicaYYExpr
;

CondicionTernariaExpr
    : LogicaOOExpr
    {
        $$ = $1;
    }
    | LogicaOOExpr '?' AssignmentExpr ':' AssignmentExpr
;

CondicionTernariaExprNoIn
    : LogicaOOExprNoIn
    {
        $$ = $1;
    }
    | LogicaOOExprNoIn '?' AssignmentExprNoIn ':' AssignmentExprNoIn
;

CondicionTernariaExprNoBF
    : LogicaOOExprNoBF
    {
        $$ = $1;
    }
;

AssignmentExpr
    : CondicionTernariaExpr
    {
        $$ = $1;
    }
;

AssignmentExprNoIn
    : CondicionTernariaExprNoIn
    {
        $$ = $1;
    }
;

AssignmentExprNoBF
    : CondicionTernariaExprNoBF
    {
        $$ = $1;
    }
;
