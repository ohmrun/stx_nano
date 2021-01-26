package stx.nano;

typedef EmbedDef<T> = {
  public function pack(v:T):Void->Void;
  public function unpack(fn:Void->Void):Option<T>;
  public function pull(fn:Void->Void):T;
  public function check(fn:Void->Void):Bool;
}

@:forward abstract Embed<T>(EmbedDef<T>) from EmbedDef<T>{
  public function new(){
    this = Constructor.embed();
  }
}
private class Constructor extends Clazz{
  /*
    You can pass around the Block that comes from pack without annotation, and wherever you have the reference
    to the Embedding, you can unpack it in a typed way, *only if* you have the correct reference.
  */
  static public function embed<T>():EmbedDef<T>{
    var r  : Option<T> = haxe.ds.Option.None;
    //had to prefedine this for runtime issue.
    var unpack : (Void -> Void) -> Option<T> = null;
        unpack = function(fn){
          r = None;
          fn();//If the function was created by *this* Embedding, it should fill r with the value.
          return r;
        }
    var pull : (Void->Void) -> T = null;
        pull = function(fn){
          r = None;
          fn();
          return r.fudge();
        }
    var pack  : T -> (Void -> Void) = null;
        pack = function(v:T){
          var o = Some(v);
          return function(){
            //Use the scope introduced by the embed function to assign a variable.
            r = o;
          }
        } 
    var check : (Void->Void) -> Bool = null;
        check = function(fn){
          // If the value is Some(_), then we've got the right reference.
          return switch(unpack(fn)){
            case Some(_)   : true;
            case None      : false;
          }
        }
    return {
      pack    : pack ,
      unpack  : unpack,
      pull    : pull,
      check   : check,
    }
  }
}