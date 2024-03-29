//  UNIVERSIDAD DE SAN CARLOS DE GUATEMALA
//  JOSE ORLANDO WANNAN ESCOBAR - 2020

%{
    var lexicos = [];
    var sintacticos = [];
    var semanticos = [];
    var errores = [];
    var ast = [];
    var intermedia = require('./TS.js');
    var tab = new intermedia.TablaSimbolos();
    var Temp = new intermedia.temporal();
    var Label = new intermedia.bandera();
    var arr = new intermedia.Arreglos();
    var ff = [];
    var pos = 0;
    var stac = 0;
    var posS = 0;
    var C3D = '';
    var posS = 50000;
    var posA = 1000000;
    var entorno = 'global';
    var entornoanterior = 'global';
    var func = false;
    var ifs = false;
    var whiles = false;
    var fores = false;
    var does = false;
    var switches = false;
    var breaks = '';
    var continues = '';
    var returns = '';
    var params = 0;

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
"while"                         return 'WHILE'
"else"                          return 'ELSE'
"for"                           return 'FOR'
"of"                            return 'OFTOKEN'
"in"                            return 'INTOKEN'
"return"                        return 'RETURN'

"length"                        return 'LENGTH'
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
        var valor = '';
        valor += '#include <stdio.h>\n';
        valor += 'float stack[10000000]={-1};\nfloat heap[10000000] = {-1};\n';
        valor += 'float P = 5000;\n float H = 0;\n'
        valor += 'float ';
        for(let k of Temp.temporales)
        {
            valor += k + ',';
        }
        valor = valor.slice(0, -1);
        valor +=' = -1;\n';
        var tabs = tab.getFunctions();
        //console.log(tabs);
        for(let t of tabs)
        {
            valor += `void ${t}();\n`;
        }
        valor += '\nint main()\n{\n';
        valor += $1[3];
        valor +='return 0;\n}\n\n';
        for(let f of ff)
        {
            valor += f + '\n\n';
        }
        var r = [];
        r[0] = (valor);
        r[1] =(errores);
        r[2] =(lexicos);
        r[3] =(sintacticos);
        r[4] =(semanticos);
        r[5] =(tab.getSimbolos());
        r[6] = 'JW - 2020';
        $$ = r;
        console.log('-----      CODIGO         ------')
        //console.log(valor);
        console.log('-----      ERRORES        ------');
        for(let m of errores)
        {
           console.log(m);
        }
        console.log('-----   ERRORES LEXICOS   ------');
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
        console.log('----- TABLA DE SIMBOLOS  ------');
        tab.printSimbolos();
        return $$;
    }
    | EOF
;


Source1
    :  Statement
    {
        var valor = '';
        valor += $1[3];
        var r = [];
        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = valor;
        $$ = r;
    }
    |  Statement Source1
    {
        var valor = '';
        valor += $1[3] + '\n';
        valor += $2[3];
        var r = [];
        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = valor;
        $$ = r;
    }
    |  EOF
    {
        $$ = ['','','','',''];
    }

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
        func = !func;
        tab.deleteAmbitoLast();
        if(tab.ambitoLevel > 0) tab.ambitoLevel = tab.ambitoLevel-1;
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
    {
         $$ = ['','','','','','','','','',''];
    }
    | error ';'
      {
        console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);
        sintacticos.push('{\"token\":\"'+yytext+'\", \"linea\":\"'+this._$.first_line+'\", \"columna\":\"'+this._$.first_column+'\"}');
        $$ = ['','','','','','','','','',''];
      }
    | error
      {
        console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);
        sintacticos.push('{\"token\":\"'+yytext+'\", \"linea\":\"'+this._$.first_line+'\", \"columna\":\"'+this._$.first_column+'\"}');
        $$ = ['','','','','','','','','',''];
      }
;

