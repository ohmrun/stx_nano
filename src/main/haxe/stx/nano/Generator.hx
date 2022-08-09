package stx.nano;

/**
  An iterable based on values accumulated on a stack by calling a function.
  When the function returns None, the iteration is considered complete.

  Each successive value is pushed onto a stack.
**/
@:allow(stx.Generator) class Generator<T>{
  @:noUsing public static function pure(fn){
    return make(fn,[]);
  }
  @:noUsing public static function make(fn,stack){
    return new Generator(fn,stack);
  }
  public function new(f:Void -> Option<T>,stack:Array<Option<T>>){
    this.fn       =
      function(i:Int){
        var o =
          if (stack[i] == null){
             stack[i] = f();
          }else{
            stack[i];
          }
        return o;
      };
    this.index    = 0;
  }
  private var fn    : Int->Option<T>;
  private var index : Int;

  public function restart():Generator<T>{
    var next = new Generator(null,null);
        next.fn = this.fn;
    return next;
  }
  public function next():T{

    var o = switch(fn(index)){
      case None     : null;
      case Some(v)  : v;
    };
    index++;
    return o;
  }
  public function hasNext():Bool{
    var o = switch (fn(index)) {
      case Some(_)  : true;
      case None     : false;
    }
    return o;
  }
  public function iterator():Iterator<T>{
    return
    {
      next      : next,
      hasNext   : hasNext
    }
  }
  /**
		Creates an Iterable by calling fn until it returns None, caching the results.
	**/
  public function toIter():Iter<T>{
    var stack = [];
    return Iter.lift({
      iterator : function() return this.iterator()
    });
  }
}
