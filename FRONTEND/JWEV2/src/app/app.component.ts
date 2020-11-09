import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { faCoffee } from '@fortawesome/free-solid-svg-icons';
import Parser from 'node_modules/wannantraduction/WT';
import * as ParserE from 'node_modules/wannancompile/WE';
import Core from 'node_modules/wannancore/globalCore';
import {formatDate} from '@angular/common';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastService } from './toast-service';
import { NgbCarouselConfig } from '@ng-bootstrap/ng-bootstrap';
import 'codemirror/mode/clike/clike';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})


export class AppComponent implements OnInit{
  title = 'JWEditor';
  images = [700, 533, 807, 124].map((n) => `https://picsum.photos/id/${n}/900/500`);
  constructor(private modalService: NgbModal, public toastService: ToastService,config: NgbCarouselConfig) {
    // customize default values of carousels used by this component tree
    config.interval = 10000;
    config.wrap = false;
    config.keyboard = false;
    config.pauseOnHover = false;
  }
  faCoffee = faCoffee;

  obj: string;
  obj1: string;
  obj2: string;
  EL: number;
  ES: number;
  progreso: number;
  result: string;
  data: string;
  showFiller = false;
  traduce: boolean;
  ejecutar: boolean;
  traduction: any;
  core: any;
  salida: string;
  s: string;
  s1: string;
  simbolos: any[];
  rows1: any;
  duration: any;

  codeMirrorOptions: any = {
    theme: 'lucario',
    mode: 'application/javascript',
    lineNumbers: true,
    lineWrapping: true,
    foldGutter: true,
    gutters: ['CodeMirror-linenumbers', 'CodeMirror-foldgutter', 'CodeMirror-lint-markers'],
    autoCloseBrackets: true,
    matchBrackets: true,
    lint: true
  };
  codeMirrorOptions0: any = {
    theme: 'lucario',
    mode: 'text/x-csrc',
    readOnly: true,
    lineNumbers: true,
    lineWrapping: true,
    foldGutter: true,
    gutters: ['CodeMirror-linenumbers', 'CodeMirror-foldgutter', 'CodeMirror-lint-markers'],
    autoCloseBrackets: true,
    matchBrackets: true,
    lint: true
  };

  codeMirrorOptions1: any = {
    theme: 'lucario',
    mode: 'application/text',
    lineNumbers: true,
    lineWrapping: true,
    readOnly: true,
    foldGutter: true,
    gutters: ['CodeMirror-linenumbers', 'CodeMirror-foldgutter', 'CodeMirror-lint-markers'],
    autoCloseBrackets: false,
    matchBrackets: false,
    smartIndent: false,
    indentWithTabs: false,
    lint: true
  };
  cargadescarga: boolean;
  showTraduction: boolean;
  isMenuCollapsed: boolean;
  private jsonsalida: any;
  rows: string;
  erroresSintacticos: any[];
  erroresLexicos: any[];
  simbolitos: any[];

  ngOnInit() {
    this.obj = 'let a:number = 1989.5 + 0.5 + 8.5;\n' +
      'let b:string =  a + \': hola mundo\';\n' +
      'console.log(b);';
    this.obj1 = '';
    this.obj2 = '';
    this.EL = 0;
    this.ES = 0;
    this.progreso = 0;
    this.traduce = false;
    this.ejecutar = false;
    this.cargadescarga = false;
    this.showTraduction = true;
    this.isMenuCollapsed = true;
    this.rows = '';
    this.rows1 = '';
    this.simbolos = [];
    this.erroresSintacticos = [];
    this.erroresLexicos = [];
    this.simbolitos = [];
  }
  ShowTraduction()
  {
    this.showTraduction = !this.showTraduction;
  }
  setEditorContent(event) {
    this.s = this.obj1;
  }
  setEditorContent1(event) {
    this.s1 = this.obj2;
  }