Native_statements
    : CONSOLE '.' LOG '(' Expr ')'
    {
        tab.printSimbolos()
        var r = [];
        //console.log($5);
        if($5[0].toUpperCase() == 'ARPRINT')
        {
            r[3] = '';
            for(let val of $5[1])
            {
                 if(val[0] == "STRING")
                 {
                     var valor = '';
                     for(var a =0; a<val[6].length;a++)
                     {
                         valor += 'printf("%c",(char)'+val[6].charCodeAt(a)+');\n';
                     }

                     r[3] += valor;
                 }
                 else if(val[0] == "NUMBER")
                 {
                     if(val[6]%1==0)
                     {
                         var valor = val[3];
                         valor += '\n';
                         valor += 'printf("%d",(int)'+val[1]+');\n';
                         r[3] += valor;
                     }
                     else
                     {
                         var valor = val[3];
                         valor += '\n';
                         valor += 'printf("%f",(float)'+val[1]+');\n';
                         r[3] += valor;
                     }
                 }
                 else if(val[0] == "FLOAT")
                 {
                     var valor = val[3];
                     valor += '\n';
                     valor += 'printf("%f",(float)'+val[1]+');\n';
                     r[3] += valor;
                 }
                 else if(val[0] == "BOOLEAN")
                 {
                     //convert ASCII
                     var valor = val[3];
                     valor += '\n';
                     var label = Label.getBandera();
                     var label1 = Label.getBandera();
                     valor += `if(${$5[1]}==0) goto ${label};\n`;
                     valor += `printf("true");\n`;
                     valor += `goto ${label1};\n`;
                     valor += `${label}:\n`;
                     valor += `printf("false");\n`;
                     valor += `goto ${label1};\n`;
                     valor += `${label1}:\n`;
                     valor += 'printf("\\n");\n';
                     r[3] = valor;
                 }
                 else
                 {
                     if(val[4] != '')
                     {
                         var n = tab.getPositionAmbito(val[4]);
                         if(n!=null && n!=undefined)
                         {
                             if(n.rol.toUpperCase() == "ARREGLO")
                             {
                                var valor = '';
                                valor += 'printf("[");\n';
                                var am = arr.getValores(n.name);
                                if(typeof am[0] == 'string')
                                {
                                    for(let ams of am)
                                    {
                                         for(var a =0; a<ams.length;a++)
                                         {
                                             valor += 'printf("%c",(char)'+ams.charCodeAt(a)+');\n';
                                         }
                                         valor += 'printf(",");\n';
                                    }
                                }
                                else if(typeof am[0] == 'number')
                                {

                                    for(let ams of am)
                                    {
                                      if(ams%1==0)
                                      {
                                          valor += '\n';
                                          valor += 'printf("%d",(int)'+ams+');\n';
                                          valor += 'printf(",");\n';
                                      }
                                      else
                                      {
                                          valor += '\n';
                                          valor += 'printf("%f",(float)'+ams+');\n';
                                          valor += 'printf(",");\n';
                                      }
                                    }
                                }
                                else
                                {
                                    for(let ams of am)
                                    {
                                      valor += '\n';
                                      valor += 'printf("'+ams+'");\n';
                                      valor += 'printf(",");\n';
                                    }
                                }
                                valor += 'printf("]");\n';
                                valor += 'printf("\\n");\n';
                                r[3] = valor;
         
                             }
                             else if(n.rol.toUpperCase() == "VARIABLE")
                             {
                                 if(n.tipo.toUpperCase() == "NUMBER")
                                 {
                                    if(n.rol == 'Parametro')
                                    {
                                        var temp = Temp.getTemporal();
                                        valor = temp+' = '+n.valor+';\n';
                                        valor += 'printf("%d",(int)'+temp+');\n';
                                        r[3] = valor;
                                    }
                                    else
                                    {
                                         if(n.valor%1==0)
                                         {
                                             var valor = '';
                                             valor += '\n';
                                             var temp = Temp.getTemporal();
                                             if(n.entorno == 'global')
                                             {
                                                 valor = temp+' = heap['+n.position+'];';
                                                 valor += '\n';
                                             }
                                             else
                                             {
                                                 valor = temp+' = stack['+n.position+'];';
                                                 valor += '\n';
                                             }
                                             valor += 'printf("%d",(int)'+temp+');\n';

                                             r[3] += valor;
                                         }
                                         else
                                         {
                                             var valor = '';
                                             valor += '\n';
                                             var temp = Temp.getTemporal();
                                             if(n.entorno == 'global')
                                             {
                                                 valor = temp+' = heap['+n.position+'];';
                                                 valor += '\n';
                                             }
                                             else
                                             {
                                                 valor = temp+' = stack['+n.position+'];';
                                                 valor += '\n';
                                             }
                                             valor += 'printf("%f",(float)'+temp+');\n';
                                             r[3] += valor;
                                         }
                                     }
         
                                 }
                                 else if(n.tipo.toUpperCase() == "FLOAT")
                                 {
                                     var valor = '';
                                     valor += '\n';
                                     var temp = Temp.getTemporal();
                                        if(n.entorno == 'global')
                                         {
                                             valor = temp+' = heap['+n.position+'];';
                                             valor += '\n';
                                         }
                                         else
                                         {
                                             valor = temp+' = stack['+n.position+'];';
                                             valor += '\n';
                                         }
                                     valor += 'printf("%f",(float)'+temp+');\n';
                                     r[3] += valor;
                                 }
                                 else if(n.tipo.toUpperCase() == "STRING")
                                 {
                                     var valor = '';
                                     valor += '\n';
         
                                     var temp = Temp.getTemporal();
                                     if(n.rol == 'Parametro')
                                     {
                                        valor = temp+' = '+n.valor+';';
                                        valor += '\n';
                                     }
                                     else
                                     {

                                        if(n.entorno == 'global')
                                         {
                                             valor = temp+' = heap['+n.position+'];';
                                             valor += '\n';
                                         }
                                         else
                                         {
                                             valor = temp+' = stack['+n.position+'];';
                                             valor += '\n';
                                         }
                                    }
                                     var temp1 = Temp.getTemporal();
                                     valor += '\n';
                                     valor += temp1 + '= heap[(int)'+temp+'];\n';
                                     valor += temp1 + ' = '+ temp1 + ' + 1;';
         
                                     var temp2  = Temp.getTemporal();
                                     valor += '\n';
                                     valor += temp2 + '= heap[(int)'+temp1+'];';
         
                                     var temp3 = Temp.getTemporal();
                                     valor += '\n';
                                     valor += temp3 + ' = 0;';
         
                                     var label = Label.getBandera();
                                     valor += '\n';
                                     valor += label + ':';
                                     var label1 = Label.getBandera();
         
                                     valor += '\n';
                                     valor += 'if(' + temp3 + '==' + temp2 + ') goto '+label1+';';
                                     valor += '\n';
         
                                     var temp4 = Temp.getTemporal();
                                     valor += temp4 + ' = ' + temp3 + ' + ' + temp1 + ';';
                                     valor += '\n';
                                     valor += temp3 + ' = ' + temp3 + ' + 1;';
                                     valor += '\n';
         
                                     var temp5 = Temp.getTemporal();
                                     valor += temp5 + ' = heap[(int)' + temp4 + '];';
                                     valor += '\n';
                                     valor += 'printf("%c",(char)' + temp5 + ');';
                                     valor += '\n';
                                     valor += 'goto ' + label + ';';
                                     valor += '\n';
                                     valor += label1 + ':';
                                     valor += '\n';
                                     r[3] += valor;
                                 }
                             }
                         }
                         else
                         {
                             semanticos.push('{\"valor\":\"'+`Error Semantico en la linea: ${(yylineno+1)}, no existe la variable ${val[4]}`+'\"}');
                             r[3] = '';
                         }
                     }
                 }
            }
            r[3] += 'printf("\\n");\n';
        }
        else if($5[0].toUpperCase() == "STRING")
        {
            var valor = '';
            //console.log($5);
            if($5[6] == '')
            {
                valor += $5[3]+'\n';
                valor += 'printf("%c",(char)'+$5[1]+');\n';
            }
            else
            {
                for(var a =0; a<$5[6].length;a++)
                {
                    valor += 'printf("%c",(char)'+$5[6].charCodeAt(a)+');\n';
                }
            }
            valor += 'printf("\\n");\n';
            r[3] = valor;
        }
        else if($5[0].toUpperCase() == "NUMBER")
        {

            if(Number($5[6])%1==0)
            {
                var valor = $5[3];
                valor += '\n';
                valor += 'printf("%d",(int)'+$5[1]+');\n';
                valor += 'printf("\\n");\n';
                r[3] = valor;
            }
            else
            {
                var valor = $5[3];
                valor += '\n';
                valor += 'printf("%f",(float)'+$5[1]+');\n';
                valor += 'printf("\\n");\n';
                r[3] = valor;
            }
        }
        else if($5[0].toUpperCase() == "FLOAT")
        {
            var valor = $5[3];
            valor += '\n';
            valor += 'printf("%f",(float)'+$5[1]+');\n';
            valor += 'printf("\\n");\n';
            r[3] = valor;
        }
        else if($5[0].toUpperCase() == "BOOLEAN")
        {
            //convert ASCII
            var valor = $5[3];
            valor += '\n';
            var label = Label.getBandera();
            var label1 = Label.getBandera();
            valor += `if(${$5[1]}==0) goto ${label};\n`;
            valor += `printf("true");\n`;
            valor += `goto ${label1};\n`;
            valor += `${label}:\n`;
            valor += `printf("false");\n`;
            valor += `goto ${label1};\n`;
            valor += `${label1}:\n`;
            valor += 'printf("\\n");\n';
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
                        var valor = '';
                        valor += 'printf("[");\n';
                        var am = arr.getValores(n.name);
                        if(typeof am[0] == 'string')
                        {
                            for(let ams of am)
                            {
                                 for(var a =0; a<ams.length;a++)
                                 {
                                     valor += 'printf("%c",(char)'+ams.charCodeAt(a)+');\n';
                                 }
                                 valor += 'printf(",");\n';
                            }
                        }
                        else if(typeof am[0] == 'number')
                        {

                            for(let ams of am)
                            {
                              if(ams%1==0)
                              {
                                  valor += '\n';
                                  valor += 'printf("%d",(int)'+ams+');\n';
                                  valor += 'printf(",");\n';
                              }
                              else
                              {
                                  valor += '\n';
                                  valor += 'printf("%f",(float)'+ams+');\n';
                                  valor += 'printf(",");\n';
                              }
                            }
                        }
                        else
                        {
                            for(let ams of am)
                            {
                              valor += '\n';
                              valor += 'printf("'+ams+'");\n';
                              valor += 'printf(",");\n';
                            }
                        }
                        valor += 'printf("]");\n';
                        valor += 'printf("\\n");\n';
                        r[3] = valor;

                     }
                    else if(n.rol.toUpperCase() == "VARIABLE")
                    {
                        if(n.tipo.toUpperCase() == "NUMBER")
                        {
                            if(n.rol == 'Parametro')
                            {
                                valor = temp+' = '+n.valor+';';
                                valor += '\n';
                                r[3] = valor;
                            }
                            else
                            {
                                if(n.valor%1==0)
                                {
                                    var valor = '';
                                    valor += '\n';
                                    var temp = Temp.getTemporal();
                                    if(n.entorno == 'global')
                                     {
                                         valor = temp+' = heap['+n.position+'];';
                                         valor += '\n';
                                     }
                                     else
                                     {
                                         valor = temp+' = stack['+n.position+'];';
                                         valor += '\n';
                                     }
                                    valor += 'printf("%d",(int)'+temp+');\n';
                                    valor += 'printf("\\n");\n';
                                    r[3] = valor;
                                }
                                else
                                {
                                    var valor = '';
                                    valor += '\n';
                                    var temp = Temp.getTemporal();
                                    if(n.entorno == 'global')
                                     {
                                         valor = temp+' = heap['+n.position+'];';
                                         valor += '\n';
                                     }
                                     else
                                     {
                                         valor = temp+' = stack['+n.position+'];';
                                         valor += '\n';
                                     }
                                    valor += 'printf("%f",(float)'+temp+');\n';
                                    valor += 'printf("\\n");\n';
                                    r[3] = valor;
                                }
                            }

                        }
                        else if(n.tipo.toUpperCase() == "BOOLEAN")
                        {
                            var valor = '';
                            valor += '\n';
                            var temp = Temp.getTemporal();
                            var label = Label.getBandera();
                            var label1 = Label.getBandera();
                            if(n.rol == 'Parametro')
                            {
                                 valor = temp+' = '+n.valor+';';
                                 valor += '\n';
                            }
                            else
                            {
                                if(n.entorno == 'global')
                                 {
                                     valor = temp+' = heap['+n.position+'];';
                                     valor += '\n';
                                 }
                                 else
                                 {
                                     valor = temp+' = stack['+n.position+'];';
                                     valor += '\n';
                                 }
                             }
                            valor += `if(${temp}==0) goto ${label};\n`;
                            valor += `printf("true");\n`;
                            valor += `goto ${label1};\n`;
                            valor += `${label}:\n`;
                            valor += `printf("false");\n`;
                            valor += `goto ${label1};\n`;
                            valor += `${label1}:\n`;
                            valor += 'printf("\\n");\n';
                            r[3] = valor;

                        }
                        else if(n.tipo.toUpperCase() == "FLOAT")
                        {
                            var valor = '';
                            valor += '\n';
                            var temp = Temp.getTemporal();
                            if(n.entorno == 'global')
                             {
                                 valor = temp+' = heap['+n.position+'];';
                                 valor += '\n';
                             }
                             else
                             {
                                 valor = temp+' = stack['+n.position+'];';
                                 valor += '\n';
                             }
                            valor += 'printf("%f",(float)'+temp+');\n';
                            valor += 'printf("\\n");\n';
                            r[3] = valor;
                        }
                        else if(n.tipo.toUpperCase() == "STRING")
                        {
                            var valor = '';
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            if(n.rol == 'Parametro')
                            {
                                 valor = temp+' = '+n.valor+';';
                                 valor += '\n';
                            }
                            else
                            {

                                if(n.entorno == 'global')
                                 {
                                     valor = temp+' = heap['+n.position+'];';
                                     valor += '\n';
                                 }
                                 else
                                 {
                                     valor = temp+' = stack['+n.position+'];';
                                     valor += '\n';
                                 }
                             }

                            var temp1 = Temp.getTemporal();
                            valor += '\n';
                            valor += temp1 + '= heap[(int)'+temp+'];\n';
                            valor += temp1 + ' = '+ temp1 + ' + 1;';

                            var temp2  = Temp.getTemporal();
                            valor += '\n';
                            valor += temp2 + '= heap[(int)'+temp1+'];';

                            var temp3 = Temp.getTemporal();
                            valor += '\n';
                            valor += temp3 + ' = 0;';

                            var label = Label.getBandera();
                            valor += '\n';
                            valor += label + ':';
                            var label1 = Label.getBandera();

                            valor += '\n';
                            valor += 'if(' + temp3 + '==' + temp2 + ') goto '+label1+';';
                            valor += '\n';

                            var temp4 = Temp.getTemporal();
                            valor += temp4 + ' = ' + temp3 + ' + ' + temp1 + ';';
                            valor += '\n';
                            valor += temp3 + ' = ' + temp3 + ' + 1;';
                            valor += '\n';

                            var temp5 = Temp.getTemporal();
                            valor += temp5 + ' = heap[(int)' + temp4 + '];';
                            valor += '\n';
                            valor += 'printf("%c",(char)' + temp5 + ');';
                            valor += '\n';
                            valor += 'goto ' + label + ';';
                            valor += '\n';
                            valor += label1 + ':';
                            valor += '\n';
                            valor += 'printf("\\n");\n';
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
            else
            {
                r[3] = '';
            }
        }
        $$ = r;
    }
;

Expr_statements
    : ExprNB ';'
    {
        $$ = $1;
    }
    | ExprNB
    {
        $$ = $1;
    }
;

Empty_statements
    : ';'
    {
        $$ = ['','','','','',''];
    }
;

Block_statements
    : OPENBRACE CLOSEBRACE
    {
        $$ = ['','','','','',''];
    }
    | OPENBRACE Source2 CLOSEBRACE
    {
        $$ = $2;
    }
;

Assignation_statements
    : IDENT '=' NEWT ARRAYS '(' Expr ')'
    {
        var n = tab.getPositionAmbito($1);
        if(n!=null)
        {
            if(!n.constante)
            {
                if(n.rol.toUpperCase() == 'ARREGLO')
                {
                    var u = $6;
                    if(u[0].toUpperCase() == 'NUMBER')
                    {
                        var valor = '';
                        valor += u[3];
                        valor += '\n';
                        var temp1 = Temp.getTemporal();
                        valor += temp1 + ' = ' + n.position +';';
                        valor += '\n';
                        var temp2 = Temp.getTemporal();
                        var temp3 = Temp.getTemporal();
                        if(n.rol == 'Parametro')
                        {
                            valor += temp2 + ' = '+n.valor+';';
                            valor += '\n';
                        }
                        else
                        {
                            if(n.entorno == 'global')
                            {
                                valor += temp2 + ' = heap[(int)'+temp1+'];';
                                valor += '\n';
                            }
                            else
                            {
                                valor += temp2 + ' = stack[(int)'+temp1+'];';
                                valor += '\n';
                            }
                        }


                        valor += temp3+' = heap[(int)' + temp2 +'];';
                        valor += '\n';

                        var temp4 = Temp.getTemporal();
                        valor += temp4 + ' = heap[(int)'+temp3+'];\n';
                        var label0 = Label.getBandera();
                        var label0_1 = Label.getBandera();
                        var temp5 = Temp.getTemporal();
                        var temp6 = Temp.getTemporal();
                        valor += `${temp5} = 1;\n`;
                        valor += `${label0}:\n`;
                        valor += `if(${temp5}==${temp4}) goto ${label0_1};\n`;
                        valor += `${temp6} = ${temp5} + ${temp4};\n`;
                        valor += `${temp5} = ${temp5} + 1;\n`;
                        valor += `heap[(int)${temp6}] = -1;\n`;
                        valor += `goto ${label0};\n`;
                        valor += `${label0_1}:\n`;

                        var a = new intermedia.arreglo()
                        a.name = n.name;
                        a.tipo = n.tipo;
                        a.positions.push(u[6]);
                        a.c3d = valor;
                        a.temporal = temp6;
                        a.bandera = label0_1;

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp6;
                        r[2] = label0_1;
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';

                        n.valor = a;
                        var k = tab.update(n.name,n);
                        if(k)
                        {
                            $$ = r;

                            for(var m = 0; m<arr.valores.length;m++)
                            {
                                if(arr.valores[m].name == n.name)
                                {
                                    arr.valores[m] = a;
                                }
                            }
                        }
                        else
                        {
                            errores.push('{\"valor\":\"'+`Error, linea ${(yylineno+1)}, no se ha logrado ejecutar la operacion;`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                    else if(u[0] == '')
                    {
                         var n1 = tab.getPositionAmbito(u[4]);
                         if(n1!=null)
                         {
                             if(n1.tipo.toUpperCase()!='')
                             {
                                 switch(n1.tipo.toUpperCase())
                                 {
                                     case 'NUMBER':
                                        var valor = '';
                                        var temp1 = Temp.getTemporal();
                                        var temp0 = Temp.getTemporal();
                                        valor += temp0 + ' = ' + n1.position + ';\n';
                                        var temp0_1 = Temp.getTemporal();
                                        if(n1.rol == 'Parametro')
                                        {
                                            valor += temp0_1 + ' = '+n.valor+';\n';
                                        }
                                        else
                                        {
                                            if(n1.entorno == 'global')
                                            {
                                                valor += temp0_1 + ' = heap[(int)'+temp0+'];';
                                                valor += '\n';
                                            }
                                            else
                                            {
                                                valor += temp0_1 + ' = stack[(int)'+temp0+'];';
                                                valor += '\n';
                                            }
                                        }

                                        valor += temp1 + ' = ' + n.position +';';
                                        valor += '\n';
                                        var temp2 = Temp.getTemporal();
                                        var temp21 = Temp.getTemporal();
                                        if(n.rol == 'Parametro')
                                        {
                                            valor += temp2 +' = ' + n.valor + ';';
                                            valor += '\n';
                                        }
                                        else
                                        {
                                            if(n.entorno == 'global')
                                            {
                                                valor += temp2 +' = heap[(int)' + temp1 + '];';
                                                valor += '\n';
                                            }
                                            else
                                            {
                                                valor += temp2 +' = stack[(int)' + temp1 + '];';
                                                valor += '\n';
                                            }
                                        }

                                        valor += temp21 + ' = heap[(int)' + temp2 + '];';
                                        valor += '\n';
                                        valor += temp21 + ' = ' + temp21 + ' + 1;';
                                        valor += '\n';
                                        valor += 'heap[(int)' + temp21 + '] = ' + temp0_1 + ';';
                                        valor += '\n';
                                        var temp3 = Temp.getTemporal();
                                        valor += temp3 + ' = 1;';
                                        valor += '\n';
                                        var label = Label.getBandera();
                                        var label1 = Label.getBandera();
                                        valor += label + ': ';
                                        valor += '\n';
                                        valor += '\t' + 'if( ' + temp3 + ' == ' + temp0_1 + ' ) goto ' + label1 + ';';
                                        valor += '\n';
                                        valor += '\t' + temp21 + ' = ' + temp21 + ' + 1;';
                                        valor += '\n';
                                        valor += '\t' + temp3 + ' = ' + temp3 + ' + 1;';
                                        valor += '\n';
                                        valor += '\t' + 'heap[(int)'+temp21+'] = -1;';
                                        valor += '\n';
                                        valor += '\t' + 'goto ' + label + ';';
                                        valor += '\n';
                                        valor += label1 + ': \n';

                                        var a = new intermedia.arreglo()
                                        a.name = n.name;
                                        a.tipo = n.tipo;
                                        a.positions.push(u[6]);
                                        a.c3d = valor;
                                        a.temporal = temp6;
                                        a.bandera = label0_1;

                                        var r = [];
                                        r[3] = valor;
                                        r[0] = '';
                                        r[1] = temp6;
                                        r[2] = label0_1;
                                        r[4] = '';
                                        r[5] = '';
                                        r[6] = '';
                                        r[7] = '';

                                        n.valor = a;
                                        var k = tab.update(n.name,n);
                                        if(k)
                                        {
                                            $$ = r;

                                            for(var m = 0; m<arr.valores.length;m++)
                                            {
                                                if(arr.valores[m].name == n.name)
                                                {
                                                    arr.valores[m] = a;
                                                }
                                            }
                                        }
                                        else
                                        {
                                            errores.push('{\"valor\":\"'+`Error, linea ${(yylineno+1)}, no se ha logrado ejecutar la operacion;`+'\"}');
                                            $$ = ['','','',''];
                                        }
                                        break;
                                     DEFAULT:
                                      semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${u[0]}, a una variable de tipo arreglo;`+'\"}');
                                      $$ = ['','','',''];
                                      break;
                                 }
                             }
                             else
                             {
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${u[0]}, a una variable de tipo arreglo;`+'\"}');
                                 $$ = ['','','',''];
                             }

                         }
                         else
                         {
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${u[0]}, a una variable de tipo arreglo;`+'\"}');
                             $$ = ['','','',''];
                         }
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar un tamaño  de tipo ${u[0]};`+'\"}');
                        $$ = ['','','',''];
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error Semantico en la linea: ${(yylineno+1)}, no puedes asignar arreglo a una variable de tipo ${n.tipo};`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error Semantico en la linea: ${(yylineno+1)}, no puedes asignarle un valor a una constante;`+'\"}');
                $$ = ['','','',''];
            }

        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error Semantico en la linea: ${(yylineno+1)}, no existe la variable ${$1};`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IDENT '=' AssignmentExpr
    {
        console.log($3[6]);
        var n = tab.getPositionAmbito($1);
        if(n!=null)
        {
            if($3[0].toString().toUpperCase() != '')
            {
                if(n.rol.toUpperCase() == 'ARREGLO')
                {
                    if($3[0] == 'ARREGLO')
                    {
                        var val = $3[6].toString();
                        var valor = '';
                        var temp = Temp.getTemporal();
                        if(n.entorno == 'global')
                        {
                            valor += temp + ' = heap[' + n.position + '];';
                            valor += '\n';
                        }
                        else
                        {
                            valor += temp + ' = stack[' + n.position + '];';
                            valor += '\n';
                        }
                        var temp1 = Temp.getTemporal();
                        var temp0 = Temp.getTemporal();
                        valor += temp1 + ' = heap[(int)' + temp + '];';
                        valor += '\n';

                        var temp2 = Temp.getTemporal();
                        valor += temp2 + ' = '+ $3[7] + ';';
                        valor += '\n';
                        valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                        valor += '\n';
                        valor += $3[1] + ' = ' + temp1 + ';';
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        n.valor = $3[6];
                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp1;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';

                        $3[6].name = n.name;

                        for(var m =0; m<arr.valores.length;m++)
                        {
                            if(arr.valores[m].name == n.name)
                            {
                                arr.valores[m] = $3[6];
                            }
                        }

                        var k = tab.update(n.name,n);
                        if(k)
                        {
                            $$ = r;
                        }
                        else
                        {
                            errores.push('{\"valor\":\"'+`Error, linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                            $$ = ['','','',''];
                        }
                    }

                }
                else if($3[0].toUpperCase() == n.tipo.toUpperCase())
                {
                    switch($3[0].toString().toUpperCase())
                    {
                        case "STRING":
                            var val = $3[6].toString();
                            var valor = '';
                            var temp = Temp.getTemporal();
                            if(n.entorno == 'global')
                            {
                                 valor += temp + ' = heap[' + n.position + '];';
                                 valor += '\n';
                            }
                            else
                            {
                                 valor += temp + ' = stack[' + n.position + '];';
                                 valor += '\n';
                            }

                            var temp1 = Temp.getTemporal();
                            valor += `${temp} = ${temp} + 1;\n`;
                            //valor += temp1 + ' = '+ $3[7] + ';';
                            valor += '\n';
                            //valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                            valor += '\n';
                            valor += $3[1] + ' = ' + temp + ';';
                            valor += '\n';
                            valor += $3[3]+ '\n';

                            var r = [];
                            r[3] = valor;
                            r[0] = '';
                            r[1] = temp;
                            r[2] = '';
                            r[4] = '';
                            r[5] = '';
                            r[6] = '';
                            r[7] = '';


                            n.valor = $3[6];
                            var k = tab.update(n.name,n);
                            if(k)
                            {
                                $$ = r;
                            }
                            else
                            {
                                errores.push('{\"valor\":\"'+`Error, linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                                $$ = ['','','',''];
                            }
                            break;

                        case "NUMBER":
                            var valor = '';
                            var temp = Temp.getTemporal();
                            valor += $3[3];
                            valor += '\n';
                            if(n.entorno == 'global')
                            {
                                valor += 'heap['+ n.position + '] = ' + $3[1] +';';
                                valor += '\n';
                            }
                            else
                            {
                                valor += 'stack['+ n.position + '] = ' + $3[1] +';';
                                valor += '\n';
                            }

                            var r = [];
                            r[3] = valor;
                            r[0] = '';
                            r[1] = temp;
                            r[2] = '';
                            r[4] = '';
                            r[5] = '';
                            r[6] = '';
                            r[7] = '';


                            n.valor = $3[6];
                            var k = tab.update(n.name,n);
                            if(k)
                            {
                                $$ = r;
                            }
                            else
                            {
                                errores.push('{\"valor\":\"'+`Error, linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                                $$ = ['','','',''];
                            }
                            break;

                        case 'BOOLEAN':
                            var valor = '';
                            var temp = Temp.getTemporal();
                            valor += $3[3];
                            valor += '\n';
                            if(n.entorno == 'global')
                            {
                                valor += 'heap['+ n.position + '] = ' + $3[1] +';';
                                valor += '\n';
                            }
                            else
                            {
                                valor += 'stack['+ n.position + '] = ' + $3[1] +';';
                                valor += '\n';
                            }

                            var r = [];
                            r[3] = valor;
                            r[0] = '';
                            r[1] = temp;
                            r[2] = '';
                            r[4] = '';
                            r[5] = '';
                            r[6] = '';
                            r[7] = '';


                            n.valor = $3[6];
                            var k = tab.update(n.name,n);
                            if(k)
                            {
                                $$ = r;
                            }
                            else
                            {
                                errores.push('{\"valor\":\"'+`Error, linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                                $$ = ['','','',''];
                            }
                            break;

                        case "FLOAT":
                            var valor = '';
                            var temp = Temp.getTemporal();
                            valor += $3[3];
                            valor += '\n';
                            if(n.entorno == 'global')
                            {
                                valor += 'heap['+ n.position + '] = ' + $3[1] +';';
                                valor += '\n';
                            }
                            else
                            {
                                valor += 'stack['+ n.position + '] = ' + $3[1] +';';
                                valor += '\n';
                            }

                            var r = [];
                            r[3] = valor;
                            r[0] = '';
                            r[1] = temp;
                            r[2] = '';
                            r[4] = '';
                            r[5] = '';
                            r[6] = '';
                            r[7] = '';


                            n.valor = $3[6];
                            var k = tab.update(n.name,n);
                            if(k)
                            {
                                $$ = r;
                            }
                            else
                            {
                                errores.push('{\"valor\":\"'+`Error, linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                                $$ = ['','','',''];
                            }
                            break;
                        DEFAULT:
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$3[0]}, a una variable de tipo arreglo;`+'\"}');
                            $$ = ['','','',''];

                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$3[0]}, a una variable de tipo ${n.tipo};`+'\"}');
                    $$ = ['','','',''];
                }

            }
            else if($3[0] == '')
            {
                 var n1 = tab.getPositionAmbito($3[4]);
                 if(n1!=null)
                 {
                     if(n1.tipo.toUpperCase()!='')
                     {
                        if(n1.tipo.toUpperCase() == n.tipo.toUpperCase())
                        {
                             switch(n1.tipo.toUpperCase())
                             {
                                 case 'STRING':
                                     var valor = '';
                                      var temp = Temp.getTemporal();

                                      if(n.entorno == 'global')
                                      {
                                          valor += temp + ' = heap[' + n.position + '];';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += temp + ' = stack[' + n.position + '];';
                                          valor += '\n';
                                      }

                                      valor += temp + ' = ' + temp + ' + 1;\n';

                                      var temp2 = Temp.getTemporal();
                                      valor += temp2 + ' = '+ n1.valor.length + ';';
                                      valor += '\n';
                                      valor += 'heap[(int)'+temp+'] = ' + temp2 + ';';
                                      valor += '\n';

                                     for(var a = 0; a<n1.valor.length; a++)
                                     {
                                         valor += temp + ' = ' + temp + ' + 1;';
                                         valor += '\n';
                                         valor += 'heap[(int)'+temp+'] = ' + n1.valor.charCodeAt(a) + ';';
                                         valor += '\n'
                                     }

                                    var r = [];
                                    r[3] = valor;
                                    r[0] = '';
                                    r[1] = temp;
                                    r[2] = '';
                                    r[4] = '';
                                    r[5] = '';
                                    r[6] = '';
                                    r[7] = '';

                                    n.valor = n1.valor;
                                    var k = tab.update(n.name,n);
                                    if(k)
                                    {
                                        $$ = r;
                                    }
                                    else
                                    {
                                        errores.push('{\"valor\":\"'+`Error, linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                                        $$ = ['','','',''];
                                    }
                                   break;

                                 case 'NUMBER':
                                      var valor = '';
                                      var temp = Temp.getTemporal();
                                      valor += temp + ' = ' + n.position + ';';
                                      valor += '\n';
                                      var temp1 = Temp.getTemporal();
                                      if(n1.rol == 'Parametro')
                                      {
                                        valor += `${temp1} = ${n1.valor};\n`;
                                      }
                                      else
                                      {
                                          if(n1.entorno == 'global')
                                          {
                                              valor += temp1 + ' = heap['+n1.position+'];';
                                              valor += '\n';
                                          }
                                          else
                                          {
                                              valor += temp1 + ' = stack['+n1.position+'];';
                                              valor += '\n';
                                          }
                                      }

                                      if(n.entorno == 'global')
                                      {
                                          valor += 'heap[(int)'+ temp + '] = ' + temp1 +';';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                          valor += '\n';
                                      }

                                      var r = [];
                                      r[3] = valor;
                                      r[0] = '';
                                      r[1] = temp;
                                      r[2] = '';
                                      r[4] = '';
                                      r[5] = '';
                                      r[6] = '';
                                      r[7] = '';


                                        n.valor = n1.valor;
                                        var k = tab.update(n.name,n);
                                        if(k)
                                        {
                                            $$ = r;
                                        }
                                        else
                                        {
                                            errores.push('{\"valor\":\"'+`Error, linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                                            $$ = ['','','',''];
                                        }
                                      break;
                                 case 'BOOLEAN':
                                      var valor = '';
                                      var temp = Temp.getTemporal();
                                      valor += temp + ' = ' + n.position + ';';
                                      valor += '\n';
                                      var temp1 = Temp.getTemporal();
                                      if(n1.rol == 'Parametro')
                                      {
                                        valor += `${temp1} = ${n1.valor};\n`;
                                      }
                                      else
                                      {
                                          if(n1.entorno == 'global')
                                          {
                                              valor += temp1 + ' = heap['+n1.position+'];';
                                              valor += '\n';
                                          }
                                          else
                                          {
                                              valor += temp1 + ' = stack['+n1.position+'];';
                                              valor += '\n';
                                          }
                                      }

                                      if(n.entorno == 'global')
                                      {
                                          valor += 'heap[(int)'+ temp + '] = ' + temp1 +';';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                          valor += '\n';
                                      }

                                      var r = [];
                                      r[3] = valor;
                                      r[0] = '';
                                      r[1] = temp;
                                      r[2] = '';
                                      r[4] = '';
                                      r[5] = '';
                                      r[6] = '';
                                      r[7] = '';

                                        n.valor = n1.valor;
                                        var k = tab.update(n.name,n);
                                        if(k)
                                        {
                                            $$ = r;
                                        }
                                        else
                                        {
                                            errores.push('{\"valor\":\"'+`Error, linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                                            $$ = ['','','',''];
                                        }
                                      break;
                                 DEFAULT:
                                  semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$3[0]}.;`+'\"}');
                                  $$ = ['','','',''];
                                  break;
                             }
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$3[0]}, a una variable de tipo ${n.tipo};`+'\"}');
                            $$ = ['','','',''];
                        }
                     }
                     else
                     {
                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$3[0]}, a una variable de tipo ${n.tipo};`+'\"}');
                         $$ = ['','','',''];
                     }

                 }
                 else
                 {
                     semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$3[0]}, a una variable de tipo ${n.tipo};`+'\"}');
                     $$ = ['','','',''];
                 }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$3[6]}, a una variable de tipo ${n.tipo};`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe una variable con el nombre ${$1};`+'\"}');
            $$ = ['','','',''];
        }
    }
    | Expr1_statements
    {
        $$ = $1;
    }
;

Declaration_statements
    : IDENT Arguments
    {
        if($2[0] == '')
        {
            var n = tab.getFuncion($1);
            if(n!=null)
            {
                if(n.params == 0)
                {
                    var valor = '';
                    var r = [];
                    valor += `P = P + ${params+1};\n`;
                    valor += `${$1}();\n`;
                    var temp = Temp.getTemporal();
                    var temp1 = Temp.getTemporal();
                    valor += `${temp} = P + ${n.params};\n`;
                    valor += `${temp1} = stack[(int)${temp}];\n`;
                    valor += `P = P - ${params+1};\n`;
                    r[0] = 'FUNCION';
                    r[1] = temp1;
                    r[2] = '';
                    r[3] = valor;
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la funcion:  ${$1}.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else
        {
            var pams = $2[1];
            var n = tab.getFuncion($1);
            if(n!=null)
            {
                if(pams.length == n.params)
                {
                    var valor = '';
                    var r = [];
                    valor += `P = P + ${params+1};\n`;

                    var posk = 0;
                    var p = true;
                    for(let arg of pams)
                    {
                        var temp = Temp.getTemporal();

                        if(arg[0] != '')
                        {
                            valor += arg[3] + '\n';
                            valor += `${temp} = P + ${posk};\n`;
                            valor += `stack[(int)${temp}] = ${arg[1]};\n`;
                        }
                        else
                        {
                            var nn = tab.getPositionAmbito(arg[4]);
                            if(nn!= null)
                            {
                                if(nn.tipo.toUpperCase() != 'STRING' && nn.tipo.toUpperCase() != 'ARREGLO')
                                {
                                    if(nn.rol == 'Parametro')
                                    {
                                        valor += `${temp} = P + ${posk};\n`;
                                        valor += `stack[(int)${temp}] = ${nn.valor};\n`;
                                    }
                                    else
                                    {
                                        var temp1 = Temp.getTemporal();

                                        if(nn.entorno == 'global')
                                        {
                                             valor += `${temp} = P + ${posk};\n`;
                                             valor += `${temp1} = heap[${nn.position}];\n`;
                                             valor += `stack[(int)${temp}] = ${temp1};\n`;
                                        }
                                        else
                                        {
                                            valor += `${temp} = P + ${posk};\n`;
                                             valor += `${temp1} = stack[${nn.position}];\n`;
                                             valor += `stack[(int)${temp}] = ${temp1};\n`;
                                        }
                                    }
                                }
                                else
                                {
                                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, funcion:  ${$1[4]}, no implementado :c.`+'\"}');
                                    $$ = ['','','',''];
                                    p = false;
                                    break;
                                }
                            }
                            else
                            {
                                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, funcion:  ${$1[4]}, invalida.`+'\"}');
                                $$ = ['','','',''];
                                p = false;
                                break;
                            }
                        }
                        posk++;
                    }

                    if(p)
                    {
                        valor += `${$1}();\n`;
                        var temp = Temp.getTemporal();
                        var temp1 = Temp.getTemporal();
                        valor += `${temp} = P + ${n.params};\n`;
                        valor += `${temp1} = stack[(int)${temp}];\n`;
                        valor += `P = P - ${params+1};\n`;
                        r[0] = 'FUNCION';
                        r[1] = temp1;
                        r[2] = '';
                        r[3] = valor;
                        $$ = r;
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, funcion:  ${$1}, invalida.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la funcion:  ${$1}.`+'\"}');
                $$ = ['','','',''];
            }
        }
    }
    | TypeV IDENT ':' TypeV
    {
        var s =  eval('$$');
        var posd = -1;
        var att = false;
        var att1 = false;
        var att2 = false;
        var att3 = false;
        var att4 = false;
        for(var a = 0; a<s.length; a++)
        {
            if(s[a] != null)
            {
                if(s[a] == ('function') && !func)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    func = !func;
                    var name = '';
                    if(posd!=-1) name = s[posd];
                    entorno = 'function_'+name;
                    break;
                }
                else if( s[a] == 'if' && !ifs)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_if';
                    ifs = !ifs;
                    if(att) att = !att;
                    break;
                }
                else if( s[a] == 'if' && ifs )
                {
                    att = true;
                    ifs = !ifs;
                }
                else if( s[a] == 'while' && !whiles)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_while';
                    whiles = !whiles;
                    if(att1) att1 = !att1;
                    break;
                }
                else if( s[a] == 'whiles' && whiles )
                {
                    att1 = true;
                    whiles = !whiles;
                }
                else if( s[a].toString().toLowerCase() == 'do' && !does)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_do';
                    does = !does;
                    if(att3) att3 = !att3;
                    break;
                }
                else if( s[a].toString().toLowerCase() == 'do' && does )
                {
                    att3 = true;
                    does = !does;
                }
                else if( s[a] == 'switch' && !switches)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_switch';
                    switches = !switches;
                    if(att4) att4 = !att4;
                    break;
                }
                else if( s[a] == 'switch' && switches )
                {
                    att4 = true;
                    switches = !switches;
                }
            }
        }
        if(att)
        {
            ifs = !ifs;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att1)
        {
            whiles = !whiles;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att3)
        {
            does = !does;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att4)
        {
            switches = !switches;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        var n = tab.getPositionAmbito($2);
        var pass = false;
        if(n==null)
        {
            pass = true;
        }
        else
        {
            if(n.ambito < tab.ambitoLevel) pass = true;
            if(n.rol == 'Parametro') pass = false;
        }

        if(pass)
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
                var posicion = -1;
                if(entorno == 'global')
                {
                    posicion = pos;
                    valor += temp1 + ' = ' + pos +';';
                    valor += '\n';
                    pos++;
                }
                else
                {
                    posicion = stac;
                    valor += temp1 + ' =  P;';
                    valor += '\n';
                    valor += 'P = P + 1;\n';
                    stac++;
                }
                //valor += temp1 + ' = ' + pos +';';
                //valor += '\n';
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

                if(entorno == 'global')
                {
                    valor += '\n';
                    valor += 'heap[(int)' + temp1 + '] = ' + temp2 +';';
                }
                else
                {
                    valor += '\n';
                    valor += 'stack[(int)' + temp1 + '] = ' + temp2 +';';
                }


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
                sym.position = posicion;
                sym.rol = 'variable';
                sym.direccion = posicion;
                sym.direccionrelativa = posicion;
                if(entorno != 'global')
                {
                    sym.entorno = entorno;
                }
                sym.tipo = $4;
                sym.valor = null;
                tab.insert(sym);
                $$ = r;
                //if(pos >0 && pos != 0) pos++;
                //if (pos == 0) pos++;
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
        var s =  eval('$$');
        var posd = -1;
        var att = false;
        var att1 = false;
        var att2 = false;
        var att3 = false;
        var att4 = false;
        for(var a = 0; a<s.length; a++)
        {
            if(s[a] != null)
            {
                if(s[a] == ('function') && !func)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    func = !func;
                    var name = '';
                    if(posd!=-1) name = s[posd];
                    entorno = 'function_'+name;
                    break;
                }
                else if( s[a] == 'if' && !ifs)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_if';
                    ifs = !ifs;
                    if(att) att = !att;
                    break;
                }
                else if( s[a] == 'if' && ifs )
                {
                    att = true;
                    ifs = !ifs;
                }
                else if( s[a] == 'while' && !whiles)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_while';
                    whiles = !whiles;
                    if(att1) att1 = !att1;
                    break;
                }
                else if( s[a] == 'whiles' && whiles )
                {
                    att1 = true;
                    whiles = !whiles;
                }
                else if( s[a].toString().toLowerCase() == 'do' && !does)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_do';
                    does = !does;
                    if(att3) att3 = !att3;
                    break;
                }
                else if( s[a].toString().toLowerCase() == 'do' && does )
                {
                    att3 = true;
                    does = !does;
                }
                else if( s[a] == 'switch' && !switches)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_switch';
                    switches = !switches;
                    if(att4) att4 = !att4;
                    break;
                }
                else if( s[a] == 'switch' && switches )
                {
                    att4 = true;
                    switches = !switches;
                }
            }
        }

        if(att)
        {
            ifs = !ifs;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att1)
        {
            whiles = !whiles;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att3)
        {
            does = !does;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att4)
        {
            switches = !switches;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        var n = tab.getPositionAmbito($2);
        var pass = false;
        if(n==null)
        {
            pass = true;
        }
        else
        {
            if(n.ambito < tab.ambitoLevel) pass = true;
            if(n.rol == 'Parametro') pass = false;
        }

        if(pass)
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
                var posicion = -1;
                if(entorno == 'global')
                {
                    posicion = pos;
                    valor += temp1 + ' = ' + pos +';';
                    valor += '\n';
                    pos++;
                }
                else
                {
                    posicion = stac;
                    valor += temp1 + ' =  P;';
                    valor += '\n';
                    valor += 'P = P + 1;\n';
                    stac++;
                }
                //valor += temp1 + ' = ' + pos +';';
                //valor += '\n';
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
                if(entorno == 'global')
                {
                    valor += 'heap[(int)' + temp1 + '] = ' + temp2 +';\n';
                }
                else
                {
                    valor += 'stack[(int)' + temp1 + '] = ' + temp2 +';\n';
                }


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
                sym.position = posicion;
                sym.rol = 'variable';
                sym.direccion = posicion;
                sym.direccionrelativa = posicion;
                sym.tipo = '';
                sym.valor = null;
                if(entorno != 'global')
                {
                    sym.entorno = entorno;
                }
                tab.insert(sym);
                $$ = r;
                //if(pos >0 && pos != 0) pos++;
                //if (pos == 0) pos++;
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, ya existe una variable con el nombre ${$2};`+'\"}');
            $$ = ['','','',''];
        }
    }
    | TypeV IDENT  ':' TypeV Array '=' AssignmentExpr
    {

        var s =  eval('$$');
        var posd = -1;
        var att = false;
        var att1 = false;
        var att2 = false;
        var att3 = false;
        var att4 = false;
        for(var a = 0; a<s.length; a++)
        {
            if(s[a] != null)
            {
                if(s[a] == ('function') && !func)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    func = !func;
                    var name = '';
                    if(posd!=-1) name = s[posd];
                    entorno = 'function_'+name;
                    break;
                }
                else if( s[a] == 'if' && !ifs)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_if';
                    ifs = !ifs;
                    if(att) att = !att;
                    break;
                }
                else if( s[a] == 'if' && ifs )
                {
                    att = true;
                    ifs = !ifs;
                }
                else if( s[a] == 'while' && !whiles)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_while';
                    whiles = !whiles;
                    if(att1) att1 = !att1;
                    break;
                }
                else if( s[a] == 'whiles' && whiles )
                {
                    att1 = true;
                    whiles = !whiles;
                }

                else if( s[a].toString().toLowerCase() == 'do' && !does)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_do';
                    does = !does;
                    if(att3) att3 = !att3;
                    break;
                }
                else if( s[a].toString().toLowerCase() == 'do' && does )
                {
                    att3 = true;
                    does = !does;
                }
                else if( s[a] == 'switch' && !switches)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_switch';
                    switches = !switches;
                    if(att4) att4 = !att4;
                    break;
                }
                else if( s[a] == 'switch' && switches )
                {
                    att4 = true;
                    switches = !switches;
                }
            }
        }
        if(att)
        {
            ifs = !ifs;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att1)
        {
            whiles = !whiles;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        if(att3)
        {
            does = !does;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att4)
        {
            switches = !switches;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        var n = tab.getPositionAmbito($2);
        var pass = false;
        if(n==null)
        {
            pass = true;
        }
        else
        {
            if(n.ambito < tab.ambitoLevel) pass = true;
            if(n.rol == 'Parametro') pass = false;
        }

        if(pass)
        {
            if($7[0].toString().toUpperCase() != '')
            {
                switch($7[0].toString().toUpperCase())
                {
                    case 'ARREGLO':
                        if($7[8].toUpperCase() == $4.toUpperCase())
                        {
                            var valor = '';
                            var temp = Temp.getTemporal();
                            var posicion = -1;
                            if(entorno == 'global')
                            {
                                posicion = pos;
                                valor += temp + ' = ' + pos +';';
                                valor += '\n';
                                pos++;
                            }
                            else
                            {
                                posicion = stac;
                                valor += `${temp} =  ${posicion};\n`;
                                stac++;
                            }
                            //valor += temp + ' = ' + pos + ';';
                            //valor += '\n';

                            var temp1 = Temp.getTemporal();
                            var temp0 = Temp.getTemporal();
                            valor += temp1 + ' = ' + posA + ';';
                            valor += '\n';
                            valor += temp0+ ' = ' + posA + ';\n';
                            if(entorno == 'global')
                            {
                                valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                            }
                            else
                            {
                                valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                            }
                            //valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                            valor += '\n';
                            valor += temp1 + ' = ' + temp1 + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';\n';
                            var temp2 = Temp.getTemporal();
                            valor += temp2 + ' = '+ $7[7] + ';';
                            valor += '\n';
                            valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                            valor += '\n';
                            valor += $7[1] + ' = ' + temp1 + ';';
                            valor += '\n';
                            valor += $7[3];
                            valor += '\n';

                             var sym = new intermedia.simbolo();
                             sym.ambito = tab.ambitoLevel;
                             sym.name = $2;
                             sym.position = posicion;
                             sym.rol = 'arreglo';
                             sym.direccion = posicion;
                             sym.direccionrelativa = posicion;
                             sym.tipo = ($4[8]!='')?$7[8]:$4[0];
                             sym.valor = $7[6];
                             sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                             if(entorno != 'global')
                             {
                                 sym.entorno = entorno;
                             }
                             tab.insert(sym);

                            var r = [];
                            r[3] = valor;
                            r[0] = '';
                            r[1] = temp3;
                            r[2] = '';
                            r[4] = '';
                            r[5] = '';
                            r[6] = '';
                            r[7] = '';
                            $7[6].name = $2;

                            var a = new intermedia.arreglo()
                            a.name = $2;
                            a.tipo = ($4[8]!='')?$7[8]:$4[0];
                            a.positions = $7[6].positions;
                            a.c3d = valor;
                            a.valor = $7[6].valor;
                            a.temporal = temp3;
                            a.bandera = '';

                            arr.insert(a);


                            $$ = r;

                            //if(pos >0 && pos != 0) pos++;
                            //if (pos == 0) pos++;
                            posA += 5000;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$7[8]}, a una variable de tipo ${$4};`+'\"}');
                            $$ = ['','','','']
                        }

                        break;

                    DEFAULT:
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$7[0]}, a una variable de tipo ${$4};`+'\"}');
                        $$ = ['','','',''];
                        break;

                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$7[6]}, a una variable de tipo ${$4};`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, ya existe una variable con el nombre ${$2};`+'\"}');
            $$ = ['','','',''];
        }
    }
    | TypeV IDENT  ':' TypeV Array '=' NEWT ARRAYS '(' Expr ')'
    {

        var s =  eval('$$');
        var posd = -1;
        var att = false;
        var att1 = false;
        var att2 = false;
        var att3 = false;
        var att4 = false;
        for(var a = 0; a<s.length; a++)
        {
            if(s[a] != null)
            {
                if(s[a] == ('function') && !func)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    func = !func;
                    var name = '';
                    if(posd!=-1) name = s[posd];
                    entorno = 'function_'+name;
                    break;
                }
                else if( s[a] == 'if' && !ifs)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_if';
                    ifs = !ifs;
                    if(att) att = !att;
                    break;
                }
                else if( s[a] == 'if' && ifs )
                {
                    att = true;
                    ifs = !ifs;
                }
                else if( s[a] == 'while' && !whiles)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_while';
                    whiles = !whiles;
                    if(att1) att1 = !att1;
                    break;
                }
                else if( s[a] == 'whiles' && whiles )
                {
                    att1 = true;
                    whiles = !whiles;
                }
                else if( s[a].toString().toLowerCase() == 'do' && !does)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_do';
                    does = !does;
                    if(att3) att3 = !att3;
                    break;
                }
                else if( s[a].toString().toLowerCase() == 'do' && does )
                {
                    att3 = true;
                    does = !does;
                }
                else if( s[a] == 'switch' && !switches)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_switch';
                    switches = !switches;
                    if(att4) att4 = !att4;
                    break;
                }
                else if( s[a] == 'switch' && switches )
                {
                    att4 = true;
                    switches = !switches;
                }
            }
        }
        if(att)
        {
            ifs = !ifs;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att1)
        {
            whiles = !whiles;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        if(att3)
        {
            does = !does;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att4)
        {
            switches = !switches;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        var n = tab.getPositionAmbito($2);
        var pass = false;
        if(n==null)
        {
            pass = true;
        }
        else
        {
            if(n.ambito < tab.ambitoLevel) pass = true;
            if(n.rol == 'Parametro') pass = false;
        }

        if(pass)
        {
                var temp1 = Temp.getTemporal();

                var u = $10;
                if(u[0].toUpperCase() == 'NUMBER')
                {
                    var valor = '';
                    valor += u[3];
                    valor += '\n';
                    var posicion = -1;
                    if(entorno == 'global')
                    {
                        posicion = pos;
                        valor += temp1 + ' = ' + pos +';';
                        valor += '\n';
                        pos++;
                    }
                    else
                    {
                        posicion = stac;
                        valor += temp1 + ' =  P;';
                        valor += '\n';
                        valor += 'P = P + 1;\n';
                        stac++;
                    }
                    //valor += temp1 + ' = ' + pos +';';
                    //valor += '\n';
                    var temp2 = Temp.getTemporal();
                    valor += temp2 + ' = '+posA+';';
                    valor += '\n';
                    if(entorno == 'global')
                    {
                        valor += 'heap[(int)' + temp1 + '] = ' + temp2 +';';
                        valor += '\n';
                    }
                    else
                    {
                        valor += 'stack[(int)' + temp1 + '] = ' + temp2 +';\n';
                    }
                    //valor += 'stack[(int)' + temp1 + '] = ' + temp2 +';';
                    //valor += '\n';
                    valor += 'heap[(int)' + temp2 + '] = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor = valor  + temp2 + ' = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor += 'heap[(int)' + temp2 + '] = ' + u[1] + ';';
                    valor += '\n';
                    var temp3 = Temp.getTemporal();
                    valor += temp3 + ' = 1;';
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
                    valor += '\t' + 'heap[(int)'+temp2+'] = -1;';
                    valor += '\n';
                    valor += '\t' + 'goto ' + label + ';';
                    valor += '\n';
                    valor += label1 + ': ';

                    var a = new intermedia.arreglo()
                    a.name = $2;
                    a.tipo = $4;
                    a.positions.push(u[6]);
                    a.c3d = valor;
                    a.temporal = temp3;
                    a.bandera = label1;

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
                    sym.position = posicion;
                    sym.rol = 'arreglo';
                    sym.direccion = posicion;
                    sym.direccionrelativa = posicion;
                    sym.tipo = $4;
                    sym.valor = a;
                    sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                    if(entorno != 'global')
                    {
                        sym.entorno = entorno;
                    }
                    tab.insert(sym);

                    $$ = r;

                    arr.insert(a);

                    //if(pos >0 && pos != 0) pos++;
                    //if (pos == 0) pos++;
                    posA += 5000;
                }
                else if(u[0] == '')
                {
                     var n = tab.getPositionAmbito(u[4]);
                     if(n!=null)
                     {
                         if(n.tipo.toUpperCase()!='')
                         {
                             switch(n.tipo.toUpperCase())
                             {
                                 case 'NUMBER':
                                    var valor = '';
                                    var temp0 = Temp.getTemporal();
                                    valor += temp0 + ' = ' + n.position + ';\n';
                                    var temp0_1 = Temp.getTemporal();
                                    if(n.rol == 'Parametro')
                                    {
                                        valor += temp0_1 + ' = ' +n.valor + ';\n';
                                    }
                                    else
                                    {
                                        if(n.entorno == 'global')
                                        {
                                             valor += temp0_1 + ' = heap[(int)'+temp0+'];';
                                        }
                                        else
                                        {
                                             valor += temp0_1 + ' = stack[(int)'+temp0+'];';
                                        }
                                    }
                                    valor += '\n';
                                    var posicion = -1;
                                    if(entorno == 'global')
                                    {
                                        posicion = pos;
                                        valor += temp1 + ' = ' + pos +';';
                                        valor += '\n';
                                        pos++;
                                    }
                                    else
                                    {
                                        posicion = stac;
                                        valor += temp1 + ' =  P;';
                                        valor += '\n';
                                        valor += 'P = P + 1;\n';
                                        stac++;
                                    }
                                    //valor += temp1 + ' = ' + pos +';';
                                    //valor += '\n';
                                    var temp2 = Temp.getTemporal();
                                    valor += temp2 + ' = '+posA+';';
                                    valor += '\n';
                                    if(entorno == 'global')
                                    {
                                        valor += 'heap[(int)' + temp1 + '] = ' + temp2 +';';
                                        valor += '\n';
                                    }
                                    else
                                    {
                                        valor += 'stack[(int)' + temp1 + '] = ' + temp2 +';';
                                        valor += '\n';
                                    }
                                    //valor += 'stack[(int)' + temp1 + '] = ' + temp2 +';';
                                    //valor += '\n';
                                    valor += 'heap[(int)' + temp2 + '] = ' + temp2 + ' + 1;';
                                    valor += '\n';
                                    valor = valor  + temp2 + ' = ' + temp2 + ' + 1;';
                                    valor += '\n';
                                    valor += 'heap[(int)' + temp2 + '] = ' + temp0_1 + ';';
                                    valor += '\n';
                                    var temp3 = Temp.getTemporal();
                                    valor += temp3 + ' = 1;';
                                    valor += '\n';
                                    var label = Label.getBandera();
                                    var label1 = Label.getBandera();
                                    valor += label + ': ';
                                    valor += '\n';
                                    valor += '\t' + 'if( ' + temp3 + ' == ' + temp0_1 + ' ) goto ' + label1 + ';';
                                    valor += '\n';
                                    valor += '\t' + temp2 + ' = ' + temp2 + ' + 1;';
                                    valor += '\n';
                                    valor += '\t' + temp3 + ' = ' + temp3 + ' + 1;';
                                    valor += '\n';
                                    valor += '\t' + 'heap[(int)'+temp2+'] = -1;';
                                    valor += '\n';
                                    valor += '\t' + 'goto ' + label + ';';
                                    valor += '\n';
                                    valor += label1 + ': ';

                                    var a = new intermedia.arreglo()
                                    a.name = $2;
                                    a.positions.push(n.valor);
                                    a.c3d = valor;
                                    a.temporal = temp3;
                                    a.bandera = label1;
                                    a.tipo = $1;

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
                                    sym.position = posicion;
                                    sym.rol = 'arreglo';
                                    sym.direccion = posicion;
                                    sym.direccionrelativa = posicion;
                                    sym.tipo = $1;
                                    if(entorno != 'global')
                                    {
                                        sym.entorno = entorno;
                                    }

                                    sym.valor = a;
                                    tab.insert(sym);

                                    $$ = r;

                                    arr.insert(a);

                                    //if(pos >0 && pos != 0) pos++;
                                    //if (pos == 0) pos++;
                                    posA += 5000;
                                    break;
                                 DEFAULT:
                                  semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${u[0]}, a una variable de tipo arreglo;`+'\"}');
                                  $$ = ['','','',''];
                                  break;
                             }
                         }
                         else
                         {
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${u[0]}, a una variable de tipo arreglo;`+'\"}');
                             $$ = ['','','',''];
                         }

                     }
                     else
                     {
                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${u[0]}, a una variable de tipo arreglo;`+'\"}');
                         $$ = ['','','',''];
                     }
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

    | TypeV IDENT  '=' NEWT ARRAYS '(' Expr ')'
    {

        var s =  eval('$$');
        var posd = -1;
        var att = false;
        var att1 = false;
        var att2 = false;
        var att3 = false;
        var att4 = false;
        for(var a = 0; a<s.length; a++)
        {
            if(s[a] != null)
            {
                if(s[a] == ('function') && !func)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    func = !func;
                    var name = '';
                    if(posd!=-1) name = s[posd];
                    entorno = 'function_'+name;
                    break;
                }
                else if( s[a] == 'if' && !ifs)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_if';
                    ifs = !ifs;
                    if(att) att = !att;
                    break;
                }
                else if( s[a] == 'if' && ifs )
                {
                    att = true;
                    ifs = !ifs;
                }
                else if( s[a] == 'while' && !whiles)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_while';
                    whiles = !whiles;
                    if(att1) att1 = !att1;
                    break;
                }
                else if( s[a] == 'whiles' && whiles )
                {
                    att1 = true;
                    whiles = !whiles;
                }
                else if( s[a].toString().toLowerCase() == 'do' && !does)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_do';
                    does = !does;
                    if(att3) att3 = !att3;
                    break;
                }
                else if( s[a].toString().toLowerCase() == 'do' && does )
                {
                    att3 = true;
                    does = !does;
                }
                else if( s[a] == 'switch' && !switches)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_switch';
                    switches = !switches;
                    if(att4) att4 = !att4;
                    break;
                }
                else if( s[a] == 'switch' && switches )
                {
                    att4 = true;
                    switches = !switches;
                }
            }
        }
        if(att)
        {
            ifs = !ifs;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att1)
        {
            whiles = !whiles;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        if(att3)
        {
            does = !does;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att4)
        {
            switches = !switches;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        var n = tab.getPositionAmbito($2);
        var pass = false;
        if(n==null)
        {
            pass = true;
        }
        else
        {
            if(n.ambito < tab.ambitoLevel) pass = true;
            if(n.rol == 'Parametro') pass = false;
        }

        if(pass)
        {
                var temp1 = Temp.getTemporal();

                var u = $7;
                if(u[0].toUpperCase() == 'NUMBER')
                {
                    var valor = '';
                    valor += u[3];
                    valor += '\n';
                    var posicion = -1;
                    if(entorno == 'global')
                    {
                        posicion = pos;
                        valor += temp1 + ' = ' + pos +';';
                        valor += '\n';
                        pos++;
                    }
                    else
                    {
                        posicion = stac;
                        valor += temp1 + ' =  P;';
                        valor += '\n';
                        valor += 'P = P + 1;\n';
                        stac++;
                    }

                    //valor += temp1 + ' = ' + pos +';';
                    //valor += '\n';

                    var temp2 = Temp.getTemporal();
                    valor += temp2 + ' = '+posA+';';
                    valor += '\n';
                    if(entorno == 'global')
                    {
                        valor += 'heap[(int)' + temp1 + '] = ' + temp2 +';';
                        valor += '\n';
                    }
                    else
                    {
                        valor += 'stack[(int)' + temp1 + '] = ' + temp2 +';';
                        valor += '\n';
                    }
                    //valor += 'stack[(int)' + temp1 + '] = ' + temp2 +';';
                    //valor += '\n';
                    valor += 'heap[(int)' + temp2 + '] = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor = valor  + temp2 + ' = ' + temp2 + ' + 1;';
                    valor += '\n';
                    valor += 'heap[(int)' + temp2 + '] = ' + u[1] + ';';
                    valor += '\n';
                    var temp3 = Temp.getTemporal();
                    valor += temp3 + ' = 1;';
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
                    valor += '\t' + 'heap[(int)'+temp2+'] = -1;';
                    valor += '\n';
                    valor += '\t' + 'goto ' + label + ';';
                    valor += '\n';
                    valor += label1 + ': ';

                    var a = new intermedia.arreglo()
                    a.name = $2;
                    a.positions.push(u[6]);
                    a.c3d = valor;
                    a.temporal = temp3;
                    a.bandera = label1;
                    a.tipo = $1;

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
                    sym.position = posicion;
                    sym.rol = 'arreglo';
                    sym.direccion = posicion;
                    sym.direccionrelativa = posicion;
                    sym.tipo = $1;
                    if(entorno != 'global') sym.entorno = entorno;
                    sym.valor = a;
                    tab.insert(sym);

                    $$ = r;

                    arr.insert(a);

                    //if(pos >0 && pos != 0) pos++;
                    //if (pos == 0) pos++;
                    posA += 5000;
                }
                else if(u[0] == '')
                {
                     var n = tab.getPositionAmbito(u[4]);
                     if(n!=null)
                     {
                         if(n.tipo.toUpperCase()!='')
                         {
                             switch(n.tipo.toUpperCase())
                             {
                                 case 'NUMBER':
                                    var valor = '';
                                    var temp0 = Temp.getTemporal();
                                    valor += temp0 + ' = ' + n.position + ';\n';
                                    var temp0_1 = Temp.getTemporal();
                                    if(n.rol == 'parametro')
                                    {
                                        valor += temp0_1 + ' = ' + n.valor + ';\n';
                                    }
                                    else
                                    {
                                        if(n.entorno == 'global')
                                        {
                                            valor += temp0_1 + ' = heap[(int)'+temp0+'];\n';

                                        }
                                        else
                                        {
                                            valor += temp0_1 + ' = stack[(int)'+temp0+'];\n';

                                        }
                                    }

                                    //valor += temp0_1 + ' = stack[(int)'+temp0+'];';
                                    //valor += '\n';
                                    //valor += temp1 + ' = ' + pos +';';
                                    var posicion = -1;
                                    if(entorno == 'global')
                                    {
                                        posicion = pos;
                                        valor += temp1 + ' = ' + pos +';';
                                        valor += '\n';
                                        pos++;
                                    }
                                    else
                                    {
                                        posicion = stac;
                                        valor += temp1 + ' =  P;';
                                        valor += '\n';
                                        valor += 'P = P + 1;\n';
                                        stac++;
                                    }
                                    valor += '\n';
                                    var temp2 = Temp.getTemporal();
                                    valor += temp2 + ' = '+posA+';';
                                    valor += '\n';
                                    if(entorno == 'global')
                                    {
                                        valor += 'heap[(int)' + temp1 + '] = ' + temp2 +';\n';
                                    }
                                    else
                                    {
                                        valor += 'stack[(int)' + temp1 + '] = ' + temp2 +';\n';
                                    }
                                    //valor += 'stack[(int)' + temp1 + '] = ' + temp2 +';';
                                    //valor += '\n';
                                    valor += 'heap[(int)' + temp2 + '] = ' + temp2 + ' + 1;';
                                    valor += '\n';
                                    valor = valor  + temp2 + ' = ' + temp2 + ' + 1;';
                                    valor += '\n';
                                    valor += 'heap[(int)' + temp2 + '] = ' + temp0_1 + ';';
                                    valor += '\n';
                                    var temp3 = Temp.getTemporal();
                                    valor += temp3 + ' = 1;';
                                    valor += '\n';
                                    var label = Label.getBandera();
                                    var label1 = Label.getBandera();
                                    valor += label + ': ';
                                    valor += '\n';
                                    valor += '\t' + 'if( ' + temp3 + ' == ' + temp0_1 + ' ) goto ' + label1 + ';';
                                    valor += '\n';
                                    valor += '\t' + temp2 + ' = ' + temp2 + ' + 1;';
                                    valor += '\n';
                                    valor += '\t' + temp3 + ' = ' + temp3 + ' + 1;';
                                    valor += '\n';
                                    valor += '\t' + 'heap[(int)'+temp2+'] = -1;';
                                    valor += '\n';
                                    valor += '\t' + 'goto ' + label + ';';
                                    valor += '\n';
                                    valor += label1 + ': ';

                                    var a = new intermedia.arreglo()
                                    a.name = $2;
                                    a.positions.push(n.valor);
                                    a.c3d = valor;
                                    a.temporal = temp3;
                                    a.bandera = label1;
                                    a.tipo = $1;

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
                                    sym.position = posicion;
                                    sym.rol = 'arreglo';
                                    sym.direccion = posicion;
                                    sym.direccionrelativa = posicion;
                                    sym.tipo = $1;
                                    if(entorno != 'global') sym.entorno = entorno;

                                    sym.valor = a;
                                    tab.insert(sym);

                                    $$ = r;

                                    arr.insert(a);

                                    //if(pos >0 && pos != 0) pos++;
                                    //if (pos == 0) pos++;
                                    posA += 5000;
                                    break;
                                 DEFAULT:
                                  semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${u[0]}, a una variable de tipo arreglo;`+'\"}');
                                  $$ = ['','','',''];
                                  break;
                             }
                         }
                         else
                         {
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${u[0]}, a una variable de tipo arreglo;`+'\"}');
                             $$ = ['','','',''];
                         }

                     }
                     else
                     {
                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${u[0]}, a una variable de tipo arreglo;`+'\"}');
                         $$ = ['','','',''];
                     }
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
    | TypeV IDENT ':' TypeV '=' AssignmentExpr
    {

        var s =  eval('$$');
        var posd = -1;
        var att = false;
        var att1 = false;
        var att2 = false;
        var att3 = false;
        var att4 = false;
        for(var a = 0; a<s.length; a++)
        {
            if(s[a] != null)
            {
                if(s[a] == ('function') && !func)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    func = !func;
                    var name = '';
                    if(posd!=-1) name = s[posd];
                    entorno = 'function_'+name;
                    break;
                }
                else if( s[a] == 'if' && !ifs)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_if';
                    ifs = !ifs;
                    if(att) att = !att;
                    break;
                }
                else if( s[a] == 'if' && ifs )
                {
                    att = true;
                    ifs = !ifs;
                }
                else if( s[a] == 'while' && !whiles)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_while';
                    whiles = !whiles;
                    if(att1) att1 = !att1;
                    break;
                }
                else if( s[a] == 'whiles' && whiles )
                {
                    att1 = true;
                    whiles = !whiles;
                }
                else if( s[a].toString().toLowerCase() == 'do' && !does)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_do';
                    does = !does;
                    if(att3) att3 = !att3;
                    break;
                }
                else if( s[a].toString().toLowerCase() == 'do' && does )
                {
                    att3 = true;
                    does = !does;
                }
                else if( s[a] == 'switch' && !switches)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_switch';
                    switches = !switches;
                    if(att4) att4 = !att4;
                    break;
                }
                else if( s[a] == 'switch' && switches )
                {
                    att4 = true;
                    switches = !switches;
                }
            }
        }
        if(att)
        {
            ifs = !ifs;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att1)
        {
            whiles = !whiles;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        if(att3)
        {
            does = !does;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att4)
        {
            switches = !switches;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        var n = tab.getPositionAmbito($2);
        var pass = false;
        if(n==null)
        {
            pass = true;
        }
        else
        {
            if(n.ambito < tab.ambitoLevel) pass = true;
            if(n.rol == 'Parametro') pass = false;
        }

        if(pass)
        {
            if($4.toUpperCase() == $6[0].toUpperCase())
            {
                switch($4.toUpperCase())
                {
                    case "STRING":
                        var val = $6[6].toString();
                        var valor = '';
                        var temp = Temp.getTemporal();
                        var posicion = -1;
                        if(entorno == 'global')
                        {
                            posicion = pos;
                            valor += temp + ' = ' + pos +';';
                            valor += '\n';
                            pos++;
                        }
                        else
                        {
                            posicion = stac;
                            valor += `${temp} =  ${posicion};\n`;
                            stac++;
                        }
                        //valor += temp + ' = ' + pos + ';';
                        var temp0 = Temp.getTemporal();
                        valor += '\n';
                        var temp1 = Temp.getTemporal();
                        valor += temp1 + ' = ' + posS + ';\n';
                        valor += temp0 + ' = ' + posS + ';';
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                            valor += '\n';
                        }
                       // valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                        //valor += '\n';

                        valor += temp1 + ' = ' + temp1 + ' + 1;';
                        valor += '\n';
                        valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';\n';
                        var temp2 = Temp.getTemporal();
                        valor += temp2 + ' = '+ val.length + ';';
                        valor += '\n';
                        valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                        valor += '\n';
                        valor += $6[1] + ' = ' + temp1 + ';';
                        valor += '\n';
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
                        sym.position = posicion;
                        sym.rol = 'variable';
                        sym.direccion = posicion;
                        sym.direccionrelativa = posicion;
                        sym.tipo = $4;
                        sym.valor = $6[6];
                        sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                        if(entorno != 'global') sym.entorno = entorno;
                        tab.insert(sym);

                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        posS += 5000;
                        break;

                    case "NUMBER":
                        var valor = '';
                        var temp = Temp.getTemporal();
                        var posicion = -1;
                        if(entorno == 'global')
                        {
                            posicion = pos;
                            valor += temp + ' = ' + pos +';';
                            valor += '\n';
                            pos++;
                        }
                        else
                        {
                            posicion = stac;
                            valor += `${temp} =  ${posicion};\n`;
                            stac++;
                        }
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                        valor += $6[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = ' + $6[1] +';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $6[1] +';';
                            valor += '\n';
                        }

                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = $4;
                         sym.valor = $6[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp3;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;

                    case 'BOOLEAN':
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                        var posicion = -1;
                        if(entorno == 'global')
                        {
                            posicion = pos;
                            valor += temp + ' = ' + pos +';';
                            valor += '\n';
                            pos++;
                        }
                        else
                        {
                            posicion = stac;
                            valor += `${temp} =  ${posicion};\n`;
                            stac++;
                        }
                        valor += $6[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = ' + $6[1] +';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $6[1] +';';
                            valor += '\n';
                        }


                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = $4;
                         sym.valor = $6[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno!='global') sym.entorno = entorno;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp3;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;

                    case "FLOAT":
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                        var posicion = -1;
                        if(entorno == 'global')
                        {
                            posicion = pos;
                            valor += temp + ' = ' + pos +';';
                            valor += '\n';
                            pos++;
                        }
                        else
                        {
                            posicion = stac;
                            valor += `${temp} =  ${posicion};\n`;
                            stac++;
                        }
                        valor += $6[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = ' + $6[1] +';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $6[1] +';';
                            valor += '\n';
                        }


                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = $4;
                         sym.valor = $6[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp3;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;

                    case 'ARREGLO':
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar un arreglo, a una variable de tipo ${$4};`+'\"}');
                        $$ = ['','','',''];
                         break;
                }
            }
            else if($6[0] == '')
            {
                 var n = tab.getPositionAmbito($6[4]);
                 if(n!=null)
                 {
                     if(n.tipo.toUpperCase() == $4.toUpperCase())
                     {
                         switch(n.tipo.toUpperCase())
                         {
                             case 'STRING':
                                 var valor = '';
                                  var temp = Temp.getTemporal();
                                  //valor += temp + ' = ' + pos + ';';
                                  //valor += '\n';
                                 var posicion = -1;
                                 if(entorno == 'global')
                                 {
                                     posicion = pos;
                                     valor += temp + ' = ' + pos +';';
                                     valor += '\n';
                                     pos++;
                                 }
                                 else
                                 {
                                     posicion = stac;
                                     valor += `${temp} =  ${posicion};\n`;
                                     stac++;
                                 }



                                  if(n.rol == 'parametro')
                                  {

                                      if(entorno == 'global')
                                      {
                                          valor += 'heap[(int)'+temp+'] = ' + n.valor + ';';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += 'stack[(int)'+temp+'] = ' + n.valor + ';';
                                          valor += '\n';
                                      }

                                      valor += temp1 + ' = ' + temp1 + ' + 1;';
                                      valor += '\n';
                                      valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';\n';
                                      var temp2 = Temp.getTemporal();
                                      valor += temp2 + ' = '+ n.valor.length + ';';
                                      valor += '\n';
                                      valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                                      valor += '\n';
                                  }
                                  else
                                  {
                                    var temp1 = Temp.getTemporal();
                                    valor += temp1 + ' = ' + posS + ';';
                                    valor += '\n';
                                    var temp0 = Temp.getTemporal();
                                    valor += temp0 + ' = ' + posS + ';';
                                    valor += '\n';
                                    if(entorno == 'global')
                                    {
                                        valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                                        valor += '\n';
                                    }
                                    else
                                    {
                                        valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                                        valor += '\n';
                                    }

                                    valor += temp1 + ' = ' + temp1 + ' + 1;';
                                    valor += '\n';
                                    valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';\n';
                                    var temp2 = Temp.getTemporal();
                                    valor += temp2 + ' = '+ n.valor.length + ';';
                                    valor += '\n';
                                    valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                                    valor += '\n';
                                     for(var a = 0; a<n.valor.length; a++)
                                     {
                                         valor += temp1 + ' = ' + temp1 + ' + 1;';
                                         valor += '\n';
                                         valor += 'heap[(int)'+temp1+'] = ' + n.valor.charCodeAt(a) + ';';
                                         valor += '\n'
                                     }
                                  }


                               var r = [];
                               r[3] = valor;
                               r[0] = '';
                               r[1] = temp1;
                               r[2] = '';
                               r[4] = '';
                               r[5] = '';
                               r[6] = '';
                               r[7] = '';

                               var sym = new intermedia.simbolo();
                               sym.ambito = tab.ambitoLevel;
                               sym.name = $2;
                               sym.position = posicion;
                               sym.rol = 'variable';
                               sym.direccion = posicion;
                               sym.direccionrelativa = posicion;
                               sym.tipo = $4;
                               sym.valor = n.valor;
                               sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                               if(entorno != 'global') sym.entorno = entorno;
                               tab.insert(sym);

                               $$ = r;

                               //if(pos >0 && pos != 0) pos++;
                               //if (pos == 0) pos++;
                               posS += 5000;
                               break;

                             case 'NUMBER':
                                  var valor = '';
                                  var temp = Temp.getTemporal();
                                  //valor += temp + ' = ' + pos + ';';
                                  //valor += '\n';
                                  var posicion = -1;
                                  if(entorno == 'global')
                                  {
                                      posicion = pos;
                                      valor += temp + ' = ' + pos +';';
                                      valor += '\n';
                                      pos++;
                                  }
                                  else
                                  {
                                      posicion = stac;
                                      valor += `${temp} =  ${posicion};\n`;
                                      stac++;
                                  }



                                  if(n.rol == 'Parametro')
                                  {
                                      if(entorno == 'global')
                                      {
                                          valor += 'heap[(int)'+ temp + '] = ' + n.valor +';';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += 'stack[(int)'+ temp + '] = ' + n.valor +';';
                                          valor += '\n';
                                      }
                                  }
                                  else
                                  {
                                      var temp1 = Temp.getTemporal();
                                      if(n.entorno == 'global')
                                      {
                                          valor += temp1 + ' = heap[(int)'+n.position+'];';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += temp1 + ' = stack[(int)'+n.position+'];';
                                          valor += '\n';
                                      }
                                      if(entorno == 'global')
                                      {
                                          valor += 'heap[(int)'+ temp + '] = ' + temp1 +';';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                          valor += '\n';
                                      }
                                  }


                                   var sym = new intermedia.simbolo();
                                   sym.ambito = tab.ambitoLevel;
                                   sym.name = $2;
                                   sym.position = posicion;
                                   sym.rol = 'variable';
                                   sym.direccion = posicion;
                                   sym.direccionrelativa = posicion;
                                   sym.tipo = $4;
                                   sym.valor = n.valor;
                                   sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                                   if(entorno != 'global') sym.entorno = entorno;
                                   tab.insert(sym);

                                  var r = [];
                                  r[3] = valor;
                                  r[0] = '';
                                  r[1] = temp1;
                                  r[2] = '';
                                  r[4] = '';
                                  r[5] = '';
                                  r[6] = '';
                                  r[7] = '';


                                  $$ = r;

                                  //if(pos >0 && pos != 0) pos++;
                                  //if (pos == 0) pos++;
                                  break;

                             case 'BOOLEAN':
                                  var valor = '';
                                  var temp = Temp.getTemporal();
                                  //valor += temp + ' = ' + pos + ';';
                                  //valor += '\n';
                                  var posicion = -1;
                                  if(entorno == 'global')
                                  {
                                      posicion = pos;
                                      valor += temp + ' = ' + pos +';';
                                      valor += '\n';
                                      pos++;
                                  }
                                  else
                                  {
                                      posicion = stac;
                                      valor += `${temp} =  ${posicion};\n`;
                                      stac++;
                                  }
                                  if(n.rol == 'Parametro')
                                  {
                                      if(entorno == 'global')
                                      {
                                          valor += 'heap[(int)'+ temp + '] = ' + n.valor +';';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += 'stack[(int)'+ temp + '] = ' + n.valor +';';
                                          valor += '\n';
                                      }
                                  }
                                  else
                                  {
                                      var temp1 = Temp.getTemporal();
                                      if(n.entorno == 'global')
                                      {
                                          valor += temp1 + ' = heap[(int)'+n.position+'];';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += temp1 + ' = stack[(int)'+n.position+'];';
                                          valor += '\n';
                                      }
                                      if(entorno == 'global')
                                      {
                                          valor += 'heap[(int)'+ temp + '] = ' + temp1 +';';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                          valor += '\n';
                                      }
                                  }


                                   var sym = new intermedia.simbolo();
                                   sym.ambito = tab.ambitoLevel;
                                   sym.name = $2;
                                   sym.position = posicion;
                                   sym.rol = 'variable';
                                   sym.direccion = posicion;
                                   sym.direccionrelativa = posicion;
                                   sym.tipo = $4;
                                   sym.valor = n.valor;
                                   sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                                   if(entorno != 'global') sym.entorno = entorno;
                                   tab.insert(sym);

                                  var r = [];
                                  r[3] = valor;
                                  r[0] = '';
                                  r[1] = temp1;
                                  r[2] = '';
                                  r[4] = '';
                                  r[5] = '';
                                  r[6] = '';
                                  r[7] = '';


                                  $$ = r;

                                  //if(pos >0 && pos != 0) pos++;
                                  //if (pos == 0) pos++;
                                  break;

                             DEFAULT:
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$6[0]}, a una variable de tipo arreglo;`+'\"}');
                              $$ = ['','','',''];
                              break;
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
                     semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$6[0]}, a una variable de tipo ${$4};`+'\"}');
                     $$ = ['','','',''];
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
    {

        var s =  eval('$$');
        var posd = -1;
        var att = false;
        var att1 = false;
        var att2 = false;
        var att3 = false;
        var att4 = false;
        for(var a = 0; a<s.length; a++)
        {
            if(s[a] != null)
            {
                if(s[a] == ('function') && !func)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    func = !func;
                    var name = '';
                    if(posd!=-1) name = s[posd];
                    entorno = 'function_'+name;
                    break;
                }
                else if( s[a] == 'if' && !ifs)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_if';
                    ifs = !ifs;
                    if(att) att = !att;
                    break;
                }
                else if( s[a] == 'if' && ifs )
                {
                    att = true;
                    ifs = !ifs;
                }
                else if( s[a] == 'while' && !whiles)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_while';
                    whiles = !whiles;
                    if(att1) att1 = !att1;
                    break;
                }
                else if( s[a] == 'whiles' && whiles )
                {
                    att1 = true;
                    whiles = !whiles;
                }
                else if( s[a].toString().toLowerCase() == 'do' && !does)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_do';
                    does = !does;
                    if(att3) att3 = !att3;
                    break;
                }
                else if( s[a].toString().toLowerCase() == 'do' && does )
                {
                    att3 = true;
                    does = !does;
                }
                else if( s[a] == 'switch' && !switches)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_switch';
                    switches = !switches;
                    if(att4) att4 = !att4;
                    break;
                }
                else if( s[a] == 'switch' && switches )
                {
                    att4 = true;
                    switches = !switches;
                }
            }
        }
        if(att)
        {
            ifs = !ifs;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att1)
        {
            whiles = !whiles;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        if(att3)
        {
            does = !does;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att4)
        {
            switches = !switches;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        var n = tab.getPositionAmbito($2);
        var pass = false;
        if(n==null)
        {
            pass = true;
        }
        else
        {
            if(n.ambito < tab.ambitoLevel) pass = true;
        }

        if(pass)
        {
        console.log(entorno);
            if($4[0].toString().toUpperCase() != '')
            {
                switch($4[0].toString().toUpperCase())
                {
                    case "STRING":
                        var val = $4[6].toString();
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                       var posicion = -1;
                       //console.log('[',entorno,']');
                       if(entorno == 'global')
                       {
                           posicion = pos;
                           valor += temp + ' = ' + pos +';';
                           valor += '\n';
                           pos++;
                       }
                       else
                       {
                           posicion = stac;
                          valor += `${temp} =  ${posicion};\n`;
                           stac++;
                      }

                      var temp1 = Temp.getTemporal();
                      valor += temp1 + ' = ' + posS + ';';
                      valor += '\n';
                      var temp0 = Temp.getTemporal();
                      valor += temp0 + ' = ' + posS + ';';
                      valor += '\n';
                      if(entorno == 'global')
                      {
                         valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                         valor += '\n';
                      }
                      else
                      {
                         valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                         valor += '\n';
                      }

                      valor += temp1 + ' = ' + temp1 + ' + 1;';
                      valor += '\n';
                      valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';\n';
                      var temp2 = Temp.getTemporal();
                      valor += temp2 + ' = '+ val.length + ';';
                      valor += '\n';
                      valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                      valor += '\n';
                      valor += $4[1] + ' = ' + temp1 + ';';
                      valor += '\n';
                      valor += $4[3];

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp2;
                        r[2] = label1;
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';

                        var sym = new intermedia.simbolo();
                        //console.log(tab)
                        sym.ambito = tab.ambitoLevel;
                        sym.name = $2;
                        sym.position = posicion;
                        sym.rol = 'variable';
                        sym.direccion = posicion;
                        sym.direccionrelativa = posicion;
                        sym.tipo = $4[0];
                        sym.valor = $4[6];
                        sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                        if(entorno != 'global') sym.entorno = entorno;
                        tab.insert(sym);

                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        posS += 5000;
                        break;

                    case "NUMBER":
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                           var posicion = -1;
                           if(entorno == 'global')
                           {
                               posicion = pos;
                               valor += temp + ' = ' + pos +';';
                               valor += '\n';
                               pos++;
                           }
                           else
                           {
                               posicion = stac;
                               valor += `${temp} =  ${posicion};\n`;
                               stac++;
                          }
                        valor += $4[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }


                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = $4[0];
                         sym.valor = $4[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno ;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;
/*                    case "lET":
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                           var posicion = -1;
                           if(entorno == 'global')
                           {
                               posicion = pos;
                               valor += temp + ' = ' + pos +';';
                               valor += '\n';
                               pos++;
                           }
                           else
                           {
                               posicion = stac;
                               valor += `${temp} =  ${posicion};\n`;
                               stac++;
                          }
                        valor += $4[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }


                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = $4[0];
                         sym.valor = $4[3];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno ;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;*/
                    case "FUNCION":
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                           var posicion = -1;
                           if(entorno == 'global')
                           {
                               posicion = pos;
                               valor += temp + ' = ' + pos +';';
                               valor += '\n';
                               pos++;
                           }
                           else
                           {
                               posicion = stac;
                               valor += `${temp} =  ${posicion};\n`;
                               stac++;
                          }
                        valor += $4[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = stack[(int)' + $4[1] +'];';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }


                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = 'NUMBER';
                         sym.valor = -1;
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno ;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;
                    case 'BOOLEAN':
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                           var posicion = -1;
                           if(entorno == 'global')
                           {
                               posicion = pos;
                               valor += temp + ' = ' + pos +';';
                               valor += '\n';
                               pos++;
                           }
                           else
                           {
                               posicion = stac;
                               valor += `${temp} =  ${posicion};\n`;
                               stac++;
                          }
                        valor += $4[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }


                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = $4[0];
                         sym.valor = $4[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;

                    case "FLOAT":
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                           var posicion = -1;
                           if(entorno == 'global')
                           {
                               posicion = pos;
                               valor += temp + ' = ' + pos +';';
                               valor += '\n';
                               pos++;
                           }
                           else
                           {
                               posicion = stac;
                               valor += `${temp} =  ${posicion};\n`;
                               stac++;
                          }
                        valor += $4[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }


                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = $4[0];
                         sym.valor = $4[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;

                    case 'ARREGLO':
                        var val = $4[6].toString();
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                           var posicion = -1;
                           if(entorno == 'global')
                           {
                               posicion = pos;
                               valor += temp + ' = ' + pos +';';
                               valor += '\n';
                               pos++;
                           }
                           else
                           {
                               posicion = stac;
                               valor += `${temp} =  ${posicion};\n`;
                               stac++;
                          }

                        var temp1 = Temp.getTemporal();
                        var temp0 = Temp.getTemporal();
                        valor += temp1 + ' = ' + posA + ';';
                        valor += '\n';
                        valor += temp0+ ' = ' + posA + ';\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                            valor += '\n';
                        }

                        valor += temp1 + ' = ' + temp1 + ' + 1;';
                        valor += '\n';
                        valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';\n';

                        var temp2 = Temp.getTemporal();
                        valor += temp2 + ' = '+ $4[7] + ';';
                        valor += '\n';
                        valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                        valor += '\n';
                        valor += $4[1] + ' = ' + temp1 + ';';
                        valor += '\n';
                        valor += $4[3];
                        valor += '\n';

                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'arreglo';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = ($4[8]!='')?$4[8]:$4[0];
                         sym.valor = $4[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp2;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';

                        $4[6].name = $2;
                        var a = new intermedia.arreglo()
                        a.name = $2;
                        a.tipo = ($4[8]!='')?$4[8]:$4[0];
                        a.positions = $4[6].positions;
                        a.c3d = valor;
                        a.valor = $4[6].valor;
                        a.temporal = temp2;
                        a.bandera = '';
                        arr.insert(a);

                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        posA += 5000;
                        break;

                    DEFAULT:
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$4[0]}, a una variable de tipo arreglo;`+'\"}');
                        $$ = ['','','',''];

                }
            }
            else if($4[0] == '')
            {
                 var n = tab.getPositionAmbito($4[4]);
                 //console.log(n);
                 if(n!=null)
                 {
                     if(n.tipo.toUpperCase()!='')
                     {
                         switch(n.tipo.toUpperCase())
                         {

                             case 'STRING':
                                 var valor = '';
                                  var temp = Temp.getTemporal();
                                  //valor += temp + ' = ' + pos + ';';
                                  //valor += '\n';
                                   var posicion = -1;
                                   if(entorno == 'global')
                                   {
                                       posicion = pos;
                                       valor += temp + ' = ' + pos +';';
                                       valor += '\n';
                                       pos++;
                                   }
                                   else
                                   {
                                       posicion = stac;
                                       valor += `${temp} =  ${posicion};\n`;
                                       stac++;
                                  }


                                  var temp1 = Temp.getTemporal();
                                  valor += temp1 + ' = ' + posS + ';';
                                  valor += '\n';
                                  var temp0 = Temp.getTemporal();
                                  valor += temp0 + ' = ' + posS + ';';
                                  valor += '\n';
                                  if(entorno == 'global')
                                  {
                                      valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                                      valor += '\n';
                                  }
                                  else
                                  {
                                      valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                                      valor += '\n';
                                  }

                                  valor += temp1 + ' = ' + temp1 + ' + 1;';
                                  valor += '\n';
                                  valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';\n';
                                  var temp2 = Temp.getTemporal();
                                  valor += temp2 + ' = '+ n.valor.length + ';';
                                  valor += '\n';
                                  valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                                  valor += '\n';

                                 for(var a = 0; a<n.valor.length; a++)
                                 {
                                     valor += temp1 + ' = ' + temp1 + ' + 1;';
                                     valor += '\n';
                                     valor += 'heap[(int)'+temp1+'] = ' + n.valor.charCodeAt(a) + ';';
                                     valor += '\n'
                                 }
                               var r = [];
                               r[3] = valor;
                               r[0] = '';
                               r[1] = temp1;
                               r[2] = '';
                               r[4] = '';
                               r[5] = '';
                               r[6] = '';
                               r[7] = '';

                               var sym = new intermedia.simbolo();
                               sym.ambito = tab.ambitoLevel;
                               sym.name = $2;
                               sym.position = posicion;
                               sym.rol = 'variable';
                               sym.direccion = posicion;
                               sym.direccionrelativa = posicion;
                               sym.tipo = n.tipo;
                               sym.valor = n.valor;
                               sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                               if(entorno != 'global') sym.entorno = entorno;
                               tab.insert(sym);

                               $$ = r;

                               //if(pos >0 && pos != 0) pos++;
                               //if (pos == 0) pos++;
                               posS += 5000;
                               break;
                             case 'LET':
                                  var valor = '';
                                  var temp = Temp.getTemporal();
                                  //valor += temp + ' = ' + pos + ';';
                                  //valor += '\n';
                                   var posicion = -1;
                                   if(entorno == 'global')
                                   {
                                       posicion = pos;
                                       valor += temp + ' = ' + pos +';';
                                       valor += '\n';
                                       pos++;
                                   }
                                   else
                                   {
                                       posicion = stac;
                                       valor += `${temp} =  ${posicion};\n`;
                                       stac++;
                                  }
                                  var temp1 = Temp.getTemporal();
                                  if(n.rol == 'Parametro')
                                  {
                                      valor += `${temp1} = ${n.valor};\n`;
                                  }
                                  else
                                  {
                                      if(n.entorno == 'global')
                                      {
                                          valor += temp1 + ' = heap[(int)'+n.position+'];';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += temp1 + ' = stack[(int)'+n.position+'];';
                                          valor += '\n';
                                      }
                                  }

                                  if(entorno == 'global')
                                  {
                                      valor += 'heap[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  }
                                  else
                                  {
                                      valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  }


                                   var sym = new intermedia.simbolo();
                                   sym.ambito = tab.ambitoLevel;
                                   sym.name = $2;
                                   sym.position = posicion;
                                   sym.rol = 'variable';
                                   sym.direccion = posicion;
                                   sym.direccionrelativa = posicion;
                                   sym.tipo = n.tipo;
                                   sym.valor = n.valor;
                                   sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                                   if(entorno != 'global') sym.entorno = entorno;
                                   tab.insert(sym);

                                  var r = [];
                                  r[3] = valor;
                                  r[0] = '';
                                  r[1] = temp1;
                                  r[2] = '';
                                  r[4] = '';
                                  r[5] = '';
                                  r[6] = '';
                                  r[7] = '';


                                  $$ = r;

                                  //if(pos >0 && pos != 0) pos++;
                                  //if (pos == 0) pos++;
                                  break;
                             case 'NUMBER':
                                  var valor = '';
                                  var temp = Temp.getTemporal();
                                  //valor += temp + ' = ' + pos + ';';
                                  //valor += '\n';
                                   var posicion = -1;
                                   if(entorno == 'global')
                                   {
                                       posicion = pos;
                                       valor += temp + ' = ' + pos +';';
                                       valor += '\n';
                                       pos++;
                                   }
                                   else
                                   {
                                       posicion = stac;
                                       valor += `${temp} =  ${posicion};\n`;
                                       stac++;
                                  }
                                  var temp1 = Temp.getTemporal();
                                  if(n.rol == 'Parametro')
                                  {
                                      valor += `${temp1} = ${n.valor};\n`;
                                  }
                                  else
                                  {
                                      if(n.entorno == 'global')
                                      {
                                          valor += temp1 + ' = heap[(int)'+n.position+'];';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += temp1 + ' = stack[(int)'+n.position+'];';
                                          valor += '\n';
                                      }
                                  }

                                  if(entorno == 'global')
                                  {
                                      valor += 'heap[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  }
                                  else
                                  {
                                      valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  }


                                   var sym = new intermedia.simbolo();
                                   sym.ambito = tab.ambitoLevel;
                                   sym.name = $2;
                                   sym.position = posicion;
                                   sym.rol = 'variable';
                                   sym.direccion = posicion;
                                   sym.direccionrelativa = posicion;
                                   sym.tipo = n.tipo;
                                   sym.valor = n.valor;
                                   sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                                   if(entorno != 'global') sym.entorno = entorno;
                                   tab.insert(sym);

                                  var r = [];
                                  r[3] = valor;
                                  r[0] = '';
                                  r[1] = temp1;
                                  r[2] = '';
                                  r[4] = '';
                                  r[5] = '';
                                  r[6] = '';
                                  r[7] = '';


                                  $$ = r;

                                  //if(pos >0 && pos != 0) pos++;
                                  //if (pos == 0) pos++;
                                  break;
                             case 'BOOLEAN':
                                  var valor = '';
                                  var temp = Temp.getTemporal();
                                   var posicion = -1;
                                   if(entorno == 'global')
                                   {
                                       posicion = pos;
                                       valor += temp + ' = ' + pos +';';
                                       valor += '\n';
                                       pos++;
                                   }
                                   else
                                   {
                                       posicion = stac;
                                       valor += `${temp} =  ${posicion};\n`;
                                       stac++;
                                  }
                                  var temp1 = Temp.getTemporal();
                                  if(n.rol == 'Parametro')
                                  {
                                      valor += `${temp1} = ${n.valor};\n`;
                                  }
                                  else
                                  {
                                      if(n.entorno == 'global')
                                      {
                                          valor += temp1 + ' = heap[(int)'+n.position+'];';
                                          valor += '\n';
                                      }
                                      else
                                      {
                                          valor += temp1 + ' = stack[(int)'+n.position+'];';
                                          valor += '\n';
                                      }
                                  }

                                  if(entorno == 'global')
                                  {
                                      valor += 'heap[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  }
                                  else
                                  {
                                      valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  }
                                  /*
                                      valor += temp + ' = ' + pos + ';';
                                      valor += '\n';
                                      var temp1 = Temp.getTemporal();
                                      valor += temp1 + ' = stack[(int)'+n.position+'];';
                                      valor += '\n';
                                      valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  */

                                   var sym = new intermedia.simbolo();
                                   sym.ambito = tab.ambitoLevel;
                                   sym.name = $2;
                                   sym.position = posicion;
                                   sym.rol = 'variable';
                                   sym.direccion = posicion;
                                   sym.direccionrelativa = posicion;
                                   sym.tipo = n.tipo;
                                   sym.valor = n.valor;
                                   sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                                   if(entorno != 'global') sym.entorno = entorno;
                                   tab.insert(sym);

                                  var r = [];
                                  r[3] = valor;
                                  r[0] = '';
                                  r[1] = temp1;
                                  r[2] = '';
                                  r[4] = '';
                                  r[5] = '';
                                  r[6] = '';
                                  r[7] = '';


                                  $$ = r;

                                  //if(pos >0 && pos != 0) pos++;
                                  //if (pos == 0) pos++;
                                  break;
                             DEFAULT:
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$4[0]}, a una variable de tipo arreglo;`+'\"}');
                              $$ = ['','','',''];
                              break;
                         }
                     }
                     else
                     {
                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$4[0]}, a una variable de tipo ${$4};`+'\"}');
                         $$ = ['','','',''];
                     }

                 }
                 else
                 {
                     semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$4[0]}, a una variable de tipo ${$4};`+'\"}');
                     $$ = ['','','',''];
                 }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$4[6]}, a una variable de tipo ${$4[0]};d`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, ya existe una variable con el nombre ${$2};`+'\"}');
            $$ = ['','','',''];
        }
    }
