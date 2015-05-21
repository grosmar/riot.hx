package riot;
import js.html.Element;

class RiotTools {
  
  public static inline function riot_mount(element:Element,?tagName:String = '*',?opts:Dynamic = null):Array<Dynamic>{
    return untyped riot.Riot.mount2(element,tagName,opts);
  }

  public static inline function update(component:riot.IRiotComponent,?value:Dynamic) {
    untyped component.view.update(value);
  }

  public static inline function on(component:riot.IRiotComponent,event:String,cb:Dynamic) {
    untyped component.on(event,cb);
  }

  public static inline function root(component:riot.IRiotComponent) {
    return untyped component.root;
  }

}
