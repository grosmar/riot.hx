package riot;
import sys.io.File;
import haxe.macro.Context;
import haxe.macro.Expr;
using Lambda;
using tink.macro.Metadatas;
using tink.MacroApi;
using StringTools;
using RiotBuilder.Helper;

class Helper {
  public inline static function cleanupTemplate(template:String )
    return template.replace("'","").replace('\\"','"').replace("\\n","").replace("\\r","");

}


class RiotBuilder {


  inline static function loadFileAsString(path:String) {
     try {
         var p = haxe.macro.Context.resolvePath(path);
         return sys.io.File.getContent(p);
     }
     catch(e:Dynamic) {
         throw 'error load file $path';
         return haxe.macro.Context.error('Failed to load file $path: $e', Context.currentPos());
     }
  }


  inline static function getTemplateFromAnnotation(meta:Map<String, Array<Array<Expr>>>,annotationFile:String,annotationInline:String):String {

    if (meta.exists(annotationFile)) {
      var filePaths = [ for (mt in meta.get(annotationFile)) mt[0].toString().replace("'","").cleanupTemplate() ];
      return [for (filePath in filePaths) loadFileAsString(filePath)].join("");
    }

    if (meta.exists(annotationInline)) {
      var content = meta.get(annotationInline)[0][0].toString().cleanupTemplate();
      return  content;
    }
    return "";
  }

  inline static inline function getAnnotation(name) {
    var meta = Context.getLocalClass().get().meta.get().toMap();
    if (meta.exists(name)) {
      return meta.get(name);
    } else {
      return null;
    }
  }

  inline static function bindFields(fields:Array<Field>) {
    return [
      for (field in fields) {
        if (field.meta.toMap().exists(':bind')) {
          var name = field.name;
          macro untyped view.$name=$i{name};
        }
      }
    ];
  }

  inline static function getBindsSuperClass() {

    if (haxe.macro.Context.getLocalClass().get().superClass != null ) {

      var fields_inheritance = [];

      var super_class = haxe.macro.Context.getLocalClass().get().superClass;
      while(super_class != null) {
        var fields = super_class.t.get().fields.get();
        for (field in fields) fields_inheritance.push(field);
        super_class = super_class.t.get().superClass;
      }

      return [
        for (field in fields_inheritance) {
          if (field.meta.get().toMap().exists(':bind')) {
            var name = field.name;
            macro untyped view.$name=$i{name};
          }
        }
      ];
    } else {
      return [];
    }
  }

  macro public static function build():Array<Field> {

    var fields = Context.getBuildFields();


    var tagName:String = null;
    var templateFile = "";
    var template = "";
    var autoMount = false;

    var cls1 = Context.getLocalClass().toString();
    var cls = Context.getLocalClass().get();
    var meta = cls.meta.get().toMap();

    if (getAnnotation(':tagName') != null) {
      tagName = getAnnotation(':tagName')[0][0].toString();
    }

    if (tagName == null) return null;

    if (getAnnotation(':autoMount') != null) {
      autoMount = true;
    }

    var exprAutoMount = macro null;
    if (autoMount == true ) {
      exprAutoMount = macro untyped {
        setTimeout(function() {
          riot.mount($i{tagName});
        },0);
      }
    }

    var template = getTemplateFromAnnotation(meta,':templateFile',':template');
    var cssFile  = getTemplateFromAnnotation(meta,':cssFile',':css');
    var binds = bindFields(fields).concat(getBindsSuperClass());

    var init = (macro class Temp {

      static function __init__() {
        untyped {

            var tagName = $i{tagName};

            if (tagName != "") {

                var template = $v{template};
                riot.Riot.injectCss($v{cssFile});

                riot.tag(tagName,template,function(opts) {
                    var cls = $p{cls1.split('.')}; //__js__("$hxClasses[{0}]",$v{cls1});
                    var self = __js__('this');
                    var instance =  __js__('new cls(self,opts)');
                });
                $e{exprAutoMount};
            }

        };
      }

     public inline function bind_view(v) {
         untyped { view = v; };
          $b{binds};
     }

    }).fields;

    for (fld in init) {
      fields.push(fld);
    }

    return fields;
  }
}