;

ValStatement1
    : TypeV IDENT  '=' AssignmentExpr
    {

        var s =  eval('$$');
        var posd = -1;
        var att = false;
        var att1 = false;
        var att2 = false;
        var att3 = false;
        var att4 = false;
        for(var a = 0; a<s.length; a++)
        {
            if(s[a] != null)
            {
                if(s[a] == ('function') && !func)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    func = !func;
                    var name = '';
                    if(posd!=-1) name = s[posd];
                    entorno = 'function_'+name;
                    break;
                }
                else if( s[a] == 'if' && !ifs)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_if';
                    ifs = !ifs;
                    if(att) att = !att;
                    break;
                }
                else if( s[a] == 'if' && ifs )
                {
                    att = true;
                    ifs = !ifs;
                }
                else if( s[a] == 'while' && !whiles)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_while';
                    whiles = !whiles;
                    if(att1) att1 = !att1;
                    break;
                }
                else if( s[a] == 'whiles' && whiles )
                {
                    att1 = true;
                    whiles = !whiles;
                }
                else if( s[a] == 'for' && !fores)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_for';
                    fores = !fores;
                    if(att2) att2 = !att2;
                    //console.log(entorno);
                    break;
                }
                else if( s[a] == 'for' && fores )
                {
                    att2 = true;
                    fores = !fores;
                }
                else if( s[a].toString().toLowerCase() == 'do' && !does)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_do';
                    does = !does;
                    if(att3) att3 = !att3;
                    break;
                }
                else if( s[a].toString().toLowerCase() == 'do' && does )
                {
                    att3 = true;
                    does = !does;
                }
                else if( s[a] == 'switch' && !switches)
                {
                    posd = a+1;
                    tab.ambitoLevel = tab.ambitoLevel+1;
                    entorno = entorno + '_switch';
                    switches = !switches;
                    if(att4) att4 = !att4;
                    break;
                }
                else if( s[a] == 'switch' && switches )
                {
                    att4 = true;
                    switches = !switches;
                }
            }
        }
        if(att)
        {
            ifs = !ifs;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att1)
        {
            whiles = !whiles;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att2)
        {
            fores = !fores;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att3)
        {
            does = !does;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }
        if(att4)
        {
            switches = !switches;
            tab.ambitoLevel = tab.ambitoLevel+1;
        }

        var n = tab.getPositionAmbito($2);
        var pass = false;
        if(n==null)
        {
            pass = true;
        }
        else
        {
            if(n.ambito < tab.ambitoLevel) pass = true;
            if(n.rol == 'Parametro') pass  = false;
        }

        if(pass)
        {
            if($4[0].toString().toUpperCase() != '')
            {
                switch($4[0].toString().toUpperCase())
                {
                    case "STRING":
                        var val = $4[6].toString();
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                       var posicion = -1;
                       if(entorno == 'global')
                       {
                           posicion = pos;
                           valor += temp + ' = ' + pos +';';
                           valor += '\n';
                           pos++;
                       }
                       else
                       {
                           posicion = stac;
                           valor += `${temp} =  ${posicion};\n`;
                           stac++;
                      }

                      var temp1 = Temp.getTemporal();
                      valor += temp1 + ' = ' + posS + ';';
                      valor += '\n';
                      var temp0 = Temp.getTemporal();
                      valor += temp0 + ' = ' + posS + ';';
                      valor += '\n';
                      if(entorno == 'global')
                      {
                         valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                         valor += '\n';
                      }
                      else
                      {
                         valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                         valor += '\n';
                      }

                      valor += temp1 + ' = ' + temp1 + ' + 1;';
                      valor += '\n';
                      valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';\n';
                      var temp2 = Temp.getTemporal();
                      valor += temp2 + ' = '+ val.length + ';';
                      valor += '\n';
                      valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                      valor += '\n';
                      valor += $4[1] + ' = ' + temp1 + ';';
                      valor += '\n';
                      valor += $4[3];

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp2;
                        r[2] = label1;
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';

                        var sym = new intermedia.simbolo();
                        sym.ambito = tab.ambitoLevel;
                        sym.name = $2;
                        sym.position = posicion;
                        sym.rol = 'variable';
                        sym.direccion = posicion;
                        sym.direccionrelativa = posicion;
                        sym.tipo = $4[0];
                        sym.valor = $4[6];
                        sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                        if(entorno != 'global') sym.entorno = entorno;
                        tab.insert(sym);

                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        posS += 5000;
                        break;

                    case "NUMBER":
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                           var posicion = -1;
                           if(entorno == 'global')
                           {
                               posicion = pos;
                               valor += temp + ' = ' + pos +';';
                               valor += '\n';
                               pos++;
                           }
                           else
                           {
                               posicion = stac;
                               valor += `${temp} =  ${posicion};\n`;
                               stac++;
                          }
                        valor += $4[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }


                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = $4[0];
                         sym.valor = $4[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno ;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;

                    case 'BOOLEAN':
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                           var posicion = -1;
                           if(entorno == 'global')
                           {
                               posicion = pos;
                               valor += temp + ' = ' + pos +';';
                               valor += '\n';
                               pos++;
                           }
                           else
                           {
                               posicion = stac;
                               valor += `${temp} =  ${posicion};\n`;
                               stac++;
                          }
                        valor += $4[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }


                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = $4[0];
                         sym.valor = $4[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;

                    case "FLOAT":
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                           var posicion = -1;
                           if(entorno == 'global')
                           {
                               posicion = pos;
                               valor += temp + ' = ' + pos +';';
                               valor += '\n';
                               pos++;
                           }
                           else
                           {
                               posicion = stac;
                               valor += `${temp} =  ${posicion};\n`;
                               stac++;
                          }
                        valor += $4[3];
                        valor += '\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+ temp + '] = ' + $4[1] +';';
                            valor += '\n';
                        }


                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'variable';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = $4[0];
                         sym.valor = $4[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';


                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        break;

                    case 'ARREGLO':
                        var val = $4[6].toString();
                        var valor = '';
                        var temp = Temp.getTemporal();
                        //valor += temp + ' = ' + pos + ';';
                        //valor += '\n';
                           var posicion = -1;
                           if(entorno == 'global')
                           {
                               posicion = pos;
                               valor += temp + ' = ' + pos +';';
                               valor += '\n';
                               pos++;
                           }
                           else
                           {
                               posicion = stac;
                               valor += `${temp} =  ${posicion};\n`;
                               stac++;
                          }

                        var temp1 = Temp.getTemporal();
                        var temp0 = Temp.getTemporal();
                        valor += temp1 + ' = ' + posA + ';';
                        valor += '\n';
                        valor += temp0+ ' = ' + posA + ';\n';
                        if(entorno == 'global')
                        {
                            valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                            valor += '\n';
                        }
                        else
                        {
                            valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                            valor += '\n';
                        }

                        valor += temp1 + ' = ' + temp1 + ' + 1;';
                        valor += '\n';
                        valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';\n';

                        var temp2 = Temp.getTemporal();
                        valor += temp2 + ' = '+ $4[7] + ';';
                        valor += '\n';
                        valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                        valor += '\n';
                        valor += $4[1] + ' = ' + temp1 + ';';
                        valor += '\n';
                        valor += $4[3];
                        valor += '\n';

                         var sym = new intermedia.simbolo();
                         sym.ambito = tab.ambitoLevel;
                         sym.name = $2;
                         sym.position = posicion;
                         sym.rol = 'arreglo';
                         sym.direccion = posicion;
                         sym.direccionrelativa = posicion;
                         sym.tipo = ($4[8]!='')?$4[8]:$4[0];
                         sym.valor = $4[6];
                         sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                         if(entorno != 'global') sym.entorno = entorno;
                         tab.insert(sym);

                        var r = [];
                        r[3] = valor;
                        r[0] = '';
                        r[1] = temp2;
                        r[2] = '';
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';

                        $4[6].name = $2;
                        var a = new intermedia.arreglo()
                        a.name = $2;
                        a.tipo = ($4[8]!='')?$4[8]:$4[0];
                        a.positions = $4[6].positions;
                        a.c3d = valor;
                        a.valor = $4[6].valor;
                        a.temporal = temp2;
                        a.bandera = '';
                        arr.insert(a);

                        $$ = r;

                        //if(pos >0 && pos != 0) pos++;
                        //if (pos == 0) pos++;
                        posA += 5000;
                        break;

                    DEFAULT:
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$4[0]}, a una variable de tipo arreglo;`+'\"}');
                        $$ = ['','','',''];

                }
            }
            else if($4[0] == '')
            {
                 var n = tab.getPositionAmbito($4[4]);
                 if(n!=null)
                 {
                     if(n.tipo.toUpperCase()!='')
                     {
                         switch(n.tipo.toUpperCase())
                         {
                             case 'STRING':
                                 var valor = '';
                                  var temp = Temp.getTemporal();
                                  //valor += temp + ' = ' + pos + ';';
                                  //valor += '\n';
                                   var posicion = -1;
                                   console.log(entorno);
                                   if(entorno == 'global')
                                   {
                                       posicion = pos;
                                       valor += temp + ' = ' + pos +';';
                                       valor += '\n';
                                       pos++;
                                   }
                                   else
                                   {
                                       posicion = stac;
                                       valor += `${temp} =  ${posicion};\n`;
                                       stac++;
                                  }


                                  var temp1 = Temp.getTemporal();
                                  valor += temp1 + ' = ' + posS + ';';
                                  valor += '\n';
                                  var temp0 = Temp.getTemporal();
                                  valor += temp0 + ' = ' + posS + ';';
                                  valor += '\n';
                                  if(entorno == 'global')
                                  {
                                      valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                                      valor += '\n';
                                  }
                                  else
                                  {
                                      valor += 'stack[(int)'+temp+'] = ' + temp1 + ';';
                                      valor += '\n';
                                  }

                                  valor += temp1 + ' = ' + temp1 + ' + 1;';
                                  valor += '\n';
                                  valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';\n';
                                  var temp2 = Temp.getTemporal();
                                  valor += temp2 + ' = '+ n.valor.length + ';';
                                  valor += '\n';
                                  valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                                  valor += '\n';

                                 for(var a = 0; a<n.valor.length; a++)
                                 {
                                     valor += temp1 + ' = ' + temp1 + ' + 1;';
                                     valor += '\n';
                                     valor += 'heap[(int)'+temp1+'] = ' + n.valor.charCodeAt(a) + ';';
                                     valor += '\n'
                                 }
                               var r = [];
                               r[3] = valor;
                               r[0] = '';
                               r[1] = temp1;
                               r[2] = '';
                               r[4] = '';
                               r[5] = '';
                               r[6] = '';
                               r[7] = '';

                               var sym = new intermedia.simbolo();
                               sym.ambito = tab.ambitoLevel;
                               sym.name = $2;
                               sym.position = posicion;
                               sym.rol = 'variable';
                               sym.direccion = posicion;
                               sym.direccionrelativa = posicion;
                               sym.tipo = n.tipo;
                               sym.valor = n.valor;
                               sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                               if(entorno != 'global') sym.entorno = entorno;
                               tab.insert(sym);

                               $$ = r;

                               //if(pos >0 && pos != 0) pos++;
                               //if (pos == 0) pos++;
                               posS += 5000;
                               break;

                             case 'NUMBER':
                                  var valor = '';
                                  var temp = Temp.getTemporal();
                                  //valor += temp + ' = ' + pos + ';';
                                  //valor += '\n';
                                   var posicion = -1;
                                   if(entorno == 'global')
                                   {
                                       posicion = pos;
                                       valor += temp + ' = ' + pos +';';
                                       valor += '\n';
                                       pos++;
                                   }
                                   else
                                   {
                                       posicion = stac;
                                       valor += `${temp} =  ${posicion};\n`;
                                       stac++;
                                  }
                                  var temp1 = Temp.getTemporal();
                                  if(n.entorno == 'global')
                                  {
                                      valor += temp1 + ' = heap[(int)'+n.position+'];';
                                      valor += '\n';
                                  }
                                  else
                                  {
                                      valor += temp1 + ' = stack[(int)'+n.position+'];';
                                      valor += '\n';
                                  }

                                  if(entorno == 'global')
                                  {
                                      valor += 'heap[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  }
                                  else
                                  {
                                      valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  }


                                   var sym = new intermedia.simbolo();
                                   sym.ambito = tab.ambitoLevel;
                                   sym.name = $2;
                                   sym.position = posicion;
                                   sym.rol = 'variable';
                                   sym.direccion = posicion;
                                   sym.direccionrelativa = posicion;
                                   sym.tipo = n.tipo;
                                   sym.valor = n.valor;
                                   sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                                   if(entorno != 'global') sym.entorno = entorno;
                                   tab.insert(sym);

                                  var r = [];
                                  r[3] = valor;
                                  r[0] = '';
                                  r[1] = temp1;
                                  r[2] = '';
                                  r[4] = '';
                                  r[5] = '';
                                  r[6] = '';
                                  r[7] = '';


                                  $$ = r;

                                  //if(pos >0 && pos != 0) pos++;
                                  //if (pos == 0) pos++;
                                  break;
                             case 'BOOLEAN':
                                  var valor = '';
                                  var temp = Temp.getTemporal();
                                   var posicion = -1;
                                   if(entorno == 'global')
                                   {
                                       posicion = pos;
                                       valor += temp + ' = ' + pos +';';
                                       valor += '\n';
                                       pos++;
                                   }
                                   else
                                   {
                                       posicion = stac;
                                       valor += `${temp} =  ${posicion};\n`;
                                       stac++;
                                  }
                                  var temp1 = Temp.getTemporal();
                                  if(n.entorno == 'global')
                                  {
                                      valor += temp1 + ' = heap[(int)'+n.position+'];';
                                      valor += '\n';
                                  }
                                  else
                                  {
                                      valor += temp1 + ' = stack[(int)'+n.position+'];';
                                      valor += '\n';
                                  }

                                  if(entorno == 'global')
                                  {
                                      valor += 'heap[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  }
                                  else
                                  {
                                      valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  }
                                  /*
                                      valor += temp + ' = ' + pos + ';';
                                      valor += '\n';
                                      var temp1 = Temp.getTemporal();
                                      valor += temp1 + ' = stack[(int)'+n.position+'];';
                                      valor += '\n';
                                      valor += 'stack[(int)'+ temp + '] = ' + temp1 +';';
                                      valor += '\n';
                                  */

                                   var sym = new intermedia.simbolo();
                                   sym.ambito = tab.ambitoLevel;
                                   sym.name = $2;
                                   sym.position = posicion;
                                   sym.rol = 'variable';
                                   sym.direccion = posicion;
                                   sym.direccionrelativa = posicion;
                                   sym.tipo = n.tipo;
                                   sym.valor = n.valor;
                                   sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
                                   if(entorno != 'global') sym.entorno = entorno;
                                   tab.insert(sym);

                                  var r = [];
                                  r[3] = valor;
                                  r[0] = '';
                                  r[1] = temp1;
                                  r[2] = '';
                                  r[4] = '';
                                  r[5] = '';
                                  r[6] = '';
                                  r[7] = '';


                                  $$ = r;

                                  //if(pos >0 && pos != 0) pos++;
                                  //if (pos == 0) pos++;
                                  break;
                             DEFAULT:
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$4[0]}, a una variable de tipo arreglo;`+'\"}');
                              $$ = ['','','',''];
                              break;
                         }
                     }
                     else
                     {
                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$4[0]}, a una variable de tipo ${$4};`+'\"}');
                         $$ = ['','','',''];
                     }

                 }
                 else
                 {
                     semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$4[0]}, a una variable de tipo ${$4};`+'\"}');
                     $$ = ['','','',''];
                 }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no puedes asignar ${$4[6]}, a una variable de tipo ${$4[0]};d`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, ya existe una variable con el nombre ${$2};`+'\"}');
            $$ = ['','','',''];
        }
    }
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
    {
        var valor = '';
        valor += `void ${$2}()\n{\n`;

        var label;
        if(returns != '')
        {
            label = returns;
        }
        else
        {
            label = Label.getBandera();
        }
        valor += $6[3] + '\n';
        valor += `goto ${label};\n`;
        valor += `${label}:\n`;
        valor += `return;\n`;
        valor += `}`;

        ff.push(valor);


        var sym = new intermedia.simbolo();
        sym.ambito = 0;
        sym.name = $2;
        sym.params = 0;
        sym.position = -1;
        sym.rol = 'FUNCION';
        sym.direccion = -1;
        sym.direccionrelativa = -1;
        sym.tipo = 'void';
        sym.valor = null;
        sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
        sym.entorno = 'global';
        tab.insert(sym);
        params = 0;
        entorno = 'global';

        $$ = ['','','','','',''];
    }
    | FUNCTION IDENT '(' ParameterList ')' OPENBRACE Source2 CLOSEBRACE
    {
        var valor = '';
        valor += `void ${$2}()\n{\n`;

        var label;
        if(returns != '')
        {
            label = returns;
        }
        else
        {
            label = Label.getBandera();
        }
        valor += $4[3] + '\n';
        valor += $7[3] + '\n';
        valor += `goto ${label};\n`;
        valor += `${label}:\n`;
        valor += `return;\n`;
        valor += `}`;

        ff.push(valor);
        /*
        var sym = new intermedia.simbolo();
        sym.ambito = 0;
        sym.name = $2;
        sym.params = 0;
        sym.position = -1;
        sym.rol = 'FUNCION';
        sym.direccion = -1;
        sym.direccionrelativa = -1;
        sym.tipo = 'void';
        sym.valor = null;
        sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
        sym.entorno = 'global';
        tab.insert(sym);
        */
        params = 0;
        entorno = 'global';
        $$ = ['','','','','',''];
    }
    | FUNCTION IDENT '(' ')' ':' Type OPENBRACE Source2 CLOSEBRACE
    {
        var valor = '';
        valor += `void ${$2}()\n{\n`;

        var label;
        if(returns != '')
        {
            label = returns;
        }
        else
        {
            label = Label.getBandera();
        }
        valor += $8[3] + '\n';
        valor += `goto ${label};\n`;
        valor += `${label}:\n`;
        valor += `return;\n`;
        valor += `}`;

        ff.push(valor);

        var sym = new intermedia.simbolo();
        sym.ambito = 0;
        sym.name = $2;
        sym.params = 0;
        sym.position = -1;
        sym.rol = 'FUNCION';
        sym.direccion = -1;
        sym.direccionrelativa = -1;
        sym.tipo = $6;
        sym.valor = null;
        sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
        sym.entorno = 'global';
        tab.insert(sym);
        params = 0;
        entorno = 'global';
        $$ = ['','','','','',''];
    }
    | FUNCTION IDENT '(' ParameterList ')' ':' Type OPENBRACE Source2 CLOSEBRACE
    {
    }
    | FUNCTION IDENT '(' ')' OPENBRACE  CLOSEBRACE
    {
        var valor = '';
        valor += `void ${$2}()\n{\n`;

        var label;
        if(returns != '')
        {
            label = returns;
        }
        else
        {
            label = Label.getBandera();
        }

        valor += `goto ${label};\n`;
        valor += `${label}:\n`;
        valor += `return;\n`;
        valor += `}`;

        ff.push(valor);

        var sym = new intermedia.simbolo();
        sym.ambito = 0;
        sym.name = $2;
        sym.params = 0;
        sym.position = -1;
        sym.rol = 'FUNCION';
        sym.direccion = -1;
        sym.direccionrelativa = -1;
        sym.tipo = 'void';
        sym.valor = null;
        sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
        sym.entorno = 'global';
        tab.insert(sym);
        params = 0;
        entorno = 'global';
        $$ = ['','','','','',''];
    }
    | FUNCTION IDENT '(' ParameterList ')' OPENBRACE  CLOSEBRACE
    {
    }
    | FUNCTION IDENT '(' ')' ':' Type OPENBRACE  CLOSEBRACE
    {
        var valor = '';
        valor += `void ${$2}()\n{\n`;

        var label;
        if(returns != '')
        {
            label = returns;
        }
        else
        {
            label = Label.getBandera();
        }
        valor += `goto ${label};\n`;
        valor += `${label}:\n`;
        valor += `return;\n`;
        valor += `}`;

        ff.push(valor);

        var sym = new intermedia.simbolo();
        sym.ambito = 0;
        sym.name = $2;
        sym.params = 0;
        sym.position = -1;
        sym.rol = 'FUNCION';
        sym.direccion = -1;
        sym.direccionrelativa = -1;
        sym.tipo = 'void';
        sym.valor = null;
        sym.constante = ($1.toUpperCase() == 'CONST')?true:false;
        sym.entorno = 'global';
        tab.insert(sym);
        params = 0;
        entorno = 'global';
        $$ = ['','','','','',''];
    }
    | FUNCTION IDENT '(' ParameterList ')' ':' Type OPENBRACE  CLOSEBRACE
    {
    }
