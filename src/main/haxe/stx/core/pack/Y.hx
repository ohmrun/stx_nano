package stx.core.pack;

@:callable abstract Y<P,R>(YDef<P,R>) from YDef<P,R> to YDef<P,R>{
  static public function unit<P,R>():Y<P,R>{
    return function(fn:Recursive<P->R>):P->R return fn(fn);
  }
  @:noUsing static public function pure<P,R>(f:P->R):Y<P,R>{
    return function(fn:Recursive<P->R>) return f;
  }
  public function new(self){
    this = self;
  }
  public function reply():P -> R{
    return this(this);
  }
}