package riot.externs;
import js.html.Element;

@:native('riot.Tag')
extern class Tag {
  
	var isMounted:Bool;
	var parent:Tag;
	var root:Element;
	var tags:Map<String,Dynamic>;
	
	function new(?impl:Impl, ?conf:Conf, ?innerHTML:String);
	function mount():Void;
  
	function getInstance():Dynamic;
}