  openScrollableContent(longContent) {
    this.modalService.open(longContent, { scrollable: true , size: 'xl'});
  }
  openScrollableContent1(longContent) {
    this.modalService.open(longContent, { scrollable: true , size: 'xl'});
  }
  openScrollableContent2(longContent) {
    this.modalService.open(longContent, { scrollable: true , size: 'xl'});
  }
  openScrollableContent3(longContent) {
    this.modalService.open(longContent, { scrollable: true , size: 'xl'});
  }
  openScrollableContent4(longContent) {
    this.modalService.open(longContent, { scrollable: true , size: 'xl'});
  }

  Ejecutar(event, value, dg)
  {
    this.simbolos = [];
    this.erroresLexicos = [];
    this.erroresSintacticos = [];
    this.simbolitos = [];
    let sus = true;
    this.EL = 0;
    this.ES = 0;
    (async () => {
      const start = new Date().getTime();
      this.ejecutar = true;
      this.progreso = 10;
      this.salida = '';
      this.obj1 = '';
      await delay(1000);

      try {
        // tslint:disable-next-line:no-console
        console.time('mytimer');
        this.traduction = ParserE.parse(value.value);
        this.progreso = 50;

        this.EL = this.traduction[1].length;
        this.ES = this.traduction[2].length;
        this.progreso = 25;
        if ( this.EL > 0 || this.ES > 0 )
        {
          sus = false;
          let b = 1;
          // tslint:disable-next-line:no-shadowed-variable
          for (const value of this.traduction[1])
          {
            const values = JSON.parse(value.toString());
            const valor = { no: b.toString(), token: values.token, linea: values.linea, columna: values.columna };
            this.erroresLexicos.push(valor);
            b++;
          }

          b = 1;
          // tslint:disable-next-line:no-shadowed-variable
          for (const value of this.traduction[2])
          {
            const values = JSON.parse(value);
            const valor = { no: b.toString(), token: values.token, linea: values.linea, columna: values.columna };
            this.erroresSintacticos.push(valor);
            b++;
          }
        }
        Core.jsondata = this.traduction[0];
        Core.generate(this.traduction[0]);
        this.core = Core.exec();
        this.progreso = 75;
        this.salida = '';
        for (const values of Core.resultado()) {
          // console.log(values);
          if (values.toString().includes('Error:'))
          {
            sus = false;
            this.salida += '[JoWan1998][' + formatDate(new Date(), 'yyyy/MM/dd  HH:mm:ss', 'en') + '] ' + values + '\n';

          }
          else {
            this.salida += '[JoWan1998][' + formatDate(new Date(), 'yyyy/MM/dd  HH:mm:ss', 'en') + '] ' + values + '\n';

          }
        }
        try {
          this.obj1 = this.salida;
          this.rows1 = Core.tablasimbolos();
          const val = JSON.parse(this.rows1);
          let a = 1;
          this.rows = '';
          for (const values of val.simbolos)
          {
            const valor = { no: a.toString(), name: values.name, ambito: values.ambito, tipo: values.tipo, type: values.type };
            this.simbolos.push(valor);
            a++;
          }
          const nnm = JSON.parse(Core.graphs().toString());
          a = 1;
          for (const values of nnm.simbolos)
          {
            const valor = { no: a.toString(), name: values.name, ambito: values.ambito, tipo: values.tipo, type: values.type };
            this.simbolitos.push(valor);
            a++;
          }
        }
        catch (e) {
        }
        const end = new Date().getTime();
        this.duration = ((end - start) / 1000 );
        // tslint:disable-next-line:no-console
        console.timeEnd('mytimer');
        this.progreso = 100;
      } catch (e) {
        sus = false;
        console.error(e);
        // tslint:disable-next-line:max-line-length
        this.obj1 = '[JoWan1998][' + formatDate(new Date(), 'yyyy/MM/dd  HH:mm:ss', 'en') + '] valor: [Unexpected Error]  Error: ' + e.toString() + '\n';
      }
      await delay(1000);
      console.log(this.duration);
      if ( sus )
      {
        this.showSuccess();
      }
      else {
        this.showDanger(dg);
      }
      this.ejecutar = false;
      this.progreso = 0;
    })();
  }