;
FunctionExpr
    : FUNCTION '(' ')' OPENBRACE Source2 CLOSEBRACE
    {
        $$ = ['','','','','','',''];
    }
    | FUNCTION '(' ParameterList ')' OPENBRACE Source2 CLOSEBRACE
    {
        $$ = ['','','','','','',''];
    }
    | FUNCTION IDENT '(' ')' OPENBRACE Source2 CLOSEBRACE
    {
        $$ = ['','','','','','',''];
    }
    | FUNCTION IDENT '(' ParameterList ')' OPENBRACE Source2 CLOSEBRACE
    {
        $$ = ['','','','','','',''];
    }
    | FUNCTION '(' ')' OPENBRACE  CLOSEBRACE
    {
        $$ = ['','','','','','',''];
    }
    | FUNCTION '(' ParameterList ')' OPENBRACE Source2 CLOSEBRACE
    {
        $$ = ['','','','','','',''];
    }
    | FUNCTION IDENT '(' ')' OPENBRACE  CLOSEBRACE
    {
        $$ = ['','','','','','',''];
    }
    | FUNCTION IDENT '(' ParameterList ')' OPENBRACE  CLOSEBRACE
    {
        $$ = ['','','','','','',''];
    }
;
Source2
    :  Statement1
    {
        var valor = '';
        valor += $1[3];
        var r = [];
        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = valor;
        $$ = r;
    }
    |  Statement1 Source2
    {
        var valor = '';
        valor += $1[3] + '\n';
        valor += $2[3];
        var r = [];
        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = valor;
        $$ = r;
    }
    |  EOF
    {
        $$ = ['','','','',''];
    }
;

Statement1
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
    {
        $$ = ['','','',''];
    }
    | error ';'
      {
        console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);
        sintacticos.push('{\"token\":\"'+yytext+'\", \"linea\":\"'+this._$.first_line+'\", \"columna\":\"'+this._$.first_column+'\"}');
        $$ = ['','','','','','','','','',''];
      }
    | error
      {
        console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);
        sintacticos.push('{\"token\":\"'+yytext+'\", \"linea\":\"'+this._$.first_line+'\", \"columna\":\"'+this._$.first_column+'\"}');
        $$ = ['','','','','','','','','',''];
      }
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
    : RETURN
    {
        var valor = '';
        if(returns != '')
        {
            valor += `goto ${returns};\n`;
        }
        else
        {
            var label = Label.getBandera();
            returns = label;
            valor += `goto ${returns};\n`;
        }
        var r = [];
        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = valor;
        r[5] = null;
        r[6] = null;
        $$ = r;
    }
    | RETURN Expr
    {
        var valor = '';
        if(returns != '')
        {
            if($2[0] != '')
            {
                var temp = Temp.getTemporal();
                valor += `${temp} = P + ${params};\n`;
                valor += $2[3] + '\n';
                valor += `stack[(int)${temp}] = ${$2[1]};\n`;
                valor += `goto ${returns};\n`;
            }
            else
            {
                var n = tab.getPositionAmbito($2[4]);
                if(n!=null)
                {

                    var valor = '';
                    var temp = Temp.getTemporal();
                    var temp1 = Temp.getTemporal();
                    valor += `${temp} = P + ${params};\n`;
                    valor += `${temp1} = stack[${n.position}];\n`;
                    valor += `stack[(int)${temp}] = ${temp1};\n`;
                    valor += `goto ${returns};\n`;
                }
                else
                {
                     valor += `goto ${returns};\n`;
                }
           }
/*
            if($2[0] == 'FUNCION')
            {

                valor += `${temp} = P + ${params};\n`;
                valor += $2[3] + '\n';
                valor += `stack[(int)${temp}] = ${$2[1]};\n`;
                valor += `goto ${returns};\n`;
            }
            else
            {
                if($2[0] != '')
                {
                    valor += `${temp} = P + ${params};\n`;
                    valor += $2[3] + '\n';
                    valor += `stack[(int)${temp}] = ${$2[1]};\n`;
                    valor += `goto ${returns};\n`;
                }
            }
*/

        }
        else
        {
            var label = Label.getBandera();
            returns = label;
            if($2[0] == '')
            {
                var n = tab.getPositionAmbito($2[4]);
                if(n!=null)
                {

                    var valor = '';
                    var temp = Temp.getTemporal();
                    var temp1 = Temp.getTemporal();
                    valor += `${temp} = P + ${params};\n`;
                    valor += `${temp1} = stack[${n.position}];\n`;
                    valor += `stack[(int)${temp}] = ${temp1};\n`;
                    valor += `goto ${returns};\n`;
                }
                else
                {
                     valor += `goto ${returns};\n`;
                }
            }
            else
            {
                var temp = Temp.getTemporal();
                valor += `${temp} = P + ${params};\n`;
                valor += $2[3] + '\n';
                valor += `stack[(int)${temp}] = ${$2[1]};\n`;
                valor += `goto ${returns};\n`;
            }

        }
        var r = [];
        r[0] = $1[0];
        r[1] = '';
        r[2] = '';
        r[3] = valor;
        r[5] = $1[5];
        r[6] = $1[6];
        $$ = r;
    }
;

Switch_statements
    : SWITCH '(' Expr ')' CaseBlock
    {
        switches = !switches;
        tab.deleteAmbitoLast();
        if(tab.ambitoLevel > 0) tab.ambitoLevel = tab.ambitoLevel-1;
        entorno = entorno.slice(0,-7);
        $$ = ['','','','','',''];
    }
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
    {
        var valor = '';
        var r = [];

        var label = Label.getBandera();
        if($3[0] != '')
        {
             valor += $3[3] +'\n';
             valor += `if(${$3[1]}==0) goto ${label};\n`;
             valor += $5[3] + '\n';
             valor += `${label}:\n`;
        }
        else
        {
            var n = tab.getPositionAmbito($3[4]);
            if(n!=null)
            {
                 var temp = Temp.getTemporal();
                 if(n.rol == 'Parametro')
                 {
                    valor += `${temp} = ${n.valor};\n`;
                 }
                 else
                 {
                    if(entorno == 'global')
                    {
                        valor += `${temp} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp} = stack[${n.position}];\n`;
                    }
                 }
                 valor += `if(${temp}==0) goto ${label};\n`;
                 valor += $5[3] + '\n';
                 valor += `${label}:\n`;
            }
        }

        ifs = !ifs;
        tab.deleteAmbitoLast();
        if(tab.ambitoLevel > 0) tab.ambitoLevel = tab.ambitoLevel-1;
        entorno = entorno.slice(0,-3);

        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = valor;
        r[4] = '';
        $$ = r;

    }
    | IF '(' Expr ')' Statement ELSE Statement
    {
        var valor = '';
        var r = [];

        var label = Label.getBandera();
        var label1 = Label.getBandera();

        if($3[0] != '')
        {
            valor += $3[3] +'\n';
            valor += `if(${$3[1]}==0) goto ${label};\n`;
            valor += $5[3] + '\n';
            valor += `goto ${label1};\n`;
            valor += `${label}:\n`;
            valor += $7[3] + '\n';
            valor += `goto ${label1};\n`
            valor += `${label1}:\n`;
        }
        else
        {
            var n = tab.getPositionAmbito($3[4]);
            if(n!=null)
            {
                 var temp = Temp.getTemporal();
                 if(n.rol == 'Parametro')
                 {
                    valor += `${temp} = ${n.valor};\n`;
                 }
                 else
                 {
                    if(entorno == 'global')
                    {
                        valor += `${temp} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp} = stack[${n.position}];\n`;
                    }
                 }

                valor += `if(${temp}==0) goto ${label};\n`;
                valor += $5[3] + '\n';
                valor += `goto ${label1};\n`;
                valor += `${label}:\n`;
                valor += $7[3] + '\n';
                valor += `goto ${label1};\n`
                valor += `${label1}:\n`;
            }
        }

        ifs = !ifs;
        tab.deleteAmbitoLast();
        if(tab.ambitoLevel > 0) tab.ambitoLevel = tab.ambitoLevel-1;
        entorno = entorno.slice(0,-3);

        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = valor;
        r[4] = '';
        $$ = r;

    }
;
Iteration_statements
    : DO Statement WHILE '(' Expr ')'
    {
        var valor = '';
        var r = [];
        var label;
        if(continues != '')
        {
            label = continues;
        }
        else
        {
            label = Label.getBandera();
        }

        var label1;
        if(breaks!= '')
        {
            label1 = breaks;
        }
        else
        {
            label1 = Label.getBandera();
        }

        if($2[3] != '')
        {

            if($3[0] != '')
            {
                valor += `${label}:\n`;
                valor += `${$2[3]}\n`;
                valor += `${$5[3]}\n`;
                valor += `if(${$5[1]}==0) goto ${label1};\n`;
                valor += `goto ${label};\n`;
                valor += `${label1}:\n`;
            }
            else
            {
                var n = tab.getPositionAmbito($3[4]);
                if(n!=null)
                {
                     valor += `${label}:\n`;
                     var temp = Temp.getTemporal();
                     if(n.rol == 'Parametro')
                     {
                        valor += `${temp} = ${n.valor};\n`;
                     }
                     else
                     {
                        if(entorno == 'global')
                        {
                            valor += `${temp} = heap[${n.position}];\n`;
                        }
                        else
                        {
                            valor += `${temp} = stack[${n.position}];\n`;
                        }
                     }

                    valor += `${$5[3]}\n`;
                    valor += `if(${temp}==0) goto ${label1};\n`;
                    valor += `goto ${label};\n`;
                    valor += `${label1}:\n`;
                }
            }

            does = !does;
            entorno = entorno.slice(0,-3);
            tab.deleteAmbitoLast();
            if(tab.ambitoLevel > 0) tab.ambitoLevel = tab.ambitoLevel-1;
            if(entorno.includes('do'))does = !does;

            r[0] = '';
            r[1] = '';
            r[2] = '';
            r[3] = valor;
            breaks = '';
            continues = '';
            $$ = r;


        }
        else
        {
            $$ = ['','','','',''];
        }

    }
    | WHILE '(' Expr ')' Statement
    {
        var valor = '';
        var r = [];
        var label;
        if(continues != '')
        {
            label = continues;
        }
        else
        {
            label = Label.getBandera();
        }

        var label1;
        if(breaks!= '')
        {
            label1 = breaks;
        }
        else
        {
            label1 = Label.getBandera();
        }
        if($3[0] != '')
        {
            valor += `${label}:\n`;
            valor += $3[3] + '\n';
            valor += `if(${$3[1]} == 0) goto ${label1};\n`;
            valor += $5[3] +'\n';
            valor += `goto ${label};\n`;
            valor += `${label1}:\n`;
        }
        else
        {
            var n = tab.getPositionAmbito($3[4]);
            if(n!=null)
            {
                 valor += `${label}:\n`;
                 var temp = Temp.getTemporal();
                 if(n.rol == 'Parametro')
                 {
                    valor += `${temp} = ${n.valor};\n`;
                 }
                 else
                 {
                    if(entorno == 'global')
                    {
                        valor += `${temp} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp} = stack[${n.position}];\n`;
                    }
                 }


                valor += `if(${temp} == 0) goto ${label1};\n`;
                valor += $5[3] +'\n';
                valor += `goto ${label};\n`;
                valor += `${label1}:\n`;
            }
        }

        whiles = !whiles;
        entorno = entorno.slice(0,-6);
        tab.deleteAmbitoLast();
        if(tab.ambitoLevel > 0) tab.ambitoLevel = tab.ambitoLevel-1;
        if(entorno.includes('while'))whiles = !whiles;

        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = valor;
        breaks = '';
        continues = '';
        $$ = r;

    }
    | FOR '(' ValStatement1 ';' ExprOpt ';' ExprOpt ')' Statement
    {
        var valor = '';
        var r = [];
        if($3[3] != '' && $5[3] != '' && $7[3] != '')
        {

            var label;
            if(continues != '')
            {
                label = continues;
            }
            else
            {
                label = Label.getBandera();
            }

            var label0 = Label.getBandera();

            var label1;
            if(breaks!= '')
            {
                label1 = breaks;
            }
            else
            {
                label1 = Label.getBandera();
            }

            valor += `${$3[3]}\n`;
            valor += `${label}:\n`;
            valor += $5[3] + '\n';
            valor += `if(${$5[1]} == 0) goto ${label1};\n`;
            valor += $9[3] + '\n';
            valor += `goto ${label0};\n`;
            valor += `${label0}:\n`;
            valor += $7[3] + '\n';
            valor += `goto ${label};\n`;
            valor += `${label1}:\n`;

            r[0] = '';
            r[1] = '';
            r[2] = '';
            r[3] = valor;
            breaks = '';
            continues = '';
            $$ = r;

            fores = !fores;
            entorno = entorno.slice(0,-4);
            tab.deleteAmbitoLast();
            console.log(tab.ambitoLevel);
            if(tab.ambitoLevel > 0) tab.ambitoLevel = tab.ambitoLevel-1;
            console.log(tab.ambitoLevel);
            if(entorno.includes('for'))fores = !fores;
        }
        else
        {
            $$ = ['','','','',''];
        }


    }
    | FOR '(' TypeV IDENT INTOKEN Expr ')' Statement
    {
        var valor = '';
        var r = [];

        if($6[0] == 'ARREGLO')
        {
            var k = $6[6].getValores();
            var temp = Temp.getTemporal();

            var temp1 = Temp.getTemporal();
            valor += temp1 + ' = ' + posA + ';\n';
            posA = posA + 5000;

            var temp2 = Temp.getTemporal();
            valor += `${temp2} = ${temp1} + 1;\n`;
            valor += `heap[(int) ${temp1}] = ${temp2};\n`;
            valor += `heap[(int)${temp2}] = ${k.length};\n`;



            valor += `${$6[1]} = ${temp1};\n`;
            valor += $6[3] + '\n';

            valor += `${temp} = ${k.length};\n`;
            var temp3 = Temp.getTemporal();
            valor += `${temp3} = -1;\n`;

            var label;
            if(continues != '')
            {
                label = continues;
            }
            else
            {
                label = Label.getBandera();
            }

            var label0 = Label.getBandera();

            var label1;
            if(breaks!= '')
            {
                label1 = breaks;
            }
            else
            {
                label1 = Label.getBandera();
            }

            var temp4 = Temp.getTemporal();

            var posicion = stac;
            valor += `${temp4} =  ${posicion};\n`;
            stac++;
            valor += 'stack[(int)'+ temp4 + '] = -1;\n';

            tab.ambitoLevel = tab.ambitoLevel + 1;
            entorno = entorno + '_forin';
            var sym = new intermedia.simbolo();
            sym.ambito = tab.ambitoLevel;
            sym.name = $4;
            sym.position = posicion;
            sym.rol = 'variable';
            sym.direccion = posicion;
            sym.direccionrelativa = posicion;
            sym.tipo = 'NUMBER';
            sym.valor = -1;
            sym.constante = false;
            if(entorno != 'global') sym.entorno = entorno ;
            tab.insert(sym);

            valor += `${label}:\n`;
            valor += `if(${temp3} == ${temp}) goto ${label1};\n`;
            valor += `${temp3} = ${temp3} + 1;\n`;
            valor += `stack[${posicion}] = ${temp3};\n`;
            valor += $8[3] + '\n';
            valor += `goto ${label};\n`;
            valor += `${label1}:\n`;

            r[0] = '';
            r[1] = '';
            r[2] = '';
            r[3] = valor;
            breaks = '';
            continues = '';
            $$ = r;

        }
        else if($6[0] == '')
        {

        }
        else
        {
            $$ = ['','','',''];
        }
    }
    | FOR '(' TypeV IDENT OFTOKEN Expr ')' Statement
;

ExprOpt
    :Expr
    {
        $$ = $1;
    }
;

ExprNoInOpt
    :ExprNoIn
    {
        $$ = $1;
    }
;

Expr
    : AssignmentExpr
    {
        $$ = $1;
    }
    | Expr ',' AssignmentExpr
    {
        var r  = [];
        r[0] = 'ARPRINT';
        r[1] = [];

        if($1[0] == 'ARPRINT')
        {
            for(let m of $1[1])
            {
                r[1].push(m);
            }
            r[1].push($3);
        }
        else
        {
            r[1].push($1);
            r[1].push($3);
        }
        $$ = r;

    }
;

ExprNoIn
    : AssignmentExprNoIn
    {
        $$ = $1;
    }
;

ExprNB
    : AssignmentExprNoBF
    {
        $$ = $1;
    }
;

ParameterList
    : PM
    {
        var s = eval('$$');
        var valor = '';
        var posm = 0;
        for(let param of $1)
        {
            var temp1 = Temp.getTemporal();
            valor += `${temp1} = P + ${posm};\n`;
            var temp = Temp.getTemporal();
            valor += `${temp} = stack[(int) ${temp1}];\n`;

            var sym = new intermedia.simbolo();
            sym.ambito = 0;
            sym.name = param[4];
            sym.position = posm;
            sym.rol = 'Parametro';
            sym.direccion = posm;
            sym.direccionrelativa = posm;
            sym.tipo = (param[7]=='')?'number':param[7];
            sym.valor = temp;
            sym.constante = false;
            sym.entorno = 'funcion_'+s[s.length-3];
            tab.insert(sym);

            posm++;
        }

        var sym = new intermedia.simbolo();
        sym.ambito = 0;
        sym.name = s[s.length-3];
        sym.position = -1;
        sym.rol = 'FUNCION';
        sym.direccion = -1;
        sym.direccionrelativa = -1;
        sym.valor = null;
        sym.constante = false;
        sym.entorno = 'global';
        sym.params = $1.length;
        tab.insert(sym);
        params = $1.length;

        entorno = 'funcion_'+s[s.length-3];
        tab.ambitoLevel = tab.ambitoLevel + 1;

        var r = [];
        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = valor;
        $$ = r;
    }
;

PM
    : PM ',' Parameter
    {
        $$ = $1;
        $$.push($3);
    }
    | Parameter
    {
        $$ = [];
        $$.push($1);
    }
;


Parameter
    : IDENT ':' Type
    {

        var r = [];
        r[0] = '';
        r[1] = '';
        r[2] = '';
        r[3] = '';
        r[4] = $1;
        r[5] = '';
        r[6] = '';
        r[7] = $3;
        $$ = r;
    }
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
        r[7] = '';
        $$ = r;
    }
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
    {
        $$ = $1;
    }
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
        var valor = '';
        valor += temp + ' = 1;';
        r[3] = valor;
        r[4] = '';
        r[5] = 1;
        r[6] = true;
        $$ = r;
    }
    | FALSETOKEN
    {
        var r = [];
        r[0] = 'BOOLEAN';
        var temp = Temp.getTemporal();
        r[1] = temp;
        r[2] = '';
        var valor = '';
        valor += temp + ' = 0;';
        r[3] = valor;
        r[4] = '';
        r[5] = 1;
        r[6] = false;
        $$ = r;
    }
    | NUMBER
    {
        var r = [];
        r[0] = "NUMBER";
        var temp = Temp.getTemporal();
        r[1] = temp;
        r[2] = '';
        var valor = '';
        valor += temp + ' = ' + $1 + ';';
        r[3] = valor;
        r[4] = '';
        r[5] = $1;
        r[6] = Number($1);
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
            valor += 'heap[(int)'+temp+'] = ' + $1.charCodeAt(a) + ';';
            valor += '\n';
        }
        r[3] = valor;
        r[4] = '';
        r[5] = $1;
        r[6] = $1;

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
            valor += 'heap[(int)'+temp+'] = ' + $1.charCodeAt(a) + ';';
            valor += '\n'
        }
        r[3] = valor;
        r[4] = '';
        r[5] = $1;
        r[6] = $1;

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
    {
        $$ = ['','','','','','']
    }
    | OPENBRACE PropertyList CLOSEBRACE
    {
        $$ = ['','','','','','']
    }
;

PrimaryExprNoBrace
    : Literal
    {
        $$ = $1;
    }
    | ArrayLiteral
    {
        $$ = $1;
    }
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
    {
        $$ = $2;
    }
    | Expr1_statements
    {
        $$ = $1;
    }
;

Expr1_statement
    : Expr1_statement ArrList
    {
        $$ = ['','','','','','','','','','','','','','',''];
    }
    | Expr1_statement '.' IDENT
    {
        $$ = ['','','','','','','','','','','','','','',''];
    }
    | '.' IDENT
    {
        $$ = ['','','','','','','','','','','','','','',''];
    }
    | ArrList
    {
        $$ = $1;
    }

;



ArrList
    : ArrList Arr
    {
        $$ = $1;
        var r = [];
        r[10] = 'ARRPOS';
        r[11] = $$.length+1;
        r[12] = $2;
        $$.push(r);
    }
    | Arr
    {
        var r = [];
        r[10] = 'ARRPOS';
        r[11] = 1;
        r[12] = $1;
        $$ = [];
        $$.push(r);

    }
;

Arr
    : '[' Expr ']'
    {
        $$ = $2;
    }
;


