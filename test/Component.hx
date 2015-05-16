@:tagName('counter')
@:templateFile('test/templates/counter/counter.html')
@:cssFile('test/templates/counter/counter.css')
@:keep
class Component implements riot.IRiotComponent {
  public var view:Dynamic;


  @:bind function incr() {
    view.counter++;
  }

  public function new(v,opts) {
    bind_view(v);
    view.counter = 0;
	}

}
