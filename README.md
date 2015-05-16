# riot.hx
haxe wrapper around Riot.js

in you code

haxe component
```
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
```
your template riot
```
  <button onclick={incr}>incr</button>
  <span class="counter">{counter}</span>
```

your template css injected during the definition of component
```
  .counter {
    background:red;
    color:yellow;
  }
```

in your html page
```
<html>
  <head>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/riot/2.0.15/riot.min.js"></script>

  </head>
  <body>
    <counter></counter>
    <script src="test.js"></script>
  </body>
</html>
```
