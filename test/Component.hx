using riot.RiotTools;

@:tagName('counter')
@:templateFile('test/templates/counter/counter.html')
@:cssFile('test/templates/counter/counter.css')
@:autoMount
@:keep
class Component implements riot.IRiotComponent {
  public var view:Dynamic;


  @:bind function incr() {
    view.counter++;
  }

  @:bind function async_incr() {
    haxe.Timer.delay(function() {
      view.counter++;
      update();
    },2000);
  }

  function mount() {
    trace('component mounted on $root()');
    untyped console.log(root());
  }

  public function new(v,opts) {
    bind_view(v);
    view.counter = 0;
    view.on('mount',mount);
  }

}
