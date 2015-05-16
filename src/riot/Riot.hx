package riot;


class Riot {

    @:extern
    public static inline function injectCss(css:String) {
          var style = js.Browser.document.createStyleElement();
          style.innerHTML = css;
          js.Browser.document.head.appendChild(style);
    }

    @:extern
    public inline static function mount(selector:Dynamic,?opts:Dynamic = null):Array<Dynamic> {
      return untyped riot.mount(selector,opts);
    }

    @:extern
    public inline static function mount2(selector:Dynamic,?tagName2:String = '*',?opts:Dynamic = null):Array<Dynamic> {
      return untyped riot.mount(selector,tagName2,opts);
    }

}