  Traductor(event, value, dg)
  {
    this.simbolos = [];
    this.erroresLexicos = [];
    this.erroresSintacticos = [];
    this.simbolitos = [];
    let sus = true;
    this.EL = 0;
    this.ES = 0;
    (async () => {
      const start = new Date().getTime();
      this.traduce = true;
      this.progreso = 10;
      this.salida = '';
      this.obj1 = '';
      await delay(1000);
      try {
        // tslint:disable-next-line:no-console
        console.time('mytimer');
        this.progreso = 25;
        this.traduction = Parser.parse(value.value);

        this.obj2 = this.traduction[0];
        this.EL = this.traduction[1].length;
        this.ES = this.traduction[2].length;
        this.progreso = 50;
        if ( this.EL > 0 || this.ES > 0 )
        {
          sus = false;
          let b = 1;
          // tslint:disable-next-line:no-shadowed-variable
          for (const value of this.traduction[1])
          {
            const values = JSON.parse(value.toString());
            const valor = { no: b.toString(), token: values.token, linea: values.linea, columna: values.columna };
            this.erroresLexicos.push(valor);
            b++;
          }

          b = 1;
          // tslint:disable-next-line:no-shadowed-variable
          for (const value of this.traduction[2])
          {
            const values = JSON.parse(value);
            const valor = { no: b.toString(), token: values.token, linea: values.linea, columna: values.columna };
            this.erroresSintacticos.push(valor);
            b++;
          }
        }

        Core.jsondata = this.traduction[0];
        Core.generate(this.traduction[0]);
        this.core = Core.exec();
        this.progreso = 75;
        this.progreso = 75;
        this.salida = '';
        for (const values of Core.resultado()) {
          // console.log(values);
          if (values.toString().includes('Error:'))
          {
            sus = false;
            this.salida += '[JoWan1998][' + formatDate(new Date(), 'yyyy/MM/dd  HH:mm:ss', 'en') + '] ' + values + '\n';

          }
          else {
            this.salida += '[JoWan1998][' + formatDate(new Date(), 'yyyy/MM/dd  HH:mm:ss', 'en') + '] ' + values + '\n';

          }
        }

        try {
          this.obj1 = this.salida;
          this.rows1 = Core.tablasimbolos();
          const val = JSON.parse(this.rows1);
          let a = 1;
          this.rows = '';
          for (const values of val.simbolos)
          {
            const valor = { no: a.toString(), name: values.name, ambito: values.ambito, tipo: values.tipo, type: values.type };
            this.simbolos.push(valor);
            a++;
          }
          const nnm = JSON.parse(Core.graphs().toString());
          a = 1;
          for (const values of nnm.simbolos)
          {
            const valor = { no: a.toString(), name: values.name, ambito: values.ambito, tipo: values.tipo, type: values.type };
            this.simbolitos.push(valor);
            a++;
          }
        }
        catch (e) {
        }

        const end = new Date().getTime();
        this.duration = ((end - start) / 1000 );
        // tslint:disable-next-line:no-console
        console.timeEnd('mytimer');
        this.progreso = 100;
      } catch (e) {
        console.error(e);
        // tslint:disable-next-line:max-line-length
        this.obj1 = '[JoWan1998][' + formatDate(new Date(), 'yyyy/MM/dd  HH:mm:ss', 'en') + '] valor: [Unexpected Error]  Error: ' + e.toString() + '\n';
      }
      console.log(this.duration);
      if ( sus )
      {
        this.showSuccess();
      }
      else {
        this.showDanger(dg);
      }
      await delay(1000);
      this.traduce = false;
      this.progreso = 0;

    })();
  }

  showSuccess() {
    this.toastService.show('Compilation Success,\ntime elapsed: ' + this.duration + 'ms', { classname: 'bg-success text-light', delay: 10000 });
  }

  showDanger(dangerTpl) {
    this.toastService.show(dangerTpl, { classname: 'bg-danger text-light', delay: 15000 });
  }



  setEditorContent2($event) {
    $event.value = this.salida;
  }
}
