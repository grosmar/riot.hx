import riot.Riot;
import Component;
import CompomentInheritance;
using riot.RiotTools;


class MyTag extends riot.externs.Tag {

  var msg:String;

  public static var template:String = '<p onclick="{ bye }">{msg}</p>';

  public function new(el) {
    super({ tmpl: template }, { root: el });
    //super({tmpl:template},{root:el});
    trace(this);
    msg = "hello";
  }

  function bye(e) {
    msg = 'goodbye';
  }

}


class Test {

  public static function main() {
    js.Browser.document.getElementById('viewport-component').riot_mount('component-inheritance-2');
    new MyTag(js.Browser.document.getElementById('test')).mount();
  }

}