Expr1_statements
    : IDENT Expr1_statement
    {

         var n = tab.getPositionAmbito($1);
         var arres = [];
         var poses = [];
         var elpepe = [];
         if(n!=null)
         {
             var valor = '';
             var temp  = Temp.getTemporal();
             var l = arr.getProf($1);
             var posss = 0;
             var pass = false;
             if(l>=$2.length)
             {
                 var nivel = 1;
                 for(let posi of $2)
                 {
                     var m = arr.getTam($1,nivel);



                     if(posi[12][0] != '')
                     {
                         if(posi[12][0].toUpperCase() == 'NUMBER')
                         {
                             var num = posi[12][6];
                             if(num <= (m-1))
                             {
                                 arres.push(m);
                                 poses.push(posi[12][1]);
                                 valor += posi[12][3] + '\n';
                                 posss = posss * m + num;
                                 elpepe.push(num);
                                 pass = true;
                             }
                             else
                             {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${posi[12][6]}`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                             }
                         }
                         else
                          {
                              pass = false;
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion`+'\"}');
                              $$ = ['','','',''];
                              break;
                          }
                     }
                     else
                     {
                        var n1 = tab.getPositionAmbito(posi[12][4]);
                        if(n1!=null)
                        {
                            if(n1.rol.toUpperCase() != 'ARREGLO')
                            {
                                if(n1.tipo.toUpperCase() == 'NUMBER')
                                {
                                     var num = Number(n1.valor);
                                     if(num <= (m-1))
                                     {
                                         arres.push(m);

                                         var temp = Temp.getTemporal();
                                         posss = posss * m + n1.valor;
                                         poses.push(temp);
                                         elpepe.push(n1.valor);
                                         if(n1.entorno == 'global')
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         else
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         pass = true;
                                     }
                                     else
                                     {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${n1.valor}`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                     }
                                }
                                else
                                {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                }
                            }
                            else
                            {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                            }

                        }
                        else
                        {
                             pass = false;
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, variable no existe: ${posi[12][0]}`+'\"}');
                             $$ = ['','','',''];
                             break;
                        }

                     }
                     nivel++;
                 }
                 if(pass)
                 {
                    var temp0 = Temp.getTemporal();
                    var temp = Temp.getTemporal();
                    var temp1 = Temp.getTemporal();
                    var temp2 = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp1} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp1} = stack[${n.position}];\n`;
                    }
                    valor += `${temp2} = heap[(int)${temp1}] + 1;\n`;

                    valor += `${temp} = ${poses[0]} + ${temp2};\n`

                    for(var a = 1; a<arres.length; a++)
                    {
                        valor += `${temp0} = ${temp} * ${arres[a-1]};\n`;
                        valor += `${temp} = ${temp0} + ${poses[a]};\n`;
                        valor += `${temp} = heap[(int) ${temp}] +2;\n`;
                    }

                    //var temp3 = Temp.getTemporal();
                    //valor += `${temp3} = ${temp2};\n`;

                    //var temp4 = Temp.getTemporal();
                    //valor += `${temp4} = heap[(int)${temp}];\n`;

                   var temp5 = Temp.getTemporal();
                   var temp6 = Temp.getTemporal();

                   valor += `${temp5} = ${temp2} + ${poses[0]};\n`;
                   for(var a = 1; a<poses.length; a++)
                   {
                       valor += `${temp6} = heap[(int) ${temp5}] + 2;\n`;
                       valor += `${temp5} = ${temp6} + ${poses[a]};\n`;
                   }

                   valor += `${temp6} = heap[(int) ${temp5}];\n`;

                    var arrayss = arr.getValores(n.name);
                    //console.log(arrayss);
                    //console.log(arrayss[posss]);
                    var arrayssL = arr.getValoresL(n.name);
                    var value = arr.getValue(n.name, elpepe);

                    var arre = '';


                    var r = [];
                    r[0] = (l==$2.length)?(typeof arrayss[0]).toString().toUpperCase():'ARREGLO';
                    r[1] = temp6;
                    r[2] = '';
                    r[3] = (l==$2.length)?valor:arre;
                    r[4] = '';
                    r[5] = (l==$2.length)?arrayss[posss]:value;
                    r[6] = (l==$2.length)?arrayss[posss]:value;
                    $$ = r;

                 }
                 else
                 {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                    $$ = ['','','',''];
                 }
             }
             else
             {
                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, tamaño muy grande para el arreglo ${$1}, el tamaño del arreglo es de: ${l}`+'\"}');
                 $$ = ['','','',''];
             }
         }
         else
         {
              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
              $$ = ['','','',''];
         }
    }
    | IDENT  PLUSPLUS
    {
        var n = tab.getPositionAmbito($1);
        if(n!=null)
        {
            if(n.tipo.toUpperCase() == 'NUMBER')
            {
                var r = [];
                var valor = '';
                var temp = Temp.getTemporal();
                if(n.entorno == 'global')
                {
                    valor += `${temp} = heap[${n.position}];\n`;
                }
                else
                {
                    valor += `${temp} = stack[${n.position}];\n`;
                }
                var temp1 = Temp.getTemporal();
                valor += `${temp1} = ${temp} + 1;\n`;
                if(n.entorno == 'global')
                {
                    valor += `heap[${n.position}] = ${temp1};\n`;
                }
                else
                {
                    valor += `stack[${n.position}] = ${temp1};\n`;
                }

                n.valor = n.valor + 1;
                tab.update(n.name,n);

                var r = [];
                r[0] = "NUMBER";
                r[1] = temp;
                r[2] = ''
                r[3] = valor;
                r[4] = '';
                r[5] = n.valor;
                r[6] = n.valor;
                r[7] = '';
                r[8] = '';

                $$ = r;
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IDENT  MINSMINS
    {
        var n = tab.getPositionAmbito($1);
        if(n!=null)
        {
            if(n.tipo.toUpperCase() == 'NUMBER')
            {
                var r = [];
                var valor = '';
                var temp = Temp.getTemporal();
                if(n.entorno == 'global')
                {
                    valor += `${temp} = heap[${n.position}];\n`;
                }
                else
                {
                    valor += `${temp} = stack[${n.position}];\n`;
                }
                var temp1 = Temp.getTemporal();
                valor += `${temp1} = ${temp} - 1;\n`;
                if(n.entorno == 'global')
                {
                    valor += `heap[${n.position}] = ${temp1};\n`;
                }
                else
                {
                    valor += `stack[${n.position}] = ${temp1};\n`;
                }

                n.valor = n.valor - 1;
                tab.update(n.name,n);

                var r = [];
                r[0] = "NUMBER";
                r[1] = temp;
                r[2] = ''
                r[3] = valor;
                r[4] = '';
                r[5] = n.valor;
                r[6] = n.valor;
                r[7] = '';
                r[8] = '';

                $$ = r;
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
            $$ = ['','','',''];
        }
    }
    | MINSMINS IDENT
    {
        var n = tab.getPositionAmbito($2);
        if(n!=null)
        {
            if(n.tipo.toUpperCase() == 'NUMBER')
            {
                var r = [];
                var valor = '';
                var temp = Temp.getTemporal();
                if(n.entorno == 'global')
                {
                    valor += `${temp} = heap[${n.position}];\n`;
                }
                else
                {
                    valor += `${temp} = stack[${n.position}];\n`;
                }
                var temp1 = Temp.getTemporal();
                valor += `${temp1} = ${temp} - 1;\n`;
                if(n.entorno == 'global')
                {
                    valor += `heap[${n.position}] = ${temp1};\n`;
                }
                else
                {
                    valor += `stack[${n.position}] = ${temp1};\n`;
                }

                n.valor = n.valor - 1;
                tab.update(n.name,n);

                var r = [];
                r[0] = "NUMBER";
                r[1] = temp1;
                r[2] = ''
                r[3] = valor;
                r[4] = '';
                r[5] = n.valor;
                r[6] = n.valor;
                r[7] = '';
                r[8] = '';

                $$ = r;
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
            $$ = ['','','',''];
        }
    }
    | PLUSPLUS IDENT
    {
        var n = tab.getPositionAmbito($2);
        if(n!=null)
        {
            if(n.tipo.toUpperCase() == 'NUMBER')
            {
                var r = [];
                var valor = '';
                var temp = Temp.getTemporal();
                if(n.entorno == 'global')
                {
                    valor += `${temp} = heap[${n.position}];\n`;
                }
                else
                {
                    valor += `${temp} = stack[${n.position}];\n`;
                }
                var temp1 = Temp.getTemporal();
                valor += `${temp1} = ${temp} + 1;\n`;
                if(n.entorno == 'global')
                {
                    valor += `heap[${n.position}] = ${temp1};\n`;
                }
                else
                {
                    valor += `stack[${n.position}] = ${temp1};\n`;
                }

                n.valor = n.valor + 1;
                tab.update(n.name,n);

                var r = [];
                r[0] = "NUMBER";
                r[1] = temp1;
                r[2] = ''
                r[3] = valor;
                r[4] = '';
                r[5] = n.valor;
                r[6] = n.valor;
                r[7] = '';
                r[8] = '';

                $$ = r;
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IDENT Expr1_statement PLUSPLUS
    {
         var n = tab.getPositionAmbito($1);
         var arres = [];
         var poses = [];
         if(n!=null)
         {
             var valor = '';
             var temp  = Temp.getTemporal();
             var l = arr.getProf($1);
             var posss = 0;

             if(l>=$2.length)
             {
                 var nivel = 1;
                 for(let posi of $2)
                 {
                     var m = arr.getTam($1,nivel);

                     var pass = false;

                     if(posi[12][0] != '')
                     {
                         if(posi[12][0].toUpperCase() == 'NUMBER')
                         {
                             var num = posi[12][6];
                             if(num <= (m-1))
                             {
                                 arres.push(m);
                                 poses.push(posi[12][1]);
                                 valor += posi[12][3] + '\n';
                                 posss = posss * m + num;
                                 pass = true;
                             }
                             else
                             {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${posi[12][6]}`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                             }
                         }
                         else
                          {
                              pass = false;
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion`+'\"}');
                              $$ = ['','','',''];
                              break;
                          }
                     }
                     else
                     {
                        var n1 = tab.getPositionAmbito(posi[12][4]);
                        if(n1!=null)
                        {
                            if(n1.rol.toUpperCase() != 'ARREGLO')
                            {
                                if(n1.tipo.toUpperCase() == 'NUMBER')
                                {
                                     var num = Number(n1.valor);
                                     if(num <= (m-1))
                                     {
                                         arres.push(m);

                                         var temp = Temp.getTemporal();
                                         posss = posss * m + n1.valor;
                                         poses.push(temp);
                                         if(n1.entorno == 'global')
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         else
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         pass = true;
                                     }
                                     else
                                     {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${n1.valor}`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                     }
                                }
                                else
                                {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                }
                            }
                            else
                            {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                            }

                        }
                        else
                        {
                             pass = false;
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, variable no existe: ${posi[12][0]}`+'\"}');
                             $$ = ['','','',''];
                             break;
                        }

                     }
                     nivel++;
                 }
                 if(pass)
                 {
                    var temp0 = Temp.getTemporal();
                    var temp = Temp.getTemporal();

                    valor += `${temp} = ${poses[0]};\n`

                    for(var a = 1; a<arres.length; a++)
                    {
                        valor += `${temp0} = ${temp} * ${arres[a-1]};\n`;
                        valor += `${temp} = ${temp0} + ${poses[a]};\n`;
                        valor += `${temp} = heap[(int) ${temp}] +2;\n`;
                    }

                    var temp1 = Temp.getTemporal();
                    var temp2 = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp1} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp1} = stack[${n.position}];\n`;
                    }
                    valor += `${temp2} = heap[(int)${temp1}] + 1;\n`;

                    var temp3 = Temp.getTemporal();
                    valor += `${temp3} = ${temp2} + ${temp};\n`;

                    var temp4 = Temp.getTemporal();
                    valor += `${temp4} = heap[(int)${temp3}];\n`;

                   var temp5 = Temp.getTemporal();
                   var temp6 = Temp.getTemporal();

                   valor += `${temp5} = ${temp2} + ${poses[0]};\n`;
                   for(var a = 1; a<poses.length; a++)
                   {
                       valor += `${temp6} = heap[(int) ${temp5}] + 2;\n`;
                       valor += `${temp5} = ${temp6} + ${poses[a]};\n`;
                   }

                   valor += `${temp6} = heap[(int) ${temp5}];\n`;


                    var arrayss = arr.getValores(n.name);
                    if(typeof arrayss[0] == 'number')
                    {
                        var temp7 = Temp.getTemporal();
                        valor += `${temp7} = ${temp6} + 1;\n`;
                        valor += `heap[(int) ${temp5}] = ${temp7};\n`;

                        var r = [];
                        r[0] = typeof arrayss[0];
                        r[1] = temp6;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = arrayss[posss];
                        r[6] = arrayss[posss];
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion, tipo invalido: ${typeof arrayss[0]}`+'\"}');
                        $$ = ['','','',''];
                    }
                 }
                 else
                 {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                    $$ = ['','','',''];
                 }
             }
             else
             {
                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, tamaño muy grande para el arreglo ${$1}, el tamaño del arreglo es de: ${l}`+'\"}');
                 $$ = ['','','',''];
             }
         }
         else
         {
              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
              $$ = ['','','',''];
         }
    }
    | IDENT Expr1_statement MINSMINS
    {
         var n = tab.getPositionAmbito($1);
         var arres = [];
         var poses = [];
         if(n!=null)
         {
             var valor = '';
             var temp  = Temp.getTemporal();
             var l = arr.getProf($1);
             var posss = 0;
             if(l>=$2.length)
             {
                 var nivel = 1;
                 for(let posi of $2)
                 {
                     var m = arr.getTam($1,nivel);

                     var pass = false;

                     if(posi[12][0] != '')
                     {
                         if(posi[12][0].toUpperCase() == 'NUMBER')
                         {
                             var num = posi[12][6];
                             if(num <= (m-1))
                             {
                                 arres.push(m);
                                 poses.push(posi[12][1]);
                                 valor += posi[12][3] + '\n';
                                 posss = posss * m + num;
                                 pass = true;
                             }
                             else
                             {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${posi[12][6]}`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                             }
                         }
                         else
                          {
                              pass = false;
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion`+'\"}');
                              $$ = ['','','',''];
                              break;
                          }
                     }
                     else
                     {
                        var n1 = tab.getPositionAmbito(posi[12][4]);
                        if(n1!=null)
                        {
                            if(n1.rol.toUpperCase() != 'ARREGLO')
                            {
                                if(n1.tipo.toUpperCase() == 'NUMBER')
                                {
                                     var num = Number(n1.valor);
                                     if(num <= (m-1))
                                     {
                                         arres.push(m);

                                         var temp = Temp.getTemporal();
                                         posss = posss * m + n1.valor;
                                         poses.push(temp);
                                         if(n1.entorno == 'global')
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         else
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         pass = true;
                                     }
                                     else
                                     {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${n1.valor}`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                     }
                                }
                                else
                                {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                }
                            }
                            else
                            {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                            }

                        }
                        else
                        {
                             pass = false;
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, variable no existe: ${posi[12][0]}`+'\"}');
                             $$ = ['','','',''];
                             break;
                        }

                     }
                     nivel++;
                 }
                 if(pass)
                 {
                    var temp0 = Temp.getTemporal();
                    var temp = Temp.getTemporal();

                    valor += `${temp} = ${poses[0]};\n`

                    for(var a = 1; a<arres.length; a++)
                    {
                        valor += `${temp0} = ${temp} * ${arres[a-1]};\n`;
                        valor += `${temp} = ${temp0} + ${poses[a]};\n`;
                        valor += `${temp} = heap[(int) ${temp}] +2;\n`;
                    }

                    var temp1 = Temp.getTemporal();
                    var temp2 = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp1} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp1} = stack[${n.position}];\n`;
                    }
                    valor += `${temp2} = heap[(int)${temp1}] + 1;\n`;

                    var temp3 = Temp.getTemporal();
                    valor += `${temp3} = ${temp2} + ${temp};\n`;

                    var temp4 = Temp.getTemporal();
                    valor += `${temp4} = heap[(int)${temp3}];\n`;

                   var temp5 = Temp.getTemporal();
                   var temp6 = Temp.getTemporal();

                   valor += `${temp5} = ${temp2} + ${poses[0]};\n`;
                   for(var a = 1; a<poses.length; a++)
                   {
                       valor += `${temp6} = heap[(int) ${temp5}] + 2;\n`;
                       valor += `${temp5} = ${temp6} + ${poses[a]};\n`;
                   }

                   valor += `${temp6} = heap[(int) ${temp5}];\n`;


                    var arrayss = arr.getValores(n.name);
                    if(typeof arrayss[0] == 'number')
                    {
                        var temp7 = Temp.getTemporal();
                        valor += `${temp7} = ${temp6} - 1;\n`;
                        valor += `heap[(int) ${temp5}] = ${temp7};\n`;

                        var r = [];
                        r[0] = typeof arrayss[0];
                        r[1] = temp6;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = arrayss[posss];
                        r[6] = arrayss[posss];
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion, tipo invalido: ${typeof arrayss[0]}`+'\"}');
                        $$ = ['','','',''];
                    }
                 }
                 else
                 {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                    $$ = ['','','',''];
                 }
             }
             else
             {
                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, tamaño muy grande para el arreglo ${$1}, el tamaño del arreglo es de: ${l}`+'\"}');
                 $$ = ['','','',''];
             }
         }
         else
         {
              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
              $$ = ['','','',''];
         }
    }
    | MINSMINS IDENT Expr1_statement
    {
         var n = tab.getPositionAmbito($1);
         var arres = [];
         var poses = [];
         if(n!=null)
         {
             var valor = '';
             var temp  = Temp.getTemporal();
             var l = arr.getProf($1);
             var posss = 0;

             if(l>=$2.length)
             {
                 var nivel = 1;
                 for(let posi of $2)
                 {
                     var m = arr.getTam($1,nivel);

                     var pass = false;

                     if(posi[12][0] != '')
                     {
                         if(posi[12][0].toUpperCase() == 'NUMBER')
                         {
                             var num = posi[12][6];
                             if(num <= (m-1))
                             {
                                 arres.push(m);
                                 poses.push(posi[12][1]);
                                 valor += posi[12][3] + '\n';
                                 posss = posss * m + num;
                                 pass = true;
                             }
                             else
                             {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${posi[12][6]}`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                             }
                         }
                         else
                          {
                              pass = false;
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion`+'\"}');
                              $$ = ['','','',''];
                              break;
                          }
                     }
                     else
                     {
                        var n1 = tab.getPositionAmbito(posi[12][4]);
                        if(n1!=null)
                        {
                            if(n1.rol.toUpperCase() != 'ARREGLO')
                            {
                                if(n1.tipo.toUpperCase() == 'NUMBER')
                                {
                                     var num = Number(n1.valor);
                                     if(num <= (m-1))
                                     {
                                         arres.push(m);

                                         var temp = Temp.getTemporal();
                                         posss = posss * m + n1.valor;
                                         poses.push(temp);
                                         if(n1.entorno == 'global')
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         else
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         pass = true;
                                     }
                                     else
                                     {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${n1.valor}`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                     }
                                }
                                else
                                {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                }
                            }
                            else
                            {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                            }

                        }
                        else
                        {
                             pass = false;
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, variable no existe: ${posi[12][0]}`+'\"}');
                             $$ = ['','','',''];
                             break;
                        }

                     }
                     nivel++;
                 }
                 if(pass)
                 {
                    var temp0 = Temp.getTemporal();
                    var temp = Temp.getTemporal();

                    valor += `${temp} = ${poses[0]};\n`

                    for(var a = 1; a<arres.length; a++)
                    {
                        valor += `${temp0} = ${temp} * ${arres[a-1]};\n`;
                        valor += `${temp} = ${temp0} + ${poses[a]};\n`;
                        valor += `${temp} = heap[(int) ${temp}] +2;\n`;
                    }

                    var temp1 = Temp.getTemporal();
                    var temp2 = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp1} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp1} = stack[${n.position}];\n`;
                    }
                    valor += `${temp2} = heap[(int)${temp1}] + 1;\n`;

                    var temp3 = Temp.getTemporal();
                    valor += `${temp3} = ${temp2} + ${temp};\n`;

                    var temp4 = Temp.getTemporal();
                    valor += `${temp4} = heap[(int)${temp3}];\n`;

                   var temp5 = Temp.getTemporal();
                   var temp6 = Temp.getTemporal();

                   valor += `${temp5} = ${temp2} + ${poses[0]};\n`;
                   for(var a = 1; a<poses.length; a++)
                   {
                       valor += `${temp6} = heap[(int) ${temp5}] + 2;\n`;
                       valor += `${temp5} = ${temp6} + ${poses[a]};\n`;
                   }

                   valor += `${temp6} = heap[(int) ${temp5}];\n`;


                    var arrayss = arr.getValores(n.name);
                    if(typeof arrayss[0] == 'number')
                    {
                        var temp7 = Temp.getTemporal();
                        valor += `${temp7} = ${temp6} - 1;\n`;
                        valor += `heap[(int) ${temp5}] = ${temp7};\n`;

                        var r = [];
                        r[0] = typeof arrayss[0];
                        r[1] = temp7;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = arrayss[posss];
                        r[6] = arrayss[posss];
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion, tipo invalido: ${typeof arrayss[0]}`+'\"}');
                        $$ = ['','','',''];
                    }
                 }
                 else
                 {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                    $$ = ['','','',''];
                 }
             }
             else
             {
                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, tamaño muy grande para el arreglo ${$1}, el tamaño del arreglo es de: ${l}`+'\"}');
                 $$ = ['','','',''];
             }
         }
         else
         {
              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
              $$ = ['','','',''];
         }
    }
    | PLUSPLUS IDENT Expr1_statement
    {
         var n = tab.getPositionAmbito($1);
         var arres = [];
         var poses = [];
         if(n!=null)
         {
             var valor = '';
             var temp  = Temp.getTemporal();
             var l = arr.getProf($1);
             var posss = 0;

             if(l>=$2.length)
             {
                 var nivel = 1;
                 for(let posi of $2)
                 {
                     var m = arr.getTam($1,nivel);

                     var pass = false;

                     if(posi[12][0] != '')
                     {
                         if(posi[12][0].toUpperCase() == 'NUMBER')
                         {
                             var num = posi[12][6];
                             if(num <= (m-1))
                             {
                                 arres.push(m);
                                 poses.push(posi[12][1]);
                                 valor += posi[12][3] + '\n';
                                 posss = posss * m + num;
                                 pass = true;
                             }
                             else
                             {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${posi[12][6]}`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                             }
                         }
                         else
                          {
                              pass = false;
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion`+'\"}');
                              $$ = ['','','',''];
                              break;
                          }
                     }
                     else
                     {
                        var n1 = tab.getPositionAmbito(posi[12][4]);
                        if(n1!=null)
                        {
                            if(n1.rol.toUpperCase() != 'ARREGLO')
                            {
                                if(n1.tipo.toUpperCase() == 'NUMBER')
                                {
                                     var num = Number(n1.valor);
                                     if(num <= (m-1))
                                     {
                                         arres.push(m);

                                         var temp = Temp.getTemporal();
                                         posss = posss * m + n1.valor;
                                         poses.push(temp);
                                         if(n1.entorno == 'global')
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         else
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         pass = true;
                                     }
                                     else
                                     {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${n1.valor}`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                     }
                                }
                                else
                                {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                }
                            }
                            else
                            {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                            }

                        }
                        else
                        {
                             pass = false;
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, variable no existe: ${posi[12][0]}`+'\"}');
                             $$ = ['','','',''];
                             break;
                        }

                     }
                     nivel++;
                 }
                 if(pass)
                 {
                    var temp0 = Temp.getTemporal();
                    var temp = Temp.getTemporal();

                    valor += `${temp} = ${poses[0]};\n`

                    for(var a = 1; a<arres.length; a++)
                    {
                        valor += `${temp0} = ${temp} * ${arres[a-1]};\n`;
                        valor += `${temp} = ${temp0} + ${poses[a]};\n`;
                        valor += `${temp} = heap[(int) ${temp}] +2;\n`;
                    }

                    var temp1 = Temp.getTemporal();
                    var temp2 = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp1} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp1} = stack[${n.position}];\n`;
                    }
                    valor += `${temp2} = heap[(int)${temp1}] + 1;\n`;

                    var temp3 = Temp.getTemporal();
                    valor += `${temp3} = ${temp2} + ${temp};\n`;

                    var temp4 = Temp.getTemporal();
                    valor += `${temp4} = heap[(int)${temp3}];\n`;

                   var temp5 = Temp.getTemporal();
                   var temp6 = Temp.getTemporal();

                   valor += `${temp5} = ${temp2} + ${poses[0]};\n`;
                   for(var a = 1; a<poses.length; a++)
                   {
                       valor += `${temp6} = heap[(int) ${temp5}] + 2;\n`;
                       valor += `${temp5} = ${temp6} + ${poses[a]};\n`;
                   }

                   valor += `${temp6} = heap[(int) ${temp5}];\n`;


                    var arrayss = arr.getValores(n.name);
                    if(typeof arrayss[0] == 'number')
                    {
                        var temp7 = Temp.getTemporal();
                        valor += `${temp7} = ${temp6} + 1;\n`;
                        valor += `heap[(int) ${temp5}] = ${temp7};\n`;

                        var r = [];
                        r[0] = typeof arrayss[0];
                        r[1] = temp7;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = arrayss[posss];
                        r[6] = arrayss[posss];
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion, tipo invalido: ${typeof arrayss[0]}`+'\"}');
                        $$ = ['','','',''];
                    }
                 }
                 else
                 {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                    $$ = ['','','',''];
                 }
             }
             else
             {
                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, tamaño muy grande para el arreglo ${$1}, el tamaño del arreglo es de: ${l}`+'\"}');
                 $$ = ['','','',''];
             }
         }
         else
         {
              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
              $$ = ['','','',''];
         }
    }
    | IDENT '.' TOUPPER '(' ')'
    {
        var n = tab.getPositionAmbito($1);
        if(n!=null)
        {
            if(n.tipo.toUpperCase() == 'STRING')
            {

                    var valor = '';
                    var temp = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp} = stack[${n.position}];\n`;
                    }
                    valor += `${temp} = ${temp} + 1;\n`;
                    var temp1 = Temp.getTemporal();
                    valor += `${temp1} = heap[(int)${temp}];\n`;
                    valor += `${temp} = ${temp} + 1;\n`;
                    var temp2  = Temp.getTemporal();
                    valor += `${temp2} = 0;\n`;

                    var r = [];
                    var label = Label.getBandera();
                    var label1 = Label.getBandera();
                    var label2 = Label.getBandera();
                    var label3 = Label.getBandera();
                    var temp3 = Temp.getTemporal();
                    var temp4 = Temp.getTemporal();

                    valor += `${label}:\n`;
                    valor += `\tif(${temp2}==${temp1}) goto ${label1};\n`;
                    valor += `\t${temp4} = ${temp} + ${temp2};\n`
                    valor += `\t${temp3} = heap[(int)${temp4}];\n`;
                    valor += `\tif(${temp3}>=97) goto ${label2};\n`;
                    valor += `\t${temp2} = ${temp2} + 1;\n`;
                    valor += `\tgoto ${label};\n`;
                    valor += `${label2}:\n`;
                    valor += `\tif(${temp3}<=122) goto ${label3};\n`;
                    valor += `\t${temp2} = ${temp2} + 1;\n`;
                    valor += `\tgoto ${label};\n`;
                    valor += `${label3}:\n`;
                    valor += `\t${temp3} = ${temp3} - 32;\n`;
                    valor += `\theap[(int)${temp4}] = ${temp3};\n`;
                    valor += `\t${temp2} = ${temp2} + 1;\n`;
                    valor += `\tgoto ${label};\n`;
                    valor += `${label1}:\n`;

                    n.valor = n.valor.toString().toUpperCase();

                    tab.update(n.name,n);
                    r[0] = "STRING";
                    r[1] = temp2;
                    r[2] = label1;
                    r[3] = valor;
                    r[4] = '';
                    r[7] = '';
                    r[8] = '';

                    $$ = r;

            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, la variable no es de tipo string`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
             $$ = ['','','',''];
        }
    }
    | IDENT '.' TOLOWER '(' ')'
    {
        var n = tab.getPositionAmbito($1);
        if(n!=null)
        {
            if(n.tipo.toUpperCase() == 'STRING')
            {

                    var valor = '';
                    var temp = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp} = stack[${n.position}];\n`;
                    }
                    valor += `${temp} = ${temp} + 1;\n`;
                    var temp1 = Temp.getTemporal();
                    valor += `${temp1} = heap[(int)${temp}];\n`;
                    valor += `${temp} = ${temp} + 1;\n`;
                    var temp2  = Temp.getTemporal();
                    valor += `${temp2} = 0;\n`;

                    var r = [];
                    var label = Label.getBandera();
                    var label1 = Label.getBandera();
                    var label2 = Label.getBandera();
                    var label3 = Label.getBandera();
                    var temp3 = Temp.getTemporal();
                    var temp4 = Temp.getTemporal();

                    valor += `${label}:\n`;
                    valor += `\tif(${temp2}==${temp1}) goto ${label1};\n`;
                    valor += `\t${temp4} = ${temp} + ${temp2};\n`
                    valor += `\t${temp3} = heap[(int)${temp4}];\n`;
                    valor += `\tif(${temp3}>=65) goto ${label2};\n`;
                    valor += `\t${temp2} = ${temp2} + 1;\n`;
                    valor += `\tgoto ${label};\n`;
                    valor += `${label2}:\n`;
                    valor += `\tif(${temp3}<=90) goto ${label3};\n`;
                    valor += `\t${temp2} = ${temp2} + 1;\n`;
                    valor += `\tgoto ${label};\n`;
                    valor += `${label3}:\n`;
                    valor += `\t${temp3} = ${temp3} + 32;\n`;
                    valor += `\theap[(int)${temp4}] = ${temp3};\n`;
                    valor += `\t${temp2} = ${temp2} + 1;\n`;
                    valor += `\tgoto ${label};\n`;
                    valor += `${label1}:\n`;

                    n.valor = n.valor.toString().toLowerCase();

                    tab.update(n.name,n);
                    r[0] = "STRING";
                    r[1] = temp2;
                    r[2] = label1;
                    r[3] = valor;
                    r[4] = '';
                    r[7] = '';
                    r[8] = '';

                    $$ = r;

            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, la variable no es de tipo string`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
             $$ = ['','','',''];
        }
    }
    | IDENT '.' LENGTH
     {
        var n = tab.getPositionAmbito($1);
        if(n!=null)
        {
            if(n.rol.toUpperCase() == 'ARREGLO')
            {
                 var valor = '';
                 var temp1 = Temp.getTemporal();
                 valor += temp1 + ' = ' + n.position +';';
                 valor += '\n';
                 var temp2 = Temp.getTemporal();
                 var temp3 = Temp.getTemporal();
                 if(n.entorno == 'global')
                 {
                     valor += temp2 + ' = heap[(int)'+temp1+'];';
                     valor += '\n';
                 }
                 else
                 {
                     valor += temp2 + ' = stack[(int)'+temp1+'];';
                     valor += '\n';
                 }

                 valor += temp3+' = heap[(int)' + temp2 +'];';
                 valor += '\n';
                 var k = arr.getTamposd($1);
                 valor += `${temp2} = ${k};\n`

                 var r = [];
                 r[0] = "NUMBER";
                 r[1] = temp2;
                 r[2] = ''
                 r[3] = valor;
                 r[4] = '';
                 r[5] = Number(arr.getTamposd($1));
                 r[6] = Number(arr.getTamposd($1));
                 r[7] = '';
                 r[8] = '';

                 $$ = r;

            }
            else
            {
                if(n.tipo.toUpperCase() == 'STRING')
                {
                      var valor = '';
                      var temp1 = Temp.getTemporal();
                      valor += temp1 + ' = ' + n.position +';';
                      valor += '\n';
                      var temp2 = Temp.getTemporal();
                      var temp3 = Temp.getTemporal();
                      if(n.entorno == 'global')
                      {
                          valor += temp2 + ' = heap[(int)'+temp1+'];';
                          valor += '\n';
                      }
                      else
                      {
                          valor += temp2 + ' = stack[(int)'+temp1+'];';
                          valor += '\n';
                      }

                      valor += temp3+' = heap[(int)' + temp2 +'];';
                      valor += '\n';
                      valor += `${temp2} = heap[(int)${temp3}];`

                      var r = [];
                      r[0] = "NUMBER";
                      r[1] = temp2;
                      r[2] = ''
                      r[3] = valor;
                      r[4] = '';
                      r[5] = n.valor.length;
                      r[6] = n.valor.length;
                      r[7] = '';
                      r[8] = '';

                      $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
             $$ = ['','','',''];
        }
     }
    | IDENT '.' CONCAT '(' Expr ')'
    {
        var n = tab.getPositionAmbito($1);

        if(n!=null)
        {
            if(n.tipo.toUpperCase() == 'STRING')
            {
                var expr = $5;

                    var valor = '';
                    var temp = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp} = stack[${n.position}];\n`;
                    }
                    valor += `${temp} = ${temp} + 1;\n`;
                    var temp1 = Temp.getTemporal();
                    valor += `${temp1} = heap[(int)${temp}];\n`;
                    var temp2  = Temp.getTemporal();
                    valor += `${temp2} = ${temp} + ${temp1};\n`;
                    var r = [];

                    if(expr[0].toUpperCase() != '')
                    {
                        for(var a = 0; a<expr[5].toString().length; a++)
                        {
                            valor += `${temp2} = ${temp2} + 1;\n`;
                            valor += `heap[(int)${temp2}] = ${expr[5].toString().charCodeAt(a)};\n`
                        }
                        valor += `${temp1} = ${temp1} + ${expr[5].toString().length};\n`;
                        valor += `heap[(int)${temp}] = ${temp1};\n`;
                        r[5] = n.valor.toString() + expr[5].toString();
                        r[6] = n.valor.toString() + expr[5].toString();
                        n.valor = n.valor.toString() + expr[5].toString();

                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito(expr[4]);
                        if(n1!=null)
                        {
                            if(n1.rol != 'ARREGLO')
                            {
                                 for(var a = 0; a<n1.valor.toString().length; a++)
                                {
                                    valor += `${temp2} = ${temp2} + 1;\n`;
                                    valor += `heap[(int)${temp2}] = ${n1.valor.toString().charCodeAt(a)};\n`
                                }
                                valor += `${temp1} = ${temp1} + ${n1.valor.toString().length};\n`;
                                valor += `heap[(int)${temp}] = ${temp1};\n`;
                                r[5] = n.valor.toString() + n1.valor.toString();
                                r[6] = n.valor.toString() + n1.valor.toString();
                                n.valor = n.valor.toString() + n1.valor.toString();
                            }
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, la variable no es de tipo string`+'\"}');
                            $$ = ['','','',''];
                        }
                    }

                    tab.update(n.name,n);
                    r[0] = "STRING";
                    r[1] = temp2;
                    r[2] = ''
                    r[3] = valor;
                    r[4] = '';
                    r[7] = '';
                    r[8] = '';

                    $$ = r;

            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, la variable no es de tipo string`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
             $$ = ['','','',''];
        }
     }
    }
    | IDENT '.' CHARAT '(' Expr ')'
     {
        var n = tab.getPositionAmbito($1);
        if(n!=null)
        {
            if(n.tipo.toUpperCase() == 'STRING')
            {
                    var expr = $5;
                    var r = [];
                    var valor = '';
                    var temp = Temp.getTemporal();
                    if(n.rol == 'Parametro')
                    {
                        valor += `${temp} = ${n.valor};\n`;
                        r[5] = '';
                        r[6] = '';
                    }
                    else
                    {
                        if(n.entorno == 'global')
                        {
                            valor += `${temp} = heap[${n.position}];\n`;
                        }
                        else
                        {
                            valor += `${temp} = stack[${n.position}];\n`;
                        }


                    }
                    valor += `${temp} = ${temp} + 2;\n`;
                    var temp1 = Temp.getTemporal();
                    if(expr[0] != '' && expr[0].toUpperCase() == 'NUMBER')
                    {
                        valor += `${temp1} = ${temp} + ${expr[5]};\n`;
                        var tempp = Temp.getTemporal();
                        valor += `${tempp} = heap[(int)${temp1}];\n`;
                        r[0] = "STRING";
                        r[1] = tempp;
                        r[2] = ''
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = '';
                        r[7] = '';
                        r[8] = '';

                        $$ = r;
                    }
                    else if(expr[0] == '')
                    {
                        var n1 = tab.getPositionAmbito(expr[4]);
                        if(n1!=null)
                        {
                            var temps = Temp.getTemporal();
                            if(n1.rol == 'Parametro')
                            {

                                valor += `${temps} = ${n1.valor};\n`;
                            }
                            else
                            {
                                if(n1.entorno == 'global')
                                {
                                    valor += `${temps} = heap[(int)${n1.position}];\n`;
                                }
                                else
                                {
                                    valor += `${temps} = stack[(int)${n1.position}];\n`;
                                }
                            }
                            valor += `${temp1} = ${temp} + ${temps};\n`;
                            var tempp = Temp.getTemporal();
                            valor += `${tempp} = heap[(int)${temp1}];\n`;
                            r[0] = "STRING";
                            r[1] = tempp;
                            r[2] = ''
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = '';
                            r[7] = '';
                            r[8] = '';

                            $$ = r;

                        }
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                        $$ = ['','','',''];
                    }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, la variable no es de tipo string`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
             $$ = ['','','',''];
        }
     }
    | IDENT Expr1_statement '.' TOUPPER '(' ')'
    {
         var n = tab.getPositionAmbito($1);
         var arres = [];
         var poses = [];
         var poses1 = [];
         if(n!=null)
         {
             var valor = '';
             var temp  = Temp.getTemporal();
             var l = arr.getProf($1);
             var posss = 0;
             if(l>=$2.length)
             {
                 var nivel = 1;
                 for(let posi of $2)
                 {
                     var m = arr.getTam($1,nivel);
                     var pass = false;

                     if(posi[12][0] != '')
                     {
                         if(posi[12][0].toUpperCase() == 'NUMBER')
                         {
                             var num = posi[12][6];
                             if(num <= (m-1))
                             {
                                 arres.push(m);
                                 poses.push(posi[12][1]);
                                 poses1.push(posi[12][6]);
                                 valor += posi[12][3] + '\n';
                                 posss = posss * m + num;
                                 pass = true;
                             }
                             else
                             {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${posi[12][6]}`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                             }
                         }
                         else
                          {
                              pass = false;
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion`+'\"}');
                              $$ = ['','','',''];
                              break;
                          }
                     }
                     else
                     {
                        var n1 = tab.getPositionAmbito(posi[12][4]);
                        if(n1!=null)
                        {
                            if(n1.rol.toUpperCase() != 'ARREGLO')
                            {
                                if(n1.tipo.toUpperCase() == 'NUMBER')
                                {
                                     var num = Number(n1.valor);
                                     if(num <= (m-1))
                                     {
                                         arres.push(m);

                                         var temp = Temp.getTemporal();
                                         posss = posss * m + n1.valor;
                                         poses.push(temp);
                                         poses1.push(n1.valor);
                                         if(n1.entorno == 'global')
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         else
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         pass = true;
                                     }
                                     else
                                     {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${n1.valor}`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                     }
                                }
                                else
                                {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                }
                            }
                            else
                            {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                            }

                        }
                        else
                        {
                             pass = false;
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, variable no existe: ${posi[12][0]}`+'\"}');
                             $$ = ['','','',''];
                             break;
                        }

                     }
                     nivel++;
                 }
                 if(pass)
                 {
                    var temp0 = Temp.getTemporal();
                    var temp = Temp.getTemporal();

                    valor += `${temp} = ${poses[0]};\n`

                    for(var a = 1; a<arres.length; a++)
                    {
                        valor += `${temp0} = ${temp} * ${arres[a-1]};\n`;
                        valor += `${temp} = ${temp0} + ${poses[a]};\n`;
                        valor += `${temp} = heap[(int) ${temp}] +2;\n`;
                    }

                    var temp1 = Temp.getTemporal();
                    var temp2 = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp1} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp1} = stack[${n.position}];\n`;
                    }
                    valor += `${temp2} = heap[(int)${temp1}] + 1;\n`;

                    var temp3 = Temp.getTemporal();
                    valor += `${temp3} = ${temp2} + ${temp};\n`;

                    var temp4 = Temp.getTemporal();
                    valor += `${temp4} = heap[(int)${temp3}];\n`;

                   var temp5 = Temp.getTemporal();
                   var temp6 = Temp.getTemporal();

                   valor += `${temp5} = ${temp2} + ${poses[0]};\n`;
                   for(var a = 1; a<poses.length; a++)
                   {
                       valor += `${temp6} = heap[(int) ${temp5}] + 2;\n`;
                       valor += `${temp5} = ${temp6} + ${poses[a]};\n`;
                   }

                   valor += `${temp6} = heap[(int) ${temp5}];\n`;


                    var arrayss = arr.getValores(n.name);
                    if(typeof arrayss[0] == 'string')
                    {
                        var temp7 = Temp.getTemporal();
                        valor += `${temp7} = 0;\n`;

                        var temp8 = Temp.getTemporal();
                        valor += `${temp8} = heap[(int)${temp6}];\n`;
                        valor += `${temp6} = ${temp6} + 1;\n`;

                        var temp9 = Temp.getTemporal();
                        valor += `${temp9} = ${temp8} + 1;\n`;

                        var temp10 = Temp.getTemporal();
                        var temp11 = Temp.getTemporal();

                        var label = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();


                        valor += `${label}:\n`;
                        valor += `\tif(${temp7}==${temp9}) goto ${label1};\n`;
                        valor += `\t${temp10} = ${temp6} + ${temp7};\n`
                        valor += `\t${temp11} = heap[(int)${temp10}];\n`;
                        valor += `\tif(${temp11}>=97) goto ${label2};\n`;
                        valor += `\t${temp7} = ${temp7} + 1;\n`;
                        valor += `\tgoto ${label};\n`;
                        valor += `${label2}:\n`;
                        valor += `\tif(${temp11}<=122) goto ${label3};\n`;
                        valor += `\t${temp7} = ${temp7} + 1;\n`;
                        valor += `\tgoto ${label};\n`;
                        valor += `${label3}:\n`;
                        valor += `\t${temp11} = ${temp11} - 32;\n`;
                        valor += `\theap[(int)${temp10}] = ${temp11};\n`;
                        valor += `\t${temp7} = ${temp7} + 1;\n`;
                        valor += `\tgoto ${label};\n`;
                        valor += `${label1}:\n`;

                        arr.changeValue(n.name, arrayss[posss].toUpperCase(), poses1);
                        var r = [];
                        r[0] = typeof arrayss[0];
                        r[1] = temp11;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = arrayss[posss].toUpperCase();
                        r[6] = arrayss[posss].toUpperCase();
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion, tipo invalido: ${typeof arrayss[0]}`+'\"}');
                        $$ = ['','','',''];
                    }
                 }
                 else
                 {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                    $$ = ['','','',''];
                 }
             }
             else
             {
                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, tamaño muy grande para el arreglo ${$1}, el tamaño del arreglo es de: ${l}`+'\"}');
                 $$ = ['','','',''];
             }
         }
         else
         {
              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
              $$ = ['','','',''];
         }
    }
    | IDENT Expr1_statement '.' TOLOWER '(' ')'
    {
         var n = tab.getPositionAmbito($1);
         var arres = [];
         var poses = [];
         var poses1 = [];
         if(n!=null)
         {
             var valor = '';
             var temp  = Temp.getTemporal();
             var l = arr.getProf($1);
             var posss = 0;
             if(l>=$2.length)
             {
                 var nivel = 1;
                 for(let posi of $2)
                 {
                     var m = arr.getTam($1,nivel);
                     var pass = false;

                     if(posi[12][0] != '')
                     {
                         if(posi[12][0].toUpperCase() == 'NUMBER')
                         {
                             var num = posi[12][6];
                             if(num <= (m-1))
                             {
                                 arres.push(m);
                                 poses.push(posi[12][1]);
                                 poses1.push(posi[12][6]);
                                 valor += posi[12][3] + '\n';
                                 posss = posss * m + num;
                                 pass = true;
                             }
                             else
                             {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${posi[12][6]}`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                             }
                         }
                         else
                          {
                              pass = false;
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion`+'\"}');
                              $$ = ['','','',''];
                              break;
                          }
                     }
                     else
                     {
                        var n1 = tab.getPositionAmbito(posi[12][4]);
                        if(n1!=null)
                        {
                            if(n1.rol.toUpperCase() != 'ARREGLO')
                            {
                                if(n1.tipo.toUpperCase() == 'NUMBER')
                                {
                                     var num = Number(n1.valor);
                                     if(num <= (m-1))
                                     {
                                         arres.push(m);

                                         var temp = Temp.getTemporal();
                                         posss = posss * m + n1.valor;
                                         poses.push(temp);
                                         poses1.push(n1.valor);
                                         if(n1.entorno == 'global')
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         else
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         pass = true;
                                     }
                                     else
                                     {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${n1.valor}`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                     }
                                }
                                else
                                {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                }
                            }
                            else
                            {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                            }

                        }
                        else
                        {
                             pass = false;
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, variable no existe: ${posi[12][0]}`+'\"}');
                             $$ = ['','','',''];
                             break;
                        }

                     }
                     nivel++;
                 }
                 if(pass)
                 {
                    var temp0 = Temp.getTemporal();
                    var temp = Temp.getTemporal();

                    valor += `${temp} = ${poses[0]};\n`

                    for(var a = 1; a<arres.length; a++)
                    {
                        valor += `${temp0} = ${temp} * ${arres[a-1]};\n`;
                        valor += `${temp} = ${temp0} + ${poses[a]};\n`;
                        valor += `${temp} = heap[(int) ${temp}] +2;\n`;
                    }

                    var temp1 = Temp.getTemporal();
                    var temp2 = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp1} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp1} = stack[${n.position}];\n`;
                    }
                    valor += `${temp2} = heap[(int)${temp1}] + 1;\n`;

                    var temp3 = Temp.getTemporal();
                    valor += `${temp3} = ${temp2} + ${temp};\n`;

                    var temp4 = Temp.getTemporal();
                    valor += `${temp4} = heap[(int)${temp3}];\n`;

                   var temp5 = Temp.getTemporal();
                   var temp6 = Temp.getTemporal();

                   valor += `${temp5} = ${temp2} + ${poses[0]};\n`;
                   for(var a = 1; a<poses.length; a++)
                   {
                       valor += `${temp6} = heap[(int) ${temp5}] + 2;\n`;
                       valor += `${temp5} = ${temp6} + ${poses[a]};\n`;
                   }

                   valor += `${temp6} = heap[(int) ${temp5}];\n`;


                    var arrayss = arr.getValores(n.name);
                    if(typeof arrayss[0] == 'string')
                    {
                        var temp7 = Temp.getTemporal();
                        valor += `${temp7} = 0;\n`;

                        var temp8 = Temp.getTemporal();
                        valor += `${temp8} = heap[(int)${temp6}];\n`;
                        valor += `${temp6} = ${temp6} + 1;\n`;

                        var temp9 = Temp.getTemporal();
                        valor += `${temp9} = ${temp8} + 1;\n`;

                        var temp10 = Temp.getTemporal();
                        var temp11 = Temp.getTemporal();

                        var label = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();


                        valor += `${label}:\n`;
                        valor += `\tif(${temp7}==${temp9}) goto ${label1};\n`;
                        valor += `\t${temp10} = ${temp6} + ${temp7};\n`
                        valor += `\t${temp11} = heap[(int)${temp10}];\n`;
                        valor += `\tif(${temp11}>=65) goto ${label2};\n`;
                        valor += `\t${temp7} = ${temp7} + 1;\n`;
                        valor += `\tgoto ${label};\n`;
                        valor += `${label2}:\n`;
                        valor += `\tif(${temp11}<=90) goto ${label3};\n`;
                        valor += `\t${temp7} = ${temp7} + 1;\n`;
                        valor += `\tgoto ${label};\n`;
                        valor += `${label3}:\n`;
                        valor += `\t${temp11} = ${temp11} + 32;\n`;
                        valor += `\theap[(int)${temp10}] = ${temp11};\n`;
                        valor += `\t${temp7} = ${temp7} + 1;\n`;
                        valor += `\tgoto ${label};\n`;
                        valor += `${label1}:\n`;

                        arr.changeValue(n.name, arrayss[posss].toLowerCase(), poses1);
                        var r = [];
                        r[0] = typeof arrayss[0];
                        r[1] = temp11;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = arrayss[posss].toLowerCase();
                        r[6] = arrayss[posss].toLowerCase();
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion, tipo invalido: ${typeof arrayss[0]}`+'\"}');
                        $$ = ['','','',''];
                    }
                 }
                 else
                 {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                    $$ = ['','','',''];
                 }
             }
             else
             {
                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, tamaño muy grande para el arreglo ${$1}, el tamaño del arreglo es de: ${l}`+'\"}');
                 $$ = ['','','',''];
             }
         }
         else
         {
              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
              $$ = ['','','',''];
         }
    }
    | IDENT Expr1_statement '.' LENGTH
     {
        var n = tab.getPositionAmbito($1);
        if(n!=null)
        {
            var valor = '';
            var temp  = Temp.getTemporal();
            var l = arr.getProf($1);
            if(l>=$2.length)
            {
                var nivel = 1;
                k = null;
                for(let posi of $2)
                {
                    var m = arr.getTam($1,nivel);
                    var pass = false;

                    if(posi[12][0] != '')
                    {
                        if(posi[12][0].toUpperCase() == 'NUMBER')
                        {
                            var num = posi[12][6];
                            if(num <= (m-1))
                            {
                                //console.log(k!=null);
                                if(k!=null)
                                {
                                    //console.log(k);
                                    k = arr.getsize1(k,posi[12][6]);
                                }
                                else
                                {
                                    k = arr.getTampos($1,nivel, posi[12][6]);
                                }
                                pass = true;
                            }
                            else
                            {
                                pass = false;
                                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${posi[12][6]}`+'\"}');
                                $$ = ['','','',''];
                            }
                        }
                    }
                    else
                    {

                    }
                    nivel++;
                }
                if(pass)
                {
                   //console.log(k);
                   if(k!=null && k[0] instanceof intermedia.arreglo)
                   {
                        var valor = '\n';
                        var temp = Temp.getTemporal();
                        var temp1 = Temp.getTemporal();
                        var temp2 = Temp.getTemporal();
                        valor += `${temp} = ${n.position};\n`;
                        if(n.entorno == 'global')
                        {
                            valor += `${temp1} = heap[(int)${temp}];\n`;
                        }
                        else
                        {
                            valor += `${temp1} = stack[(int)${temp}];\n`;
                        }

                        valor += `${temp2} = heap[(int)${temp1}];\n`;
                        var temp3 = Temp.getTemporal();
                        valor += `${temp3} = ${k[0].positions[0]};\n`;

                         var r = [];
                         r[0] = "NUMBER";
                         r[1] = temp3;
                         r[2] = ''
                         r[3] = valor;
                         r[4] = '';
                         r[5] = Number(k[0].positions[0]);
                         r[6] = Number(k[0].positions[0]);
                         r[7] = '';
                         r[8] = '';

                         $$ = r;

                   }
                   else
                   {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, el valor en la ultima posicion no es un arreglo.`+'\"}');
                        $$ = ['','','',''];
                   }
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, tamaño muy grande para el arreglo ${$1}, el tamaño del arreglo es de: ${l}`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
             $$ = ['','','',''];
        }
     }
    | IDENT Expr1_statement '.' CONCAT '(' Expr ')'
    {
        $$ = ['','','','','','','','','','','','','','',''];
    }
    | IDENT Expr1_statement '.' CHARAT '(' Expr ')'
    {
        $$ = ['','','','','','','','','','','','','','',''];
    }
    | IDENT Expr1_statement '=' AssignmentExpr
    {
         var n = tab.getPositionAmbito($1);
         //console.log(n);
         var arres = [];
         var poses = [];
         var poses1 = [];
         if(n!=null)
         {
             var valor = '';
             var temp  = Temp.getTemporal();
             var l = arr.getProf($1);
             var posss = 0;
             if(l>=$2.length)
             {
                 var nivel = 1;
                 for(let posi of $2)
                 {
                     var m = arr.getTam($1,nivel);
                     var pass = false;

                     if(posi[12][0] != '')
                     {
                         if(posi[12][0].toUpperCase() == 'NUMBER')
                         {
                             var num = posi[12][6];
                             if(num <= (m-1))
                             {
                                 arres.push(m);
                                 poses.push(posi[12][1]);
                                 poses1.push(posi[12][6]);
                                 valor += posi[12][3] + '\n';
                                 posss = posss * m + num;
                                 pass = true;
                             }
                             else
                             {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${posi[12][6]}`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                             }
                         }
                         else
                          {
                              pass = false;
                              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion, ${posi[12][0]}`+'\"}');
                              $$ = ['','','',''];
                              break;
                          }
                     }
                     else
                     {
                        var n1 = tab.getPositionAmbito(posi[12][4]);
                        if(n1!=null)
                        {
                            if(n1.rol.toUpperCase() != 'ARREGLO')
                            {
                                if(n1.tipo.toUpperCase() == 'NUMBER')
                                {
                                     var num = Number(n1.valor);
                                     if(num <= (m-1))
                                     {
                                         arres.push(m);

                                         var temp = Temp.getTemporal();
                                         posss = posss * m + n1.valor;
                                         poses.push(temp);
                                         poses1.push(n1.valor);
                                         if(n1.entorno == 'global')
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         else
                                         {
                                            valor += `${temp} = heap[${n1.position}];\n`;
                                         }
                                         pass = true;
                                     }
                                     else
                                     {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, posicion fuera del rango, nivel: ${nivel}, tamaño: ${m}, posicion: ${n1.valor}`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                     }
                                }
                                else
                                {
                                         pass = false;
                                         semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                         $$ = ['','','',''];
                                         break;
                                }
                            }
                            else
                            {
                                 pass = false;
                                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                                 $$ = ['','','',''];
                                 break;
                            }

                        }
                        else
                        {
                             pass = false;
                             semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, variable no existe: ${posi[12][0]}`+'\"}');
                             $$ = ['','','',''];
                             break;
                        }

                     }
                     nivel++;
                 }
                 if(pass)
                 {
                    var temp0 = Temp.getTemporal();
                    var temp = Temp.getTemporal();

                    valor += `${temp} = ${poses[0]};\n`

                    for(var a = 1; a<arres.length; a++)
                    {
                        valor += `${temp0} = ${temp} * ${arres[a-1]};\n`;
                        valor += `${temp} = ${temp0} + ${poses[a]};\n`;
                        valor += `${temp} = heap[(int) ${temp}] +2;\n`;
                    }

                    var temp1 = Temp.getTemporal();
                    var temp2 = Temp.getTemporal();
                    if(n.entorno == 'global')
                    {
                        valor += `${temp1} = heap[${n.position}];\n`;
                    }
                    else
                    {
                        valor += `${temp1} = stack[${n.position}];\n`;
                    }
                    valor += `${temp2} = heap[(int)${temp1}] + 1;\n`;

                   // var temp3 = Temp.getTemporal();
                    //valor += `${temp3} = ${temp2} + ${temp};\n`;

                    //var temp4 = Temp.getTemporal();
                    //valor += `${temp4} = heap[(int)${temp3}];\n`;

                   var temp5 = Temp.getTemporal();
                   var temp6 = Temp.getTemporal();

                   valor += `${temp5} = ${temp2} + ${poses[0]};\n`;
                   for(var a = 1; a<poses.length; a++)
                   {
                       valor += `${temp6} = heap[(int) ${temp5}] + 2;\n`;
                       valor += `${temp5} = ${temp6} + ${poses[a]};\n`;
                   }

                   valor += `${temp6} = heap[(int) ${temp5}];\n`;


                    var arrayss = arr.getValores(n.name);
                    if((typeof arrayss[0]).toString().toLowerCase() == $4[0].toLowerCase())
                    {
                        if($4[0].toUpperCase() == 'STRING')
                        {
                           var temp7 = Temp.getTemporal();
                           valor += temp7 + ' = ' + temp5 + ';';
                           var temp8 = Temp.getTemporal();
                           valor += temp8 + ' = ' + posS + ';';
                           valor += '\n';
                           var temp9 = Temp.getTemporal();
                           valor += temp9 + ' = ' + posS + ';';
                           valor += '\n';
                           if(entorno == 'global')
                           {
                               valor += 'heap[(int)'+temp7+'] = ' + temp8 + ';';
                               valor += '\n';
                           }
                           else
                           {
                               valor += 'stack[(int)'+temp7+'] = ' + temp8 + ';';
                               valor += '\n';
                           }

                           valor += temp8 + ' = ' + temp8 + ' + 1;';
                           valor += '\n';
                           valor += 'heap[(int)'+temp9+'] = ' + temp8 + ';\n';
                           var temp10 = Temp.getTemporal();
                           valor += temp10 + ' = '+ $4[5].length + ';';
                           valor += '\n';
                           valor += 'heap[(int)'+temp8+'] = ' + temp10 + ';';
                           valor += '\n';

                          for(var a = 0; a<$4[5].length; a++)
                          {
                              valor += temp8 + ' = ' + temp8 + ' + 1;';
                              valor += '\n';
                              valor += 'heap[(int)'+temp8+'] = ' + $4[5].charCodeAt(a) + ';';
                              valor += '\n'
                          }
                        }
                        else
                        {
                            valor += $4[3] + '\n';
                            valor += `heap[(int)${temp5}] = ${$4[1]};\n`;
                        }

                        arr.changeValue(n.name, $4[5], poses1);

                        var values = arr.get(n.name);
                        n.valor = values;
                        tab.update(n.name,n);
                        arr.update(n.name,values);

                        var r = [];
                        r[0] = typeof arrayss[0];
                        r[1] = temp6;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = $4[5];
                        r[6] = $4[5];
                        $$ = r;
                    }
                    else if($4[0].toUpperCase() == 'ARREGLO')
                    {
                        var temp7 = Temp.getTemporal();
                        valor += temp7 + ' = ' + temp5 + ';';
                        valor += '\n';

                        var temp8 = Temp.getTemporal();
                        var temp9 = Temp.getTemporal();
                        valor += temp8 + ' = ' + posA + ';';
                        valor += '\n';
                        valor += temp9+ ' = ' + posA + ';\n';
                        valor += 'heap[(int)'+temp7+'] = ' + temp8 + ';';
                        valor += '\n';

                        valor += temp8 + ' = ' + temp8 + ' + 1;';
                        valor += '\n';
                        valor += 'heap[(int)'+temp9+'] = ' + temp8 + ';\n';

                        var temp2 = Temp.getTemporal();
                        valor += temp2 + ' = '+ $4[7] + ';';
                        valor += '\n';
                        valor += 'heap[(int)'+temp8+'] = ' + temp2 + ';';
                        valor += '\n';
                        valor += $4[1] + ' = ' + temp8 + ';';
                        valor += '\n';
                        valor += $4[3];
                        valor += '\n';

                        arr.changeValue(n.name, $4[6], poses1);

                        var values = arr.get(n.name);
                        n.valor = values;
                        tab.update(n.name,n);
                        arr.update(n.name,values);

                        var r = [];
                        r[0] = 'ARREGLO';
                        r[1] = temp6;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = $4[6];
                        r[6] = $4[6];
                        $$ = r;

                    }
                    else if($4[0] == '')
                    {
                        var nn = tab.getPositionAmbito($4[4]);
                        if(nn!= null)
                        {
                            if((typeof arrayss[0]).toString().toLowerCase() == $4[0].toLowerCase())
                            {
                                switch(nn.tipo.toUpperCase())
                                {
                                    case 'STRING':
                                        if(nn.rol == 'Parametro')
                                        {
                                            var temp20 = Temp.getTemporal();
                                            var temp21 = Temp.getTemporal();
                                            var temp22 = Temp.getTemporal();

                                            valor += `${temp20} = ${n.valor};\n`;
                                            valor += `${temp21} = heap[(int) ${temp20}];\n`;
                                            valor += `heap[(int)${temp5}] = \n`;
                                        }
                                        else
                                        {

                                        }
                                        break;
                                    case 'NUMBER':
                                        break;
                                    case 'BOOLEAN':
                                        break;
                                    default:
                                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe puede ejecutarse la operacion.`+'\"}');
                                        $$ = ['','','',''];
                                        break;
                                }
                            }
                            else
                            {
                                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion, tipo invalido: ${typeof arrayss[0]}`+'\"}');
                                $$ = ['','','',''];
                            }
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$4[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion, tipo invalido: ${typeof arrayss[0]}`+'\"}');
                        $$ = ['','','',''];
                    }
                 }
                 else
                 {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar la operacion.`+'\"}');
                    $$ = ['','','',''];
                 }
             }
             else
             {
                 semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, tamaño muy grande para el arreglo ${$1}, el tamaño del arreglo es de: ${l}`+'\"}');
                 $$ = ['','','',''];
             }
         }
         else
         {
              semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1}`+'\"}');
              $$ = ['','','',''];
         }
    }

;

ArrayLiteral
    : '[' ']'
    {
        var temp = Temp.getTemporal();
        var r = [];
        r[0] = "ARREGLO";
        r[1] = temp;
        r[2] = '';

        var valor = '';
        valor += temp + ' = ' + temp + ' + 1;';
        valor += '\n';
        valor += 'heap[(int)'+temp+'] = -1;';
        valor += '\n';
        var a = new intermedia.arreglo();
        a.c3d = valor;
        a.positions.push(0);

        r[3] = valor;
        r[4] = '';
        r[5] = [];
        r[6] = a;
        r[7] = 0;
        r[8] = '';

        $$ = r;
    }
    | '[' ElementList ']'
    {

        var temp = Temp.getTemporal();
        var r = [];
        r[0] = "ARREGLO";
        r[1] = temp;
        r[2] = '';
        var lm = false;
        var valor = '';
        var arreglito = new intermedia.arreglo();
        var vals = [];
        if($2[0][6] instanceof intermedia.arreglo)
        {
            var tipo = $2[0][6].tipo.toUpperCase();
            var pass = false;
            r[8] = tipo;

            for(let pos of $2)
            {
                lm = true;

                valor += temp + ' = ' + temp + ' + 1;';
                valor += '\n';
                if(pos[6] instanceof intermedia.arreglo)
                {
                    vals.push(pos[6]);
                    if(pos[6].tipo.toUpperCase() == tipo)
                    {
                        pass = true;
                        var aux = pos[6].tipo.toUpperCase();
                        switch(aux)
                        {
                            case 'STRING':
                                var val = pos[6].valor;
                                var temp0 = Temp.getTemporal();
                                var temp1 = Temp.getTemporal();
                                valor += temp1 + ' = ' + posS + ';';
                                valor += temp0 + ' = ' + posS + ';';
                                valor += '\n';
                                valor += 'heap[(int)'+temp+'] = ' + temp1 + ';';
                                valor += '\n';
                                valor += temp1 + ' = ' + temp1 + ' + 1;';
                                valor += '\n';
                                var temp2 = Temp.getTemporal();
                                valor += temp2 + ' = '+ val.length + ';';
                                valor += '\n';
                                valor += 'heap[(int)'+temp1+'] = ' + temp2 + ';';
                                valor += '\n';
                                valor += pos[6].temporal + ' = ' + temp1 + ';';
                                valor += '\n';
                                valor += pos[6].c3d;
                                valor += '\n';
                                valor += 'heap[(int)'+temp+'] = '+temp0+';';
                                valor += '\n';

                                //if(pos >0 && pos != 0) pos++;
                                //if (pos == 0) pos++;
                                posS += 5000;
                                break;
                            case 'NUMBER':
                                valor += pos[6].c3d;
                                valor += '\n';
                                valor += 'heap[(int)'+temp+'] = '+pos[6].temporal+';';
                                valor += '\n';
                                break;
                            case 'BOOLEAN':
                                valor += pos[6].c3d;
                                valor += '\n';
                                valor += 'heap[(int)'+temp+'] = '+pos[6].temporal+';';
                                valor += '\n';
                                break;

                            case 'ARREGLO':
                                var val = pos[6].positions;
                                var post = 1;
                                for(let m of val) post *= m;

                                var temp0 = Temp.getTemporal();
                                var temp1 = Temp.getTemporal();
                                valor += temp1 + ' = ' + posA + ';\n';
                                valor += temp0 + ' = ' + posA + ';\n';

                                var temp2 = Temp.getTemporal();
                                valor += temp2 + ' = '+ post + ';';
                                valor += '\n';
                                valor += `${temp1} = ${temp1} + 1;\n`
                                valor += 'heap[(int)'+temp0+'] = ' + temp1 + ';';
                                valor += '\n';
                                valor += `heap[(int)${temp1}] = ${temp2};\n`;
                                valor += pos[6].temporal + ' = ' + temp1 + ';';
                                valor += '\n';
                                valor += pos[6].c3d;
                                valor += '\n';
                                valor += 'heap[(int)'+temp+'] = '+temp0+';';
                                valor += '\n';

                                //if(pos >0 && pos != 0) pos++;
                                //if (pos == 0) pos++;
                                posA += 5000;
                                break;
                        }
                    }
                    else
                    {
                        pass = false;
                        break;
                    }
                }
                else
                {
                    pass = false;
                    break;
                }
            }
            if(pass)
            {
                arreglito.c3d = valor;
                arreglito.temporal = temp;
                arreglito.bandera = '';
                arreglito.tipo = 'ARREGLO';
                arreglito.valor = vals;
                r[3] = valor;
                r[4] = '';
                r[5] = [];

                var posis = [];
                posis.push($2.length);
                if( $2[0][6].tipo.toUpperCase() == 'ARREGLO' )
                {
                    for(let o of $2[0][6].positions)
                    {
                        posis.push(o);
                    }
                }
                arreglito.positions = posis;
                r[6] = arreglito;
                var rra = 1;
                for(let v of arreglito.positions)rra *= v;
                r[7] = rra;
                $$ = r;
            }
            else
            {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion., error en implementacion de tipos.`+'\"}');
                    $$ = ['','','',''];
            }
        }

        if(!lm)
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion.`+'\"}');
            $$ = ['','','','','','','',''];
        }

    }
;

ElementList
    : AssignmentExpr
    {
        $$ = [];
        var r = [];

          if($1[0] != '')
          {   var arrs = new intermedia.arreglo();
              if($1[0].tipo == 'ARREGLO')
              {
                  arrs.positions.push($1[7]);
              }
              arrs.valor.push($1[6]);
              arrs.tipo = $1[0];
              arrs.c3d = $1[3];
              arrs.temporal = $1[1];
              arrs.bandera = $1[2];
              r[0] = 'ARREGLO';
              r[1] = $1[1];
              r[2] = $1[2];
              r[3] = $1[3];
              r[4] = '';
              r[5] = $1[6];
              r[6] = arrs;
              r[7] = 1;

          }
          else
          {

            /*

                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {

                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable ${$1[4]}.`+'\"}');
                    r = ['','','','','','','',''];
                }
                */
                r = ['','','','','','','',''];
          }
        $$.push(r);
    }
    | ElementList ',' AssignmentExpr
    {

        r1 = $1;
        if($3[0].tipo != '')
         {
             var r = [];
             var arrs = new intermedia.arreglo();
             if($3[0].tipo == 'ARREGLO')
             {
                 arrs.positions.push($3[7]);
             }
             arrs.valor.push($3[6]);
             arrs.tipo = $3[0];
             arrs.c3d = $3[3];
             arrs.temporal = $3[1];
             arrs.bandera = $3[2];

             r[0] = 'ARREGLO';
             r[1] = $3[1];
             r[2] = $3[2];
             r[3] = $3[3];
             r[4] = '';
             r[5] = '';
             r[6] = arrs;
             r[7] = 1;
             $$.push(r);
         }
        $$ = r1;

    }
