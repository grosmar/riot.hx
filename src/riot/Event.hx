package riot;
import js.html.Element;


typedef Event<T> = {
  currentTarget:Element,
  target:Element,
  item:T,
  which:String
}
