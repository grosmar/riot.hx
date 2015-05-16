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


  macro public static function build():Array<Field> {

      var fields = Context.getBuildFields();

      var tagName:String = "";
      var templateFile = "";
      var template = "";


      var cls1 = Context.getLocalClass().toString();
      var cls = Context.getLocalClass().get();



      var meta = cls.meta.get().toMap();
      if (meta.exists(':tagName')) {
        tagName = meta.get(':tagName')[0][0].toString();
      }


    var template = getTemplateFromAnnotation(meta,':templateFile');
    var cssFile  = getTemplateFromAnnotation(meta,':cssFile');

      var binds = fields.filter(function(field) {
          return field.meta.toMap().exists(':bind');
      }).map(function(field) {
        var name = field.name;
        return macro  {
            untyped view.$name=$i{name};
        };
      });


      var init = (macro class Temp {

        var view:Dynamic;

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
                  riot.mount('*');

              }

          };
        }

       public inline function bind_view(v) {
           untyped { view = v; };
            $b{binds};
       }


      }).fields;


      fields.push(init[1]);
      fields.push(init[2]);

      return fields;
  }
}
