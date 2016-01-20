package riot.externs;

@:native('riot.Tag')
extern class Tag {
  public function new(?impl:Impl,?conf:Conf,?innerHTML:String) {}
  public function mount():Void {}
}
