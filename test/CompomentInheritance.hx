using riot.RiotTools;

@:keep
class BaseComponent implements riot.IRiotComponent  {
  public var view:Dynamic;

  @:bind function incr() {
    js.Lib.debug();
    view.counter++;
  }

  @:bind function async_incr() {
    haxe.Timer.delay(function() {
      view.counter++;
      update();
    },2000);
  }

  function mount() {
    trace('component mounted on $view.root');
    untyped console.log(view.root);
  }

}


@:tagName('component_inheritance')
@:templateFile('test/templates/counter/counter.html')
@:cssFile('test/templates/counter/counter.css')
@:autoMount
@:keep
class CompomentInheritance extends BaseComponent  {


  public function new(v,opts) {

    bind_view(v);
    view.counter = 0;
    view.on('mount',mount);
  }

}