;


MemberExpr
    : PrimaryExpr
    {
        $$ = $1;
    }
//    | MemberExpr '[' Expr ']'
    | MemberExpr '.' IDENT
    {
        $$ = ['','','','','','']
    }
;

MemberExprNoBF
    : PrimaryExprNoBrace
    {
        $$ = $1;
    }
//    | MemberExprNoBF '[' Expr ']'
    | MemberExprNoBF '.' IDENT
    {
        $$ = ['','','','','','']
    }
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
    {
        if($2[0] == '')
        {
            var n = tab.getFuncion($1[4]);
            if(n!=null)
            {
                if(n.params == 0)
                {
                    var valor = '';
                    var r = [];
                    valor += `P = P + ${params+1};\n`;
                    valor += `${$1[4]}();\n`;
                    var temp = Temp.getTemporal();
                    var temp1 = Temp.getTemporal();
                    valor += `${temp} = P + ${n.params};\n`;
                    valor += `${temp1} = stack[(int)${temp}];\n`;
                    valor += `P = P - ${params+1};\n`;
                    r[0] = 'FUNCION';
                    r[1] = temp1;
                    r[2] = '';
                    r[3] = valor;
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la funcion:  ${$1[4]}.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else
        {
            var pams = $2[1];
            var n = tab.getFuncion($1[4]);
            if(n!=null)
            {
                if(pams.length == n.params)
                {
                    var valor = '';
                    var r = [];
                    valor += `P = P + ${params+1};\n`;

                    var posk = 0;
                    var p = true;
                    for(let arg of pams)
                    {
                        var temp = Temp.getTemporal();

                        if(arg[0] != '')
                        {
                            valor += arg[3] + '\n';
                            valor += `${temp} = P + ${posk};\n`;
                            valor += `stack[(int)${temp}] = ${arg[1]};\n`;
                        }
                        else
                        {
                            var nn = tab.getPositionAmbito(arg[4]);
                            if(nn!= null)
                            {
                                if(nn.tipo.toUpperCase() != 'STRING' && nn.tipo.toUpperCase() != 'ARREGLO')
                                {
                                    if(nn.rol == 'Parametro')
                                    {
                                        valor += `${temp} = P + ${posk};\n`;
                                        valor += `stack[(int)${temp}] = ${nn.valor};\n`;
                                    }
                                    else
                                    {
                                        var temp1 = Temp.getTemporal();

                                        if(nn.entorno == 'global')
                                        {
                                             valor += `${temp} = P + ${posk};\n`;
                                             valor += `${temp1} = heap[${nn.position}];\n`;
                                             valor += `stack[(int)${temp}] = ${temp1};\n`;
                                        }
                                        else
                                        {
                                            valor += `${temp} = P + ${posk};\n`;
                                             valor += `${temp1} = stack[${nn.position}];\n`;
                                             valor += `stack[(int)${temp}] = ${temp1};\n`;
                                        }
                                    }
                                }
                                else
                                {
                                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, funcion:  ${$1[4]}, no implementado :c.`+'\"}');
                                    $$ = ['','','',''];
                                    p = false;
                                    break;
                                }
                            }
                            else
                            {
                                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, funcion:  ${$1[4]}, invalida.`+'\"}');
                                $$ = ['','','',''];
                                p = false;
                                break;
                            }
                        }
                        posk++;
                    }

                    if(p)
                    {
                        valor += `${$1[4]}();\n`;
                        var temp = Temp.getTemporal();
                        var temp1 = Temp.getTemporal();
                        valor += `${temp} = P + ${n.params};\n`;
                        valor += `${temp1} = stack[(int)${temp}];\n`;
                        valor += `P = P - ${params+1};\n`;
                        r[0] = 'FUNCION';
                        r[1] = temp1;
                        r[2] = '';
                        r[3] = valor;
                        $$ = r;
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, funcion:  ${$1[4]}, invalida.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la funcion:  ${$1[4]}.`+'\"}');
                $$ = ['','','',''];
            }
        }
    }
    | CallExpr '.' IDENT
    {
        $$ = ['','','','','','']
    }
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
    {
        if($2[0] == '')
        {
            var n = tab.getFuncion($1[4]);
            if(n!=null)
            {
                if(n.params == 0)
                {
                    var valor = '';
                    var r = [];
                    valor += `P = P + ${params+1};\n`;
                    valor += `${$1[4]}();\n`;
                    var temp = Temp.getTemporal();
                    var temp1 = Temp.getTemporal();
                    valor += `${temp} = P + ${n.params};\n`;
                    valor += `${temp1} = stack[(int)${temp}];\n`;
                    valor += `P = P - ${params+1};\n`;
                    r[0] = 'FUNCION';
                    r[1] = temp1;
                    r[2] = '';
                    r[3] = valor;
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la funcion:  ${$1[4]}.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else
        {
            var pams = $2[1];
            var n = tab.getFuncion($1[4]);
            if(n!=null)
            {
                if(pams.length == n.params)
                {
                    var valor = '';
                    var r = [];
                    valor += `P = P + ${params+1};\n`;

                    var posk = 0;
                    var p = true;
                    for(let arg of pams)
                    {
                        var temp = Temp.getTemporal();

                        if(arg[0] != '')
                        {
                            valor += arg[3] + '\n';
                            valor += `${temp} = P + ${posk};\n`;
                            valor += `stack[(int)${temp}] = ${arg[1]};\n`;
                        }
                        else
                        {
                            var nn = tab.getPositionAmbito(arg[4]);
                            if(nn!= null)
                            {
                                if(nn.tipo.toUpperCase() != 'STRING' && nn.tipo.toUpperCase() != 'ARREGLO')
                                {
                                    if(nn.rol == 'Parametro')
                                    {
                                        valor += `${temp} = P + ${posk};\n`;
                                        valor += `stack[(int)${temp}] = ${nn.valor};\n`;
                                    }
                                    else
                                    {
                                        var temp1 = Temp.getTemporal();

                                        if(nn.entorno == 'global')
                                        {
                                             valor += `${temp} = P + ${posk};\n`;
                                             valor += `${temp1} = heap[${nn.position}];\n`;
                                             valor += `stack[(int)${temp}] = ${temp1};\n`;
                                        }
                                        else
                                        {
                                            valor += `${temp} = P + ${posk};\n`;
                                             valor += `${temp1} = stack[${nn.position}];\n`;
                                             valor += `stack[(int)${temp}] = ${temp1};\n`;
                                        }
                                    }
                                }
                                else
                                {
                                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, funcion:  ${$1[4]}, no implementado :c.`+'\"}');
                                    $$ = ['','','',''];
                                    p = false;
                                    break;
                                }
                            }
                            else
                            {
                                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, funcion:  ${$1[4]}, invalida.`+'\"}');
                                $$ = ['','','',''];
                                p = false;
                                break;
                            }
                        }
                        posk++;
                    }

                    if(p)
                    {
                        valor += `${$1[4]}();\n`;
                        var temp = Temp.getTemporal();
                        var temp1 = Temp.getTemporal();
                        valor += `${temp} = P + ${n.params};\n`;
                        valor += `${temp1} = stack[(int)${temp}];\n`;
                        valor += `P = P - ${params+1};\n`;
                        r[0] = 'FUNCION';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        $$ = r;
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, funcion:  ${$1[4]}, invalida.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la funcion:  ${$1[4]}.`+'\"}');
                $$ = ['','','',''];
            }
        }
    }
    | CallExprNoBF '.' IDENT
    {
        $$ = ['','','','','','']
    }
;

Arguments
    : '(' ')'
    {
        $$ = ['','','','','',''];
    }
    | '(' ArgumentList ')'
    {
        $$ = ['Arguments',$2];
    }
;

ArgumentList
    : AssignmentExpr
    {
        var r = [];
        r.push($1);
        $$ = r;

    }
    | ArgumentList ',' AssignmentExpr
    {
        $$ = $1;
        $$.push($3);
    }
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
    {
        if($2[0] == '')
        {
            var n = tab.getPositionAmbito($2[4]);
            if(n != null)
            {
                var r = [];
                var valor = '';
                r[0] = n.tipo;

                var temp0 = Temp.getTemporal();
                var temp = Temp.getTemporal();
                valor += $2[3];

                valor += temp0 + ' = '+n.position +';\n';
                if(n.rol == 'Parametro')
                {
                    valor += `${temp} = ${n.valor};\n`;
                }
                else
                {
                    if(n.entorno == 'global')
                    {
                        valor += temp + ' = heap[(int)'+temp0+'];\n';
                    }
                    else
                    {
                        valor += temp + ' = stack[(int)'+temp0+'];\n';
                    }
                }


                r[1] = temp;
                r[2] = '';
                r[3] = valor;
                r[4] = '';
                r[5] = '';
                r[6] = n.valor;

                $$ = r;
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion., la variable ${$2[4]} no existe.`+'\"}');
                $$ = ['','','',''];
            }
        }
        else if($2[0] != 'STRING' && $2[0] != 'BOOLEAN')
        {
            $$ = $2;
        }

    }
    | '-' UnaryExpr
    {
        if($2[0] != 'STRING' && $2[0] != 'BOOLEAN')
        {
            if($2[0] == '')
            {
                var n = tab.getPositionAmbito($2[4]);
                if( n != null)
                {
                    if(n.tipo.toUpperCase() != 'STRING' && n.tipo.toUpperCase() != 'BOOLEAN')
                    {
                        var r = [];
                        var valor = '';
                        var temp0 = Temp.getTemporal();
                        valor += temp0 + ' = ' + n.position + ';\n';
                        valor += '';

                        var temp = Temp.getTemporal();
                        if(n.rol == 'Parametro')
                        {
                            valor += `${temp} = ${n.valor};\n`;
                        }
                        else
                        {
                            if(n.entorno == 'global')
                            {
                                valor += temp + ' = heap[(int)'+temp0+'];\n';
                            }
                            else
                            {
                                valor += temp + ' = stack[(int)'+temp0+'];\n';
                            }
                        }


                        var temp1 = Temp.getTemporal();
                        valor += temp1 + ' = -1 * ' + temp + ';\n';

                        r[0] = 'NUMBER';
                        r[1] = temp1;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number(n.valor) * -1;

                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion.`+'\"}');
                        $$ = ['','','',''];
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion., no existe la variable ${$2[4]}.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                var r = [];
                var valor = '';
                valor += $2[3];
                valor += '\n';

                var temp = Temp.getTemporal();
                valor += temp + ' = -1 * ' + $2[1] + ';';

                r[0] = 'NUMBER';
                r[1] = temp;
                r[2] = '';
                r[3] = valor;
                r[4] = '';
                r[5] = '';
                r[6] = Number($2[6]) * -1;

                $$ = r;
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion.`+'\"}');
            $$ = ['','','',''];
        }
    }
    | '!' UnaryExpr
    {
        if($2[0] !='STRING' && $2[0] != 'NUMBER')
        {
            if($2[0] == 'BOOLEAN')
            {
                var r = [];
                var valor = '';
                r[0] = 'BOOLEAN';

                var temp = Temp.getTemporal();
                var label = Label.getBandera();
                var label1 = Label.getBandera();
                valor += $2[3];

                valor += 'if('+$2[1]+' == 0) goto '+label+';\n';
                valor += temp + ' = 0;\n';
                valor += 'goto '+label1+';\n';

                valor += label + ':\n';
                valor += '\t'+temp + ' = 1;\n';
                valor += '\tgoto '+label1+';\n';

                valor += label1 + ':\n';

                r[1] = temp;
                r[2] = label1;
                r[3] = valor;
                r[4] = '';
                r[5] = '';
                r[6] = !$2[6];

                $$ = r;

            }
            else
            {
                var n = tab.getPositionAmbito($2[4]);
                if(n != null)
                {
                    if(n.tipo.toUpperCase() == 'BOOLEAN')
                    {
                        var r = [];
                        var valor = '';
                        r[0] = 'BOOLEAN';

                        var temp0 = Temp.getTemporal();
                        var temp1 = Temp.getTemporal();
                        var temp = Temp.getTemporal();
                        var label = Label.getBandera();
                        var label1 = Label.getBandera();
                        valor += $2[3];

                        valor += temp0 + ' = '+n.position +';\n';
                        if(n.rol == 'Parametro')
                        {
                            valor += `${temp1} = ${n.valor};\n`;
                        }
                        else
                        {
                            if(n.entorno == 'global')
                            {
                                valor += temp1 + ' = heap[(int)'+temp0+'];\n';
                            }
                            else
                            {
                                valor += temp1 + ' = stack[(int)'+temp0+'];\n';
                            }
                        }


                        valor += 'if('+temp1+' == 0) goto '+label+';\n';
                        valor += temp + ' = 0;\n';
                        valor += 'goto '+label1+';\n';

                        valor += label + ':\n';
                        valor += '\t'+temp + ' = 1;\n';
                        valor += '\tgoto '+label1+';\n';

                        valor += label1 + ':\n';

                        r[1] = temp;
                        r[2] = label1;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = !n.valor;

                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion.`+'\"}');
                        $$ = ['','','',''];
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion., la variable ${$2[4]} no existe.`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede realizar dicha operacion.`+'\"}');
            $$ = ['','','',''];
        }
    }
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
        $$ = $1;
    }
    | MultiplicativeExpr '*' UnaryExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'*'+$3[1]+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])*Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'*'+tempant1+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])*Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'*'+$3[1]+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)*Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                                valor += '\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                                valor += '\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'*'+tempant111+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)*Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | MultiplicativeExpr '/' UnaryExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'/'+$3[1]+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])/Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'/'+tempant1+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])/Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'/'+$3[1]+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)/Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'/'+tempant111+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)/Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | MultiplicativeExpr POTENCIA UnaryExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        var temp1 = Temp.getTemporal();
                        var label0 = Temp.getTemporal();
                        var label1 = Temp.getTemporal();
                        var label2 = Temp.getTemporal();

                        valor += 'if('+$3[1]+'==0) goto '+label1+';\n';
                        valor += temp + ' = 1;\n';
                        valor += temp1 + ' = '+$1[1] +';\n';
                        valor += label0 + ':\n';
                        valor += '\t'+'if('+$3[1]+'=='+temp+') goto '+label2+';\n';
                        valor += '\t'+temp1 + ' = '+temp1+'*'+$1[1]+';\n';
                        valor += '\t'+temp+'='+temp+'+'+1+';\n';
                        valor += '\tgoto '+label0+';\n';
                        valor += label1 +':\n';
                        valor += '\t'+temp1+'=1;\n';
                        valor += '\tgoto '+label2+';\n';
                        valor += label2 + ':\n';


                        r[0] = 'NUMBER';
                        r[1] = temp1;
                        r[2] = label2;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Math.pow(Number($1[6]),Number($3[6]));
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        var temp1 = Temp.getTemporal();
                        var label0 = Temp.getTemporal();
                        var label1 = Temp.getTemporal();
                        var label2 = Temp.getTemporal();

                        valor += 'if('+tempant1+'==0) goto '+label1+';\n';
                        valor += temp + ' = 1;\n';
                        valor += temp1 + ' = '+$1[1] +';\n';
                        valor += label0 + ':\n';
                        valor += '\t'+'if('+tempant1+'=='+temp+') goto '+label2+';\n';
                        valor += '\t'+temp1 + ' = '+temp1+'*'+$1[1]+';\n';
                        valor += '\t'+temp+'='+temp+'+'+1+';\n';
                        valor += '\tgoto '+label0+';\n';
                        valor += label1 +':\n';
                        valor += '\t'+temp1+'=1;\n';
                        valor += '\tgoto '+label2+';\n';
                        valor += label2 + ':\n';


                        r[0] = 'NUMBER';
                        r[1] = temp1;
                        r[2] = label2;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Math.pow(Number($1[6]),Number(n.valor));
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            var temp1 = Temp.getTemporal();
                            var label0 = Temp.getTemporal();
                            var label1 = Temp.getTemporal();
                            var label2 = Temp.getTemporal();

                            valor += 'if('+$3[1]+'==0) goto '+label1+';\n';
                            valor += temp + ' = 1;\n';
                            valor += temp1 + ' = '+tempant1+';\n';
                            valor += label0 + ':\n';
                            valor += '\t'+'if('+$3[1]+'=='+temp+') goto '+label2+';\n';
                            valor += '\t'+temp1 + ' = '+temp1+'*'+tempant1+';\n';
                            valor += '\t'+temp+'='+temp+'+'+1+';\n';
                            valor += '\tgoto '+label0+';\n';
                            valor += label1 +':\n';
                            valor += '\t'+temp1+'=1;\n';
                            valor += '\tgoto '+label2+';\n';
                            valor += label2 + ':\n';


                            r[0] = 'NUMBER';
                            r[1] = temp1;
                            r[2] = label2;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Math.pow(Number(n.valor),Number($3[6]));
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            var temp1 = Temp.getTemporal();
                            var label0 = Temp.getTemporal();
                            var label1 = Temp.getTemporal();
                            var label2 = Temp.getTemporal();

                            valor += 'if('+tempant111+'==0) goto '+label1+';\n';
                            valor += temp + ' = 1;\n';
                            valor += temp1 + ' = '+tempant1 +';\n';
                            valor += label0 + ':\n';
                            valor += '\t'+'if('+tempant111+'=='+temp+') goto '+label2+';\n';
                            valor += '\t'+temp1 + ' = '+temp1+'*'+tempant1+';\n';
                            valor += '\t'+temp+'='+temp+'+'+1+';\n';
                            valor += '\tgoto '+label0+';\n';
                            valor += label1 +':\n';
                            valor += '\t'+temp1+'=1;\n';
                            valor += '\tgoto '+label2+';\n';
                            valor += label2 + ':\n';


                            r[0] = 'NUMBER';
                            r[1] = temp1;
                            r[2] = label2;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Math.pow(Number(n.valor),Number(n1.valor));
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | MultiplicativeExpr '%' UnaryExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'=(int)'+$1[1]+'%(int)'+$3[1]+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])%Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'%'+tempant1+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])%Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'%'+$3[1]+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)%Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'%'+tempant111+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)%Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
;

