package riot;
import js.html.Element;

class RiotTools {


  public static inline function riot_mount(element:Element,?tagName:String = '*',?opts:Dynamic = null):Array<Dynamic>{
    return untyped lib.Riot.mount2(element,tagName,opts);
  }

}
