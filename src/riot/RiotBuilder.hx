package riot;
import sys.io.File;
import haxe.macro.Context;
import haxe.macro.Expr;
using Lambda;
using tink.macro.Metadatas;
using tink.MacroApi;
using StringTools;


class RiotBuilder {

  static function getTemplateFromAnnotation(meta:Map<String, Array<Array<Expr>>>,annotation:String):String {

    var filePath = meta.get(annotation)[0][0].toString().replace("'","");
    var absolutePath = Sys.getCwd() + "/" + filePath;
    trace(absolutePath);
    if (sys.FileSystem.exists(filePath) == false) throw 'file not exists';
    return  File.getContent(filePath);
  }

  static inline function getAnnotation(name) {
    var meta = Context.getLocalClass().get().meta.get().toMap();
    if (meta.exists(name)) {
      return meta.get(name);
    } else {
      return null;
    }
  }

  static function bindFields(fields:Array<Field>) {
    return fields.filter(function(field) {
        return field.meta.toMap().exists(':bind');
    }).map(function(field) {
      var name = field.name;
      return macro  {
          untyped view.$name=$i{name};
      };
    });
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
    trace(tagName);
    if (tagName == null) return null;

    if (getAnnotation(':autoMount') != null) {
      autoMount = true;
    }

    var exprAutoMount = macro null;
    if (autoMount == true ) {
      exprAutoMount = macro untyped riot.mount($i{tagName});
    }

    var template = getTemplateFromAnnotation(meta,':templateFile');
    var cssFile  = getTemplateFromAnnotation(meta,':cssFile');


    var binds = bindFields(fields);


    if (haxe.macro.Context.getLocalClass().get().superClass != null ) {
      var fieldsSuperClass = haxe.macro.Context.getLocalClass().get().superClass.t.get().fields.get();
      var bindsSuperClass = fieldsSuperClass.filter(function(f) {
        return f.meta.get().toMap().exists(':bind');
      }).map(function(f) {
        var name = f.name;
        return macro  {
            untyped view.$name=$i{name};
        };
      });
      binds= binds.concat(bindsSuperClass);
    }

    var init = (macro class Temp {

      static function __init__() {
        untyped {

            var tagName = $i{tagName};

            if (tagName != "") {

                var template = $v{template};
                riot.Riot.injectCss($v{cssFile});

                riot.tag(tagName,template,function(opts) {
                    var cls = $i{cls1};
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