MultiplicativeExprNoBF
    : UnaryExprNoBF
    {
        $$ = $1;
    }
    | MultiplicativeExprNoBF '*' UnaryExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'*'+$3[1]+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])*Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'*'+tempant1+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])*Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'*'+$3[1]+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)*Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'*'+tempant111+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)*Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | MultiplicativeExprNoBF '/' UnaryExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'/'+$3[1]+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])/Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'/'+tempant1+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])/Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'/'+$3[1]+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)/Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'/'+tempant111+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)/Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | MultiplicativeExprNoBF POTENCIA UnaryExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        var temp1 = Temp.getTemporal();
                        var label0 = Temp.getTemporal();
                        var label1 = Temp.getTemporal();
                        var label2 = Temp.getTemporal();

                        valor += 'if('+$3[1]+'==0) goto '+label1+';\n';
                        valor += temp + ' = 1;\n';
                        valor += temp1 + ' = '+$1[1] +';\n';
                        valor += label0 + ':\n';
                        valor += '\t'+'if('+$3[1]+'=='+temp+') goto '+label2+';\n';
                        valor += '\t'+temp1 + ' = '+temp1+'*'+$1[1]+';\n';
                        valor += '\t'+temp+'='+temp+'+'+1+';\n';
                        valor += '\tgoto '+label0+';\n';
                        valor += label1 +':\n';
                        valor += '\t'+temp1+'=1;\n';
                        valor += '\tgoto '+label2+';\n';
                        valor += label2 + ':\n';


                        r[0] = 'NUMBER';
                        r[1] = temp1;
                        r[2] = label2;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Math.pow(Number($1[6]),Number($3[6]));
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        var temp1 = Temp.getTemporal();
                        var label0 = Temp.getTemporal();
                        var label1 = Temp.getTemporal();
                        var label2 = Temp.getTemporal();

                        valor += 'if('+tempant1+'==0) goto '+label1+';\n';
                        valor += temp + ' = 1;\n';
                        valor += temp1 + ' = '+$1[1] +';\n';
                        valor += label0 + ':\n';
                        valor += '\t'+'if('+tempant1+'=='+temp+') goto '+label2+';\n';
                        valor += '\t'+temp1 + ' = '+temp1+'*'+$1[1]+';\n';
                        valor += '\t'+temp+'='+temp+'+'+1+';\n';
                        valor += '\tgoto '+label0+';\n';
                        valor += label1 +':\n';
                        valor += '\t'+temp1+'=1;\n';
                        valor += '\tgoto '+label2+';\n';
                        valor += label2 + ':\n';


                        r[0] = 'NUMBER';
                        r[1] = temp1;
                        r[2] = label2;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Math.pow(Number($1[6]),Number(n.valor));
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            var temp1 = Temp.getTemporal();
                            var label0 = Temp.getTemporal();
                            var label1 = Temp.getTemporal();
                            var label2 = Temp.getTemporal();

                            valor += 'if('+$3[1]+'==0) goto '+label1+';\n';
                            valor += temp + ' = 1;\n';
                            valor += temp1 + ' = '+tempant1+';\n';
                            valor += label0 + ':\n';
                            valor += '\t'+'if('+$3[1]+'=='+temp+') goto '+label2+';\n';
                            valor += '\t'+temp1 + ' = '+temp1+'*'+tempant1+';\n';
                            valor += '\t'+temp+'='+temp+'+'+1+';\n';
                            valor += '\tgoto '+label0+';\n';
                            valor += label1 +':\n';
                            valor += '\t'+temp1+'=1;\n';
                            valor += '\tgoto '+label2+';\n';
                            valor += label2 + ':\n';


                            r[0] = 'NUMBER';
                            r[1] = temp1;
                            r[2] = label2;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Math.pow(Number(n.valor),Number($3[6]));
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            var temp1 = Temp.getTemporal();
                            var label0 = Temp.getTemporal();
                            var label1 = Temp.getTemporal();
                            var label2 = Temp.getTemporal();

                            valor += 'if('+tempant111+'==0) goto '+label1+';\n';
                            valor += temp + ' = 1;\n';
                            valor += temp1 + ' = '+tempant1 +';\n';
                            valor += label0 + ':\n';
                            valor += '\t'+'if('+tempant111+'=='+temp+') goto '+label2+';\n';
                            valor += '\t'+temp1 + ' = '+temp1+'*'+tempant1+';\n';
                            valor += '\t'+temp+'='+temp+'+'+1+';\n';
                            valor += '\tgoto '+label0+';\n';
                            valor += label1 +':\n';
                            valor += '\t'+temp1+'=1;\n';
                            valor += '\tgoto '+label2+';\n';
                            valor += label2 + ':\n';


                            r[0] = 'NUMBER';
                            r[1] = temp1;
                            r[2] = label2;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Math.pow(Number(n.valor),Number(n1.valor));
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | MultiplicativeExprNoBF '%' UnaryExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'=(int)'+$1[1]+'%'(int)+$3[1]+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])%Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'%'+tempant1+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])%Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'%'+$3[1]+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)%Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                 valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                 valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                 valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                 valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'%'+tempant111+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)%Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
;

AdicionExpr
    : MultiplicativeExpr
    {
        $$ = $1;
    }
    | AdicionExpr '+' MultiplicativeExpr
    {
        //console.log('++', $1, $3);
        if($1[0] == 'STRING'  && $3[0] == 'STRING')
        {
            var r = [];
            r[0] = "STRING";
            r[1] = $1[1];
            var valor = '';
            valor += $1[3];
            for(var a = 0; a<$3[5].length; a++)
             {
                 valor += $1[1] + ' = ' + $1[1] + ' + 1;';
                 valor += '\n';
                 valor += 'heap[(int)'+$1[1]+'] = ' + $3[5].charCodeAt(a) + ';';
                 valor += '\n'
             }
            r[2] = '';
            r[3] = valor;
            r[4] = '';
            r[5] = $1[5] + $3[5];
            r[6] = $1[6] + $3[6];
            $$ = r;
        }
        else if($1[0] == 'STRING' && $3[0] != '')
        {
             var r = [];
             r[0] = "STRING";
             r[1] = $1[1];
             var valor = '';
             valor += $1[3];
             var val = $3[6].toString();
             for(var a = 0; a<val.length; a++)
              {
                  valor += $1[1] + ' = ' + $1[1] + ' + 1;';
                  valor += '\n';
                  valor += 'heap[(int)'+$1[1]+'] = ' + val.charCodeAt(a) + ';';
                  valor += '\n'
              }
             r[2] = '';
             r[3] = valor;
             r[4] = '';
             r[5] = $1[5] + $3[5].toString();
             r[6] = $1[6] + $3[6].toString();
             $$ = r;
        }
        else if($1[0] != '' && $3[0] == 'STRING')
        {
             var r = [];
             r[0] = "STRING";
             r[1] = $1[1];
             var valor = '';
             var val = $1[6].toString();
             for(var a = 0; a<val.length; a++)
              {
                  valor += $1[1] + ' = ' + $1[1] + ' + 1;';
                  valor += '\n';
                  valor += 'heap[(int)'+$1[1]+'] = ' + val.charCodeAt(a) + ';';
                  valor += '\n'
              }
              valor += $3[3];
             r[2] = '';
             r[3] = valor;
             r[4] = '';
             r[5] = $1[5].toString() + $3[5];
             r[6] = $1[6].toString() + $3[6];
             $$ = r;
        }
        else if ($1[0] != '' && $3[0] != '')
        {
            var valor = '';
            var r = [];
            valor += $1[3];
            valor += '\n';
            valor += $3[3];
            valor += '\n';

            var temp = Temp.getTemporal();
            valor += temp + ' = ' + $1[1] + ' + ' + $3[1] + ';';

            r[0] = 'NUMBER';
            r[1] = temp;
            r[2] = '';
            r[3] = valor;
            r[4] = '';
            r[5] = '';
            r[6] = Number($1[6]) + Number($3[6]);
            $$ = r;
        }
        else if ($1[0] == '' && $3[0] == '')
        {
            var n = tab.getPositionAmbito($1[4]);
            if(n!=null)
            {
                var n1 = tab.getPositionAmbito($3[4]);
                if(n1!=null)
                {
                    if(n.tipo.toUpperCase() != 'STRING' && n1.tipo.toUpperCase() != 'STRING')
                    {
                        var valor = '';
                        var r = [];

                        var temp = Temp.getTemporal();
                        valor += temp + ' = ' + n.position + ';';
                        valor += '\n';
                        var temp1 = Temp.getTemporal();
                        if(n.entorno == 'global')
                        {
                            valor += temp1 + ' = heap[(int)'+temp+'];';
                        }
                        else
                        {
                            valor += temp1 + ' = stack[(int)'+temp+'];';
                        }

                        valor += '\n';

                        var temp2 = Temp.getTemporal();
                        valor += temp2 + ' = ' + n1.position + ';';
                        valor += '\n';
                        var temp3 = Temp.getTemporal();
                        if(n1.entorno == 'global')
                        {
                            valor += temp3 + ' = heap[(int)'+temp2+'];';
                        }
                        else
                        {
                            valor += temp3 + ' = stack[(int)'+temp2+'];';
                        }

                        valor += '\n';

                        var temp4 = Temp.getTemporal();
                        valor += temp4 + ' = ' + temp1 + ' + ' + temp3 + ';';

                        r[0] = 'NUMBER';
                        r[1] = temp4;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number(n.valor) + Number(n1.valor);
                        $$ = r;
                    }
                    else
                    {
                        if(n.valor != null && n1.valor != null)
                        {
                            var temp = Temp.getTemporal();
                            var r = [];
                            r[0] = "STRING";
                            r[1] = temp;
                            r[2] = '';

                            var valor = '';
                            for(var a = 0; a<n.toString().length; a++)
                            {
                                valor += temp + ' = ' + temp + ' + 1;';
                                valor += '\n';
                                valor += 'heap[(int)'+temp+'] = ' + n.toString().charCodeAt(a) + ';';
                                valor += '\n';
                            }
                            for(var a = 0; a<n1.toString().length; a++)
                            {
                                valor += temp + ' = ' + temp + ' + 1;';
                                valor += '\n';
                                valor += 'heap[(int)'+temp+'] = ' + n1.toString().charCodeAt(a) + ';';
                                valor += '\n';
                            }
                            r[3] = valor;
                            r[4] = '';
                            r[5] = n.valor.toString() + n1.valor.toString();
                            r[6] = n.valor.toString() + n1.valor.toString();

                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se operar con variables nulas;`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe una variable con el identificador: ${$3[4]};`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe una variable con el identificador:  ${$1[4]};`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            if($1[0] == '' && $3[0] != '')
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if(n.tipo.toUpperCase() == "STRING")
                    {
                         var r = [];
                         r[0] = "STRING";

                         var temp = Temp.getTemporal();
                         var valor = '';
                         var tempa = Temp.getTemporal();
                         valor += temp + ' = ' + temp + ' + 1;';
                         valor += `${tempa} = ${temp} - 1;\n`;
                         valor += '\n';
                         var label = Label.getBandera();
                         var label1 = Label.getBandera();

                         var temp1 = Temp.getTemporal();
                         var temp2 = Temp.getTemporal();
                         var temp3 = Temp.getTemporal();
                         if(n.rol == 'Parametro')
                         {
                            valor += `${temp3} = ${n.valor};\n`;
                         }
                         else
                         {
                            if(n.entorno == 'global')
                            {
                                valor += `${temp3} = heap[${n.position}];\n`;
                            }
                            else
                            {
                                valor += `${temp3} = stack[${n.position}];\n`;
                            }
                         }
                         var temp0 = Temp.getTemporal();
                         var temp00 = Temp.getTemporal();
                         valor += `${temp1}=0;\n`;
                         valor += `${temp0}=0;\n`;
                         valor += `${temp00}=heap[(int)${temp3}];\n`;
                         valor += `${temp2} = heap[(int)${temp00}];\n`;
                         valor += `${temp00}= ${temp00}+1;\n`;
                         var temp4 = Temp.getTemporal();
                         valor += `${label}:\n`;
                         valor += `if(${temp1}==${temp2}) goto ${label1};\n`;
                         valor += `${temp4} = ${temp00} + ${temp1};\n`;
                         valor += `${temp1} = ${temp1} + 1;\n`;
                         valor += `heap[(int)${temp}] = heap[(int) ${temp4}];\n`;
                         valor += `${temp} = ${temp} + 1;\n`;
                         valor += `${temp0} = ${temp0} + 1;\n`;
                         valor += `goto ${label};\n`;
                         valor += `${label1}:\n`;

                         for(var a = 0; a<$3[6].toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + $3[6].toString().charCodeAt(a) + ';';
                            valor += '\n';
                            valor += `${temp0} = ${temp0} + 1;\n`;
                         }
                         valor += `heap[(int)${tempa}] = ${temp0};\n`;
                         r[1] = temp;
                         r[2] = '';
                         r[3] = valor;
                         r[4] = '';
                         r[5] = n.valor.toString() + $3[6].toString();
                         r[6] = n.valor.toString() + $3[6].toString();
                         r[7] = temp0;
                         $$ = r;
                    }
                    else if ( $3[0] == 'STRING')
                    {
                         var r = [];
                         r[0] = "STRING";

                         var temp = Temp.getTemporal();
                         var valor = '';
                         for(var a = 0; a<n.valor.toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + n.valor.toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }

                         for(var a = 0; a<$3[6].toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + $3[6].toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }
                         r[1] = temp;
                         r[2] = '';
                         r[3] = valor;
                         r[4] = '';
                         r[5] = n.valor.toString() + $3[6].toString();
                         r[6] = n.valor.toString() + $3[6];
                         $$ = r;
                    }
                    else
                    {
                        var valor = '';
                        var r = [];

                        var temp = Temp.getTemporal();
                        valor += temp + ' = ' + n.position + ';';
                        valor += '\n';
                        var temp1 = Temp.getTemporal();
                        if(n.entorno == 'global')
                        {
                            valor += temp1 + ' = heap[(int)'+temp+'];';
                        }
                        else
                        {
                            valor += temp1 + ' = stack[(int)'+temp+'];';
                        }

                        valor += '\n';

                        valor += $3[3];
                        valor += '\n';

                        var temp4 = Temp.getTemporal();
                        valor += temp4 + ' = ' + temp1 + ' + ' + $3[1] + ';';

                        r[0] = 'NUMBER';
                        r[1] = temp4;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = Number(n.valor) + Number($3[6]);
                        r[6] = Number(n.valor) + Number($3[6]);
                        $$ = r;
                    }
                }
                else
                {
                   semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe una variable con el identificador:  ${$1[4]};`+'\"}');
                   $$ = ['','','',''];
                }
            }
            else if($1[0] != '' && $3[0] == '')
            {
                var n = tab.getPositionAmbito($3[4]);
                if(n!=null)
                {
                    if(n.tipo.toUpperCase() == "STRING")
                    {
                         var r = [];
                         r[0] = "STRING";

                         var temp = Temp.getTemporal();
                         var valor = '';


                         for(var a = 0; a<$1[6].toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + $1[6].toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }

                         var label = Label.getBandera();
                         var label1 = Label.getBandera();

                         var temp1 = Temp.getTemporal();
                         var temp2 = Temp.getTemporal();
                         var temp3 = Temp.getTemporal();
                         if(n.rol == 'Parametro')
                         {
                            valor += `${temp3} = ${n.valor};\n`;
                         }
                         else
                         {
                            if(n.entorno == 'global')
                            {
                                valor += `${temp3} = heap[${n.position}];\n`;
                            }
                            else
                            {
                                valor += `${temp3} = stack[${n.position}];\n`;
                            }
                         }
                         var temp0 = Temp.getTemporal();
                         valor += `${temp1}=0;\n`;
                         valor += `${temp0}=0;\n`;
                         valor += `${temp2}=heap[(int)${temp3}];\n`;
                         var temp4 = Temp.getTemporal();
                         valor += `${label}:\n`;
                         valor += `if(${temp1}==${temp2}) goto ${label1};\n`;
                         valor += `${temp4} = ${temp2} + ${temp1};\n`;
                         valor += `${temp1} = ${temp1} + 1;\n`;
                         valor += `heap[(int)${temp}] = heap[(int) ${temp2}];\n`;
                         valor += `${temp} = ${temp} + 1;\n`;
                         valor += `${temp0} = ${temp0} + 1;\n`;
                         valor += `goto ${label};\n`;
                         valor += `${label1}:\n`;

                         r[1] = temp;
                         r[2] = '';
                         r[3] = valor;
                         r[4] = '';
                         r[5] = $1[6].toString() + n.valor.toString();
                         r[6] = $1[6].toString() + n.valor.toString();
                         $$ = r;
                    }
                    else if ( $1[0] == 'STRING')
                    {
                         var r = [];
                         r[0] = "STRING";

                         var temp = Temp.getTemporal();
                         var valor = '';
                          var val = $1[6].toString();
                          for(var a = 0; a<val.length; a++)
                          {
                             valor += temp + ' = ' + temp + ' + 1;';
                             valor += '\n';
                             valor += 'heap[(int)'+temp+'] = ' + val.charCodeAt(a) + ';';
                             valor += '\n';
                          }

                         for(var a = 0; a<n.valor.toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + n.valor.toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }


                         r[1] = temp;
                         r[2] = '';
                         r[3] = valor;
                         r[4] = '';
                         r[5] = $1[6].toString() + n.valor.toString();
                         r[6] = $1[6].toString() + n.valor.toString();
                         $$ = r;
                    }
                    else
                    {
                        var valor = '';
                        var r = [];

                        valor += $1[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp + ' = ' + n.position + ';';
                        valor += '\n';
                        var temp1 = Temp.getTemporal();
                        if(n.entorno == 'global')
                        {
                            valor += temp1 + ' = heap[(int)'+temp+'];';
                        }
                        else
                        {
                            valor += temp1 + ' = stack[(int)'+temp+'];';
                        }

                        valor += '\n';

                        var temp4 = Temp.getTemporal();
                        valor += temp4 + ' = ' + $1[1] + ' + ' + temp1 + ';';

                        r[0] = 'NUMBER';
                        r[1] = temp4;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6]) + Number(n.valor);
                        $$ = r;
                    }
                }
                else
                {
                   semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe una variable con el identificador:  ${$1[4]};`+'\"}');
                   $$ = ['','','',''];
                }
            }
            else
            {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp + ' = ' + $1[1] + ' + ' + $3[1] + ';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6]) + Number($3[6]);
                        $$ = r;
            }
        }
    }
    | AdicionExpr '-' MultiplicativeExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'-'+$3[1]+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])-Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'-'+tempant1+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])-Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'-'+$3[1]+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)-Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'-'+tempant111+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)-Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
;

AdicionExprNoBF
    : MultiplicativeExprNoBF
    {
        $$ = $1;
    }
    | AdicionExprNoBF '+' MultiplicativeExpr
    {
        if($1[0] == 'STRING'  && $3[0] == 'STRING')
        {
            var r = [];
            r[0] = "STRING";
            r[1] = $1[1];
            var valor = '';
            valor += $1[3];
            for(var a = 0; a<$3[5].length; a++)
             {
                 valor += $1[1] + ' = ' + $1[1] + ' + 1;';
                 valor += '\n';
                 valor += 'heap[(int)'+$1[1]+'] = ' + $3[5].charCodeAt(a) + ';';
                 valor += '\n'
             }
            r[2] = '';
            r[3] = valor;
            r[4] = '';
            r[5] = $1[5] + $3[5];
            r[6] = $1[6] + $3[6];
            $$ = r;
        }
        else if($1[0] == 'STRING' && $3[0] != '')
        {
             var r = [];
             r[0] = "STRING";
             r[1] = $1[1];
             var valor = '';
             valor += $1[3];
             var val = $3[6].toString();
             for(var a = 0; a<val.length; a++)
              {
                  valor += $1[1] + ' = ' + $1[1] + ' + 1;';
                  valor += '\n';
                  valor += 'heap[(int)'+$1[1]+'] = ' + val.charCodeAt(a) + ';';
                  valor += '\n'
              }
             r[2] = '';
             r[3] = valor;
             r[4] = '';
             r[5] = $1[5] + $3[5].toString();
             r[6] = $1[6] + $3[6].toString();
             $$ = r;
        }
        else if($1[0] != '' && $3[0] == 'STRING')
        {
             var r = [];
             r[0] = "STRING";
             r[1] = $1[1];
             var valor = '';
             var val = $1[6].toString();
             for(var a = 0; a<val.length; a++)
              {
                  valor += $1[1] + ' = ' + $1[1] + ' + 1;';
                  valor += '\n';
                  valor += 'heap[(int)'+$1[1]+'] = ' + val.charCodeAt(a) + ';';
                  valor += '\n'
              }
              valor += $3[3];
             r[2] = '';
             r[3] = valor;
             r[4] = '';
             r[5] = $1[5].toString() + $3[5];
             r[6] = $1[6].toString() + $3[6];
             $$ = r;
        }
        else if ($1[0] != '' && $3[0] != '')
        {
            var valor = '';
            var r = [];
            valor += $1[3];
            valor += '\n';
            valor += $3[3];
            valor += '\n';

            var temp = Temp.getTemporal();
            valor += temp + ' = ' + $1[1] + ' + ' + $3[1] + ';';

            r[0] = 'NUMBER';
            r[1] = temp;
            r[2] = '';
            r[3] = valor;
            r[4] = '';
            r[5] = '';
            r[6] = Number($1[6]) + Number($3[6]);
            $$ = r;
        }
        else if ($1[0] == '' && $3[0] == '')
        {
            var n = tab.getPositionAmbito($1[4]);
            if(n!=null)
            {
                var n1 = tab.getPositionAmbito($3[4]);
                if(n1!=null)
                {
                    if(n.tipo.toUpperCase() != 'STRING' && n1.tipo.toUpperCase() != 'STRING')
                    {
                        var valor = '';
                        var r = [];

                        var temp = Temp.getTemporal();
                        valor += temp + ' = ' + n.position + ';';
                        valor += '\n';
                        var temp1 = Temp.getTemporal();
                        if(n.entorno == 'global')
                        {
                            valor += temp1 + ' = heap[(int)'+temp+'];';
                        }
                        else
                        {
                            valor += temp1 + ' = stack[(int)'+temp+'];';
                        }

                        valor += '\n';

                        var temp2 = Temp.getTemporal();
                        valor += temp2 + ' = ' + n1.position + ';';
                        valor += '\n';
                        var temp3 = Temp.getTemporal();
                        if(n1.entorno == 'global')
                        {
                            valor += temp3 + ' = heap[(int)'+temp2+'];';
                        }
                        else
                        {
                            valor += temp3 + ' = stack[(int)'+temp2+'];';
                        }

                        valor += '\n';

                        var temp4 = Temp.getTemporal();
                        valor += temp4 + ' = ' + temp1 + ' + ' + temp3 + ';';

                        r[0] = 'NUMBER';
                        r[1] = temp4;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number(n.valor) + Number(n1.valor);
                        $$ = r;
                    }
                    else
                    {
                        if(n.valor != null && n1.valor != null)
                        {
                            var temp = Temp.getTemporal();
                            var r = [];
                            r[0] = "STRING";
                            r[1] = temp;
                            r[2] = '';

                            var valor = '';
                            for(var a = 0; a<n.toString().length; a++)
                            {
                                valor += temp + ' = ' + temp + ' + 1;';
                                valor += '\n';
                                valor += 'heap[(int)'+temp+'] = ' + n.toString().charCodeAt(a) + ';';
                                valor += '\n';
                            }
                            for(var a = 0; a<n1.toString().length; a++)
                            {
                                valor += temp + ' = ' + temp + ' + 1;';
                                valor += '\n';
                                valor += 'heap[(int)'+temp+'] = ' + n1.toString().charCodeAt(a) + ';';
                                valor += '\n';
                            }
                            r[3] = valor;
                            r[4] = '';
                            r[5] = n.valor.toString() + n1.valor.toString();
                            r[6] = n.valor.toString() + n1.valor.toString();

                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se operar con variables nulas;`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe una variable con el identificador: ${$3[4]};`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe una variable con el identificador:  ${$1[4]};`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            if($1[0] == '' && $3[0] != '')
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if(n.tipo.toUpperCase() == "STRING")
                    {
                         var r = [];
                         r[0] = "STRING";

                         var temp = Temp.getTemporal();
                         var valor = '';
                         for(var a = 0; a<n.valor.toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + n.valor.toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }

                         for(var a = 0; a<$3[6].toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + $3[6].toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }
                         r[1] = temp;
                         r[2] = '';
                         r[3] = valor;
                         r[4] = '';
                         r[5] = n.valor.toString() + $3[6].toString();
                         r[6] = n.valor.toString() + $3[6].toString();
                         $$ = r;
                    }
                    else if ( $3[0] == 'STRING')
                    {
                         var r = [];
                         r[0] = "STRING";

                         var temp = Temp.getTemporal();
                         var valor = '';
                         for(var a = 0; a<n.valor.toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + n.valor.toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }

                         for(var a = 0; a<$3[6].toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + $3[6].toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }
                         r[1] = temp;
                         r[2] = '';
                         r[3] = valor;
                         r[4] = '';
                         r[5] = n.valor.toString() + $3[6].toString();
                         r[6] = n.valor.toString() + $3[6];
                         $$ = r;
                    }
                    else
                    {
                        var valor = '';
                        var r = [];

                        var temp = Temp.getTemporal();
                        valor += temp + ' = ' + n.position + ';';
                        valor += '\n';
                        var temp1 = Temp.getTemporal();
                        if(n.entorno == 'global')
                        {
                            valor += temp1 + ' = heap[(int)'+temp+'];';
                        }
                        else
                        {
                            valor += temp1 + ' = stack[(int)'+temp+'];';
                        }

                        valor += '\n';

                        valor += $3[3];
                        valor += '\n';

                        var temp4 = Temp.getTemporal();
                        valor += temp4 + ' = ' + temp1 + ' + ' + $3[1] + ';';

                        r[0] = 'NUMBER';
                        r[1] = temp4;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = Number(n.valor) + Number($3[6]);
                        r[6] = Number(n.valor) + Number($3[6]);
                        $$ = r;
                    }
                }
                else
                {
                   semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe una variable con el identificador:  ${$1[4]};`+'\"}');
                   $$ = ['','','',''];
                }
            }
            else if($1[0] != '' && $3[0] == '')
            {
                var n = tab.getPositionAmbito($3[4]);
                if(n!=null)
                {
                    if(n.tipo.toUpperCase() == "STRING")
                    {
                         var r = [];
                         r[0] = "STRING";

                         var temp = Temp.getTemporal();
                         var valor = '';


                         for(var a = 0; a<$1[6].toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + $1[6].toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }

                        for(var a = 0; a<n.valor.toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + n.valor.toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }

                         r[1] = temp;
                         r[2] = '';
                         r[3] = valor;
                         r[4] = '';
                         r[5] = $1[6].toString() + n.valor.toString();
                         r[6] = $1[6].toString() + n.valor.toString();
                         $$ = r;
                    }
                    else if ( $1[0] == 'STRING')
                    {
                         var r = [];
                         r[0] = "STRING";

                         var temp = Temp.getTemporal();
                         var valor = '';
                          var val = $1[6].toString();
                          for(var a = 0; a<val.length; a++)
                          {
                             valor += temp + ' = ' + temp + ' + 1;';
                             valor += '\n';
                             valor += 'heap[(int)'+temp+'] = ' + val.charCodeAt(a) + ';';
                             valor += '\n';
                          }

                         for(var a = 0; a<n.valor.toString().length; a++)
                         {
                            valor += temp + ' = ' + temp + ' + 1;';
                            valor += '\n';
                            valor += 'heap[(int)'+temp+'] = ' + n.valor.toString().charCodeAt(a) + ';';
                            valor += '\n';
                         }


                         r[1] = temp;
                         r[2] = '';
                         r[3] = valor;
                         r[4] = '';
                         r[5] = $1[6].toString() + n.valor.toString();
                         r[6] = $1[6].toString() + n.valor.toString();
                         $$ = r;
                    }
                    else
                    {
                        var valor = '';
                        var r = [];

                        valor += $1[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp + ' = ' + n.position + ';';
                        valor += '\n';
                        var temp1 = Temp.getTemporal();
                        if(n.entorno == 'global')
                        {
                            valor += temp1 + ' = heap[(int)'+temp+'];';
                        }
                        else
                        {
                            valor += temp1 + ' = stack[(int)'+temp+'];';
                        }

                        valor += '\n';

                        var temp4 = Temp.getTemporal();
                        valor += temp4 + ' = ' + $1[1] + ' + ' + temp1 + ';';

                        r[0] = 'NUMBER';
                        r[1] = temp4;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6]) + Number(n.valor);
                        $$ = r;
                    }
                }
                else
                {
                   semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe una variable con el identificador:  ${$1[4]};`+'\"}');
                   $$ = ['','','',''];
                }
            }
            else
            {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp + ' = ' + $1[1] + ' + ' + $3[1] + ';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6]) + Number($3[6]);
                        $$ = r;
            }
        }
    }
    | AdicionExprNoBF '-' MultiplicativeExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'-'+$3[1]+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])-Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'-'+tempant1+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])-Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'-'+$3[1]+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)-Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'-'+tempant111+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)-Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
;

RelacionalExpr
    : AdicionExpr
    {
        $$ = $1;
    }
    | RelacionalExpr '<' AdicionExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<'+$3[1]+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<'+tempant1+';';

                        r[0] = 'NUMBER';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'<'+$3[1]+';';

                            r[0] = 'NUMBER';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'<'+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | RelacionalExpr '>' AdicionExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>'+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>'+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'>'+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += '\n';

                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'>'+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
;

RelacionalExprNoIn
    : AdicionExpr
    {
        $$ = $1;
    }
    | RelacionalExprNoIn '<' AdicionExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<'+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<'+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'<'+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'<'+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | RelacionalExprNoIn '>' AdicionExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>'+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>'+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'>'+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno = 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += '\n';

                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'>'+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
;

RelacionalExprNoBF
    : AdicionExprNoBF
    {
        $$ = $1;
    }
    | RelacionalExprNoBF '<' AdicionExprNoBF
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<'+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<'+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'<'+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'<'+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | RelacionalExprNoBF '>' AdicionExprNoBF
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>'+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>'+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'>'+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'>'+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
;

IgualdadExpr
    : RelacionalExpr
    {
        $$ = $1;
    }
    | IgualdadExpr EQQ RelacionalExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'=='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])==Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'=='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])==Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'=='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)==Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'=='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)==Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else if($1[0] == 'STRING' && $3[0] == '')
        {
            var valor = '';
            var temp = Temp.getTemporal();
            var n = tab.getPositionAmbito($3[4]);
            if(n!=null)
            {
                if(n.tipo.toUpperCase() == 'STRING')
                {
                    if($1[5].toString() == n.valor.toString())
                    {
                        valor += `${temp} = 1;\n`;
                    }
                    else
                    {
                        valor += `${temp} = 0;\n`;
                    }
                    var r = [];
                    r[0] = 'BOOLEAN';
                    r[1] = temp;
                    r[2] = '';
                    r[3] = valor;
                    r[4] = '';
                    r[5] = $1[5].toString() == n.valor.toString();
                    r[6] = $1[5].toString() == n.valor.toString();
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else if( $1[0] == '' && $3[0] == 'STRING')
        {
            var valor = '';
            var temp = Temp.getTemporal();
            var n = tab.getPositionAmbito($1[4]);

            if(n!=null)
            {
                if(n.tipo.toUpperCase() == 'STRING')
                {
                    if($3[5].toString() == n.valor.toString())
                    {
                        valor += `${temp} = 1;\n`;
                    }
                    else
                    {
                        valor += `${temp} = 0;\n`;
                    }
                    var r = [];
                    r[0] = 'BOOLEAN';
                    r[1] = temp;
                    r[2] = '';
                    r[3] = valor;
                    r[4] = '';
                    r[5] = $3[5].toString() == n.valor.toString();
                    r[6] = $3[5].toString() == n.valor.toString();
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IgualdadExpr NOEQQ RelacionalExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'!='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])!=Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'!='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])!=Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'!='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)!=Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'!='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)!=Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else if($1[0] == 'STRING' && $3[0] == '')
        {
            var valor = '';
            var temp = Temp.getTemporal();
            var n = tab.getPositionAmbito($3[4]);
            if(n!=null)
            {
                if(n.tipo.toUpperCase() == 'STRING')
                {
                    if($1[5].toString() != n.valor.toString())
                    {
                        valor += `${temp} = 1;\n`;
                    }
                    else
                    {
                        valor += `${temp} = 0;\n`;
                    }
                    var r = [];
                    r[0] = 'BOOLEAN';
                    r[1] = temp;
                    r[2] = '';
                    r[3] = valor;
                    r[4] = '';
                    r[5] = $1[5].toString() != n.valor.toString();
                    r[6] = $1[5].toString() != n.valor.toString();
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else if( $1[0] == '' && $3[0] == 'STRING')
        {
            var valor = '';
            var temp = Temp.getTemporal();
            var n = tab.getPositionAmbito($1[4]);
            if(n!=null)
            {
                if(n.tipo.toUpperCase() == 'STRING')
                {
                    if($3[5].toString() != n.valor.toString())
                    {
                        valor += `${temp} = 1;\n`;
                    }
                    else
                    {
                        valor += `${temp} = 0;\n`;
                    }
                    var r = [];
                    r[0] = 'BOOLEAN';
                    r[1] = temp;
                    r[2] = '';
                    r[3] = valor;
                    r[4] = '';
                    r[5] = $3[5].toString() != n.valor.toString();
                    r[6] = $3[5].toString() != n.valor.toString();
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IgualdadExpr MAQ RelacionalExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>=Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>=Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'>='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>=Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += '\n';

                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'>='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>=Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else if($1[0] == 'STRING' && $3[0] == '')
        {
            var valor = '';
            var temp = Temp.getTemporal();
            var n = tab.getPositionAmbito($3[4]);
            if(n!=null)
            {
                if(n.tipo.toUpperCase() == 'STRING')
                {
                    if($1[5].toString() >= n.valor.toString())
                    {
                        valor += `${temp} = 1;\n`;
                    }
                    else
                    {
                        valor += `${temp} = 0;\n`;
                    }
                    var r = [];
                    r[0] = 'BOOLEAN';
                    r[1] = temp;
                    r[2] = '';
                    r[3] = valor;
                    r[4] = '';
                    r[5] = $1[5].toString() >= n.valor.toString();
                    r[6] = $1[5].toString() >= n.valor.toString();
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else if( $1[0] == '' && $3[0] == 'STRING')
        {
            var valor = '';
            var temp = Temp.getTemporal();
            var n = tab.getPositionAmbito($1[4]);
            if(n!=null)
            {
                if(n.tipo.toUpperCase() == 'STRING')
                {
                    if($3[5].toString() >= n.valor.toString())
                    {
                        valor += `${temp} = 1;\n`;
                    }
                    else
                    {
                        valor += `${temp} = 0;\n`;
                    }
                    var r = [];
                    r[0] = 'BOOLEAN';
                    r[1] = temp;
                    r[2] = '';
                    r[3] = valor;
                    r[4] = '';
                    r[5] = $3[5].toString() >= n.valor.toString();
                    r[6] = $3[5].toString() >= n.valor.toString();
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IgualdadExpr MIQ RelacionalExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<=Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<=Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'<='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<=Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'<='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<=Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else if($1[0] == 'STRING' && $3[0] == '')
        {
            var valor = '';
            var temp = Temp.getTemporal();
            var n = tab.getPositionAmbito($3[4]);
            if(n!=null)
            {
                if(n.tipo.toUpperCase() == 'STRING')
                {
                    if($1[5].toString() <= n.valor.toString())
                    {
                        valor += `${temp} = 1;\n`;
                    }
                    else
                    {
                        valor += `${temp} = 0;\n`;
                    }
                    var r = [];
                    r[0] = 'BOOLEAN';
                    r[1] = temp;
                    r[2] = '';
                    r[3] = valor;
                    r[4] = '';
                    r[5] = $1[5].toString() <= n.valor.toString();
                    r[6] = $1[5].toString() <= n.valor.toString();
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else if( $1[0] == '' && $3[0] == 'STRING')
        {
            var valor = '';
            var temp = Temp.getTemporal();
            var n = tab.getPositionAmbito($1[4]);
            if(n!=null)
            {
                if(n.tipo.toUpperCase() == 'STRING')
                {
                    if($3[5].toString() <= n.valor.toString())
                    {
                        valor += `${temp} = 1;\n`;
                    }
                    else
                    {
                        valor += `${temp} = 0;\n`;
                    }
                    var r = [];
                    r[0] = 'BOOLEAN';
                    r[1] = temp;
                    r[2] = '';
                    r[3] = valor;
                    r[4] = '';
                    r[5] = $3[5].toString() <= n.valor.toString();
                    r[6] = $3[5].toString() <= n.valor.toString();
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
                $$ = ['','','',''];
            }

        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion.`+'\"}');
            $$ = ['','','',''];
        }
    }
;

IgualdadExprNoIn
    : RelacionalExprNoIn
    {
        $$ = $1;
    }
    | IgualdadExprNoIn EQQ RelacionalExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'=='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])==Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'=='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])==Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'=='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)==Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'=='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)==Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IgualdadExprNoIn NOEQQ RelacionalExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'!='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])!=Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'!='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])!=Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'!='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)!=Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'!='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)!=Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IgualdadExprNoIn MAQ RelacionalExprNoIn
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>=Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>=Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'>='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>=Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'>='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>=Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IgualdadExprNoIn MIQ RelacionalExprNoIn
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<=Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<=Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'<='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<=Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'<='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<=Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
;

IgualdadExprNoBF
    : RelacionalExprNoBF
    {
        $$ = $1;
    }
    | IgualdadExprNoBF EQQ RelacionalExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'=='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])==Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'=='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])==Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'=='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)==Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'=='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)==Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IgualdadExprNoBF NOEQQ RelacionalExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'!='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])!=Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'!='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])!=Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'!='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)!=Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                 valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                 valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'!='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)!=Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IgualdadExprNoBF MAQ RelacionalExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>=Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'>='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])>=Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'>='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>=Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'>='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)>=Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
    | IgualdadExprNoBF MIQ RelacionalExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<='+$3[1]+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<=Number($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null)
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        valor += temp +'='+$1[1]+'<='+tempant1+';';

                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = '';
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Number($1[6])<=Number(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null)
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            valor += temp+'='+tempant1+'<='+$3[1]+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<=Number($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null)
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            valor += temp +'='+tempant1+'<='+tempant111+';';

                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = '';
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Number(n.valor)<=Number(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, no se puede aplicar  a variables de tipo STRING`+'\"}');
            $$ = ['','','',''];
        }
    }
;


LogicaYYExpr
    : IgualdadExpr
    {
        $$ = $1;
    }
    | LogicaYYExpr AND IgualdadExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) && Boolean($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null && n.tipo.toUpperCase() == 'BOOLEAN')
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+tempant1+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) && Boolean(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        //console.log('ERror', $1, $3);
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}..., de tipo booleano`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null && n.tipo.toUpperCase() == 'BOOLEAN')
                {
                    if($3[0] != '' && $3[0] == 'BOOLEAN')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean(n.valor) && Boolean($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null && n1.tipo.toUpperCase() == 'BOOLEAN')
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+tempant111+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean(n.valor) && Boolean(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}, de tipo booleano`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}, de tipo booleano.`+'\"}');
                    $$ = ['','','',''];
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, unicamente variables de tipo BOOLEANO.`+'\"}');
            $$ = ['','','',''];
        }
    }
;

LogicaYYExprNoIn
    : IgualdadExprNoIn
    {
        $$ = $1;
    }
    | LogicaYYExprNoIn AND IgualdadExprNoIn
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '' )
            {
                if($3[0] != '' && $3[0] == 'BOOLEAN')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) && Boolean($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null && n.tipo.toUpperCase() == 'BOOLEAN')
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+tempant1+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) && Boolean(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}, de tipo booleano`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null && n.tipo.toUpperCase() == 'BOOLEAN')
                {
                    if($3[0] != '' && $3[0] == 'BOOLEAN')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean(n.valor) && Boolean($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null && n1.tipo.toUpperCase() == 'BOOLEAN')
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }
                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+tempant111+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean(n.valor) && Boolean(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}, de tipo booleano`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, unicamente variables de tipo BOOLEANO`+'\"}');
            $$ = ['','','',''];
        }
    }
;

LogicaYYExprNoBF
    : IgualdadExprNoBF
    {
        $$ = $1;
    }
    | LogicaYYExprNoBF AND IgualdadExprNoBF
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '' )
            {
                if($3[0] != '' && $3[0] == 'BOOLEAN')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) && Boolean($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null && n.tipo.toUpperCase() == 'BOOLEAN')
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+tempant1+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) && Boolean(n.valor);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}, de tipo booleano`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else if($1[0] == '')
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null && n.tipo.toUpperCase() == 'BOOLEAN')
                {
                    if($3[0] != '' && $3[0] == 'BOOLEAN')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean(n.valor) && Boolean($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null && n1.tipo.toUpperCase() == 'BOOLEAN')
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+tempant111+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean(n.valor) && Boolean(n1.valor);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}, de tipo booleano`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}, de tipo booleano`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, unicamente valores de tipo BOOLEANO`+'\"}');
            $$ = ['','','',''];
        }
    }
;

LogicaOOExpr
    : LogicaYYExpr
    {
        $$ = $1;
    }
    | LogicaOOExpr OR LogicaYYExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();
                        var label5 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label2+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label5+';\n';
                        valor += label5 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) || Boolean($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null && n.tipo.toUpperCase() != 'STRING' )
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();
                        var label5 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+tempant1+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label2+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t if('+tempant1+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label5+';\n';
                        valor += label5 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) || Boolean($3[6]);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else if($1[0] == '')
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null && n.tipo.toUpperCase() != 'STRING')
                {
                    if($3[0] != '')
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();
                            var label5 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label2+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label5+';\n';
                            valor += label5 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean($1[6]) && Boolean($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null && n1.tipo.toUpperCase() != 'STRING')
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();
                            var label5 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+tempant11+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label2+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t if('+tempant11+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label5+';\n';
                            valor += label5 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean($1[6]) && Boolean($3[6]);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}.., de tipo booleano`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}.,, de tipo booleano`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, unicamente variables de tipo BOOLEANO`+'\"}');
            $$ = ['','','',''];
        }
    }
;

LogicaOOExprNoIn
    : LogicaYYExprNoIn
    {
        $$ = $1;
    }
    | LogicaOOExprNoIn OR LogicaYYExprNoIn
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '' )
            {
                if($3[0] != '')
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();
                        var label5 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label2+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label5+';\n';
                        valor += label5 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) || Boolean($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null && n.tipo.toUpperCase() != 'STRING')
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();
                        var label5 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+tempant1+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label2+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t if('+tempant1+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label5+';\n';
                        valor += label5 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) || Boolean($3[6]);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}, de tipo booleano`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else if($1[0] == '')
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null && n.tipo.toUpperCase() != 'STRING')
                {
                    if($3[0] != '' )
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();
                            var label5 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label2+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label5+';\n';
                            valor += label5 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean($1[6]) && Boolean($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null && n1.tipo.toUpperCase() != 'STRING')
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();
                            var label5 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+tempant11+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label2+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t if('+tempant11+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label5+';\n';
                            valor += label5 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean($1[6]) && Boolean($3[6]);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]}, de tipo booleano`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]}, de tipo booleano`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, unicamente variables de tipo BOOLEANO`+'\"}');
            $$ = ['','','',''];
        }
    }
;

LogicaOOExprNoBF
    : LogicaYYExprNoBF
    {
        $$ = $1;
    }
    | LogicaOOExprNoBF OR LogicaYYExpr
    {
        if($1[0] != 'STRING' && $3[0] != 'STRING')
        {
            if($1[0]!= '' )
            {
                if($3[0] != '' )
                {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';
                        valor += $3[3];
                        valor += '\n';

                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();
                        var label5 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label2+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label5+';\n';
                        valor += label5 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) || Boolean($3[6]);
                        $$ = r;
                }
                else
                {
                    var n = tab.getPositionAmbito($3[4]);
                    if(n!=null && n.tipo.toUpperCase() != 'STRING')
                    {
                        var valor = '';
                        var r = [];
                        valor += $1[3];
                        valor += '\n';

                        var tempant = Temp.getTemporal();
                        var tempant1 = Temp.getTemporal();

                        valor += tempant +'='+n.position+';\n';
                        if(n.entorno == 'global')
                        {
                            valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                        }
                        else
                        {
                            valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                        }


                        var temp = Temp.getTemporal();
                        var label0 = Label.getBandera();
                        var label1 = Label.getBandera();
                        var label2 = Label.getBandera();
                        var label3 = Label.getBandera();
                        var label4 = Label.getBandera();
                        var label5 = Label.getBandera();

                        valor += label0 + ':\n';
                        valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                        valor += '\t goto '+label3+';\n';
                        valor += label1 + ':\n';
                        valor += '\t if('+tempant1+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label2+';\n';
                        valor += label2 + ':\n';
                        valor += '\t' + temp + '=1;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label3 + ':\n';
                        valor += '\t if('+tempant1+'==1) goto '+label2+';\n';
                        valor += '\t goto '+label5+';\n';
                        valor += label5 + ':\n';
                        valor += '\t' + temp + '=0;\n';
                        valor += '\t goto '+label4+';\n';
                        valor += label4 + ':\n';


                        r[0] = 'BOOLEAN';
                        r[1] = temp;
                        r[2] = label4;
                        r[3] = valor;
                        r[4] = '';
                        r[5] = '';
                        r[6] = Boolean($1[6]) || Boolean($3[6]);
                        $$ = r;
                    }
                    else
                    {
                        semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]} de tipo booleano`+'\"}');
                        $$ = ['','','',''];
                    }
                }
            }
            else if($1[0] == '')
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null && n.tipo.toUpperCase() == 'BOOLEAN')
                {
                    if($3[0] != '' )
                    {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }

                            valor += $3[3];
                            valor += '\n';

                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();
                            var label5 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label2+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t if('+$3[1]+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label5+';\n';
                            valor += label5 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean($1[6]) && Boolean($3[6]);
                            $$ = r;
                    }
                    else
                    {
                        var n1 = tab.getPositionAmbito($3[4]);
                        if(n1!=null && n1.tipo.toUpperCase() != 'STRING')
                        {
                            var valor = '';
                            var r = [];
                            var tempant = Temp.getTemporal();
                            var tempant1 = Temp.getTemporal();

                            valor += tempant +'='+n.position+';\n';
                            if(n.entorno == 'global')
                            {
                                valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                            }
                            else
                            {
                                valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                            }


                            var tempant11 = Temp.getTemporal();
                            var tempant111 = Temp.getTemporal();

                            valor += tempant11 +'='+n1.position+';\n';
                            if(n1.entorno == 'global')
                            {
                                valor += tempant111 +'=heap[(int)'+tempant11+'];\n';
                            }
                            else
                            {
                                valor += tempant111 +'=stack[(int)'+tempant11+'];\n';
                            }


                            var temp = Temp.getTemporal();
                            var label0 = Label.getBandera();
                            var label1 = Label.getBandera();
                            var label2 = Label.getBandera();
                            var label3 = Label.getBandera();
                            var label4 = Label.getBandera();
                            var label5 = Label.getBandera();

                            valor += label0 + ':\n';
                            valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                            valor += '\t goto '+label3+';\n';
                            valor += label1 + ':\n';
                            valor += '\t if('+tempant11+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label2+';\n';
                            valor += label2 + ':\n';
                            valor += '\t' + temp + '=1;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label3 + ':\n';
                            valor += '\t if('+tempant11+'==1) goto '+label2+';\n';
                            valor += '\t goto '+label5+';\n';
                            valor += label5 + ':\n';
                            valor += '\t' + temp + '=0;\n';
                            valor += '\t goto '+label4+';\n';
                            valor += label4 + ':\n';


                            r[0] = 'BOOLEAN';
                            r[1] = temp;
                            r[2] = label4;
                            r[3] = valor;
                            r[4] = '';
                            r[5] = '';
                            r[6] = Boolean($1[6]) && Boolean($3[6]);
                            $$ = r;
                        }
                        else
                        {
                            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$3[4]} de tipo booleano`+'\"}');
                            $$ = ['','','',''];
                        }
                    }
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]} de tipo booleano`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion, unicamente variables de tipo BOOLEANO`+'\"}');
            $$ = ['','','',''];
        }
    }
;

CondicionTernariaExpr
    : LogicaOOExpr
    {
        $$ = $1;
    }
    | LogicaOOExpr '?' AssignmentExpr ':' AssignmentExpr
    {

        if($1[0] != 'STRING')
        {
            if($1[0]!= '')
            {
                var valor = '';
                var r = [];
                valor += $1[3]+'\n';
                valor += $3[3]+'\n';
                valor += $5[3]+'\n';

                var temp = Temp.getTemporal();
                var label0 = Label.getBandera();
                var label1 = Label.getBandera();
                var label2 = Label.getBandera();
                var label3 = Label.getBandera();

                valor += label0 + ':\n';
                valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                valor += '\t goto '+label2+';\n';
                valor += label1 + ':\n';
                valor += '\t'+temp+'='+$3[1]+';\n';
                valor += '\t goto '+label3+';\n';
                valor += label2 + ':\n';
                valor += '\t'+temp+'='+$5[1]+';\n';
                valor += '\t goto '+label3+';\n';
                valor += label3 + ':\n';


                if($1[6] == true)
                {
                    if(typeof $3[6] == "string")
                    {
                        r[0] = 'STRING';
                        r[6] = $3[6];
                        r[1] = $3[1];
                    }
                    else if(typeof $3[6] == "number")
                    {
                        r[0] = 'NUMBER';
                        r[6] = Number($3[6]);
                        r[1] = temp;
                    }
                    else if(typeof $3[6] == 'boolean')
                    {
                        r[0] = 'BOOLEAN';
                        r[6] = $3[6];
                        r[1] = temp;
                    }
                    else if($3[6] instanceof Array)
                    {
                        r[0] = 'ARREGLO';
                        r[6] = $3[6];
                        r[1] = temp;
                    }
                }
                else
                {
                    if(typeof $5[6] == "string")
                    {
                        r[0] = 'STRING';
                        r[6] = $5[6];
                        r[1] = $5[1];
                    }
                    else if(typeof $5[6] == "number")
                    {
                        r[0] = 'NUMBER';
                        r[6] = Number($5[6]);
                        r[1] = temp;
                    }
                    else if(typeof $5[6] == "boolean")
                    {
                        r[0] = 'BOOLEAN';
                        r[6] = $5[6];
                        r[1] = temp;
                    }
                    else if($5[6] instanceof Array)
                    {
                        r[0] = 'ARREGLO';
                        r[6] = $5[6];
                        r[1] = temp;
                    }
                }

                r[2] = label3;
                r[3] = valor;
                r[4] = '';
                r[5] = '';
                $$ = r;
            }
            else if($1[0] == '')
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null && n.tipo.toUpperCase() == 'BOOLEAN')
                {

                    var valor = '';
                    var r = [];
                    var tempant = Temp.getTemporal();
                    var tempant1 = Temp.getTemporal();

                    valor += tempant +'='+n.position+';\n';
                    if(n.entorno == 'global')
                    {
                        valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                    }
                    else
                    {
                        valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                    }

                    valor += $3[3]+'\n';
                    valor += $5[3]+'\n';

                    var temp = Temp.getTemporal();
                    var label0 = Label.getBandera();
                    var label1 = Label.getBandera();
                    var label2 = Label.getBandera();
                    var label3 = Label.getBandera();

                    valor += label0 + ':\n';
                    valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                    valor += '\t goto '+label2+';\n';
                    valor += label1 + ':\n';
                    valor += '\t'+temp+'='+$3[1]+';\n';
                    valor += '\t goto '+label3+';\n';
                    valor += label2 + ':\n';
                    valor += '\t'+temp+'='+$5[1]+';\n';
                    valor += '\t goto '+label3+';\n';
                    valor += label3 + ':\n';

                    if($1[6] == true)
                    {
                        if(typeof $3[6] == "string")
                        {
                            r[0] = 'STRING';
                            r[6] = $3[6];
                            r[1] = $3[1];
                        }
                        else if(typeof $3[6] == "number")
                        {
                            r[0] = 'NUMBER';
                            r[6] = Number($3[6]);
                            r[1] = temp;
                        }
                        else if(typeof $3[6] == "boolean")
                        {
                            r[0] = 'BOOLEAN';
                            r[6] = $3[6];
                            r[1] = temp;
                        }
                        else if($3[6] instanceof Array)
                        {
                            r[0] = 'ARREGLO';
                            r[6] = $3[6];
                            r[1] = temp;
                        }
                    }
                    else
                    {
                        if(typeof $5[6] == "string")
                        {
                            r[0] = 'STRING';
                            r[6] = $5[6];
                            r[1] = $5[1];
                        }
                        else if(typeof $5[6] == "number")
                        {
                            r[0] = 'NUMBER';
                            r[6] = Number($5[6]);
                            r[1] = temp;
                        }
                        else if(typeof $5[6] == "boolean")
                        {
                            r[0] = 'BOOLEAN';
                            r[6] = $5[6];
                            r[1] = temp;
                        }
                        else if($5[6] instanceof Array)
                        {
                            r[0] = 'ARREGLO';
                            r[6] = $5[6];
                            r[1] = temp;
                        }
                    }

                    r[2] = label3;
                    r[3] = valor;
                    r[4] = '';
                    r[5] = '';
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]} de tipo booleano`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion`+'\"}');
            $$ = ['','','',''];
        }
    }
;

CondicionTernariaExprNoIn
    : LogicaOOExprNoIn
    {
        $$ = $1;
    }
    | LogicaOOExprNoIn '?' AssignmentExprNoIn ':' AssignmentExprNoIn
    {
        if($1[0] != 'STRING')
        {
            if($1[0]!= '' )
            {
                var valor = '';
                var r = [];
                valor += $1[3]+'\n';
                valor += $3[3]+'\n';
                valor += $5[3]+'\n';


                var temp = Temp.getTemporal();
                var label0 = Label.getBandera();
                var label1 = Label.getBandera();
                var label2 = Label.getBandera();
                var label3 = Label.getBandera();

                valor += label0 + ':\n';
                valor += '\t if('+$1[1]+'==1) goto '+label1+';\n';
                valor += '\t goto '+label2+';\n';
                valor += label1 + ':\n';
                valor += '\t'+temp+'='+$3[1]+';\n';
                valor += '\t goto '+label3+';\n';
                valor += label2 + ':\n';
                valor += '\t'+temp+'='+$5[1]+';\n';
                valor += '\t goto '+label3+';\n';
                valor += label3 + ':\n';


                if($1[6] == true)
                {
                    if(typeof $3[6] == "string")
                    {
                        r[0] = 'STRING';
                        r[6] = $3[6];
                        r[1] = $3[1];
                    }
                    else if(typeof $3[6] == "number")
                    {
                        r[0] = 'NUMBER';
                        r[6] = Number($3[6]);
                        r[1] = temp;
                    }
                    else if(typeof $3[6] == "boolean")
                    {
                        r[0] = 'BOOLEAN';
                        r[6] = $3[6];
                        r[1] = temp;
                    }
                    else if($3[6] instanceof Array)
                    {
                        r[0] = 'ARREGLO';
                        r[6] = $3[6];
                        r[1] = temp;
                    }
                }
                else
                {
                    if(typeof $5[6] == "string")
                    {
                        r[0] = 'STRING';
                        r[6] = $5[6];
                        r[1] = $5[1];
                    }
                    else if(typeof $5[6] == "number")
                    {
                        r[0] = 'NUMBER';
                        r[6] = Number($5[6]);
                        r[1] = temp;
                    }
                    else if(typeof $5[6] == "boolean")
                    {
                        r[0] = 'BOOLEAN';
                        r[6] = $5[6];
                        r[1] = temp;
                    }
                    else if($5[6] instanceof Array)
                    {
                        r[0] = 'ARREGLO';
                        r[6] = $5[6];
                        r[1] = temp;
                    }
                }


                r[2] = label3;
                r[3] = valor;
                r[4] = '';
                r[5] = '';
                $$ = r;
            }
            else if($1[0] == '')
            {
                var n = tab.getPositionAmbito($1[4]);
                if(n!=null && n.tipo.toUpperCase() == 'BOOLEAN')
                {

                    var valor = '';
                    var r = [];
                    var tempant = Temp.getTemporal();
                    var tempant1 = Temp.getTemporal();

                    valor += tempant +'='+n.position+';\n';
                    if(n.entorno == 'global')
                    {
                        valor += tempant1 +'=heap[(int)'+tempant+'];\n';
                    }
                    else
                    {
                        valor += tempant1 +'=stack[(int)'+tempant+'];\n';
                    }

                    valor += $3[3]+'\n';
                    valor += $5[3]+'\n';

                    var temp = Temp.getTemporal();
                    var label0 = Label.getBandera();
                    var label1 = Label.getBandera();
                    var label2 = Label.getBandera();
                    var label3 = Label.getBandera();

                    valor += label0 + ':\n';
                    valor += '\t if('+tempant1+'==1) goto '+label1+';\n';
                    valor += '\t goto '+label2+';\n';
                    valor += label1 + ':\n';
                    valor += '\t'+temp+'='+$3[1]+';\n';
                    valor += '\t goto '+label3+';\n';
                    valor += label2 + ':\n';
                    valor += '\t'+temp+'='+$5[1]+';\n';
                    valor += '\t goto '+label3+';\n';
                    valor += label3 + ':\n';


                    if($1[6] == true)
                    {
                        if(typeof $3[6] == "string")
                        {
                            r[0] = 'STRING';
                            r[6] = $3[6];
                            r[1] = $3[1];
                        }
                        else if(typeof $3[6] == "number")
                        {
                            r[0] = 'NUMBER';
                            r[6] = Number($3[6]);
                            r[1] = temp;
                        }
                        else if(typeof $3[6] == "boolean")
                        {
                            r[0] = 'BOOLEAN';
                            r[6] = $3[6];
                            r[1] = temp;
                        }
                        else if($3[6] instanceof Array)
                        {
                            r[0] = 'ARREGLO';
                            r[6] = $3[6];
                            r[1] = temp;
                        }
                    }
                    else
                    {
                        if(typeof $5[6] == "string")
                        {
                            r[0] = 'STRING';
                            r[6] = $5[6];
                            r[1] = $5[1];
                        }
                        else if(typeof $5[6] == "number")
                        {
                            r[0] = 'NUMBER';
                            r[6] = Number($5[6]);
                            r[1] = temp;
                        }
                        else if(typeof $5[6] == "boolean")
                        {
                            r[0] = 'BOOLEAN';
                            r[6] = $5[6];
                            r[1] = temp;
                        }
                        else if($5[6] instanceof Array)
                        {
                            r[0] = 'ARREGLO';
                            r[6] = $5[6];
                            r[1] = temp;
                        }
                    }

                    r[2] = label3;
                    r[3] = valor;
                    r[4] = '';
                    r[5] = '';
                    $$ = r;
                }
                else
                {
                    semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no existe la variable: ${$1[4]} de tipo booleano`+'\"}');
                    $$ = ['','','',''];
                }
            }
            else
            {
                semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion`+'\"}');
                $$ = ['','','',''];
            }
        }
        else
        {
            semanticos.push('{\"valor\":\"'+`Error semantico en la linea ${(yylineno+1)}, no se puede ejecutar la operacion`+'\"}');
            $$ = ['','','',''];
        }
    }
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

