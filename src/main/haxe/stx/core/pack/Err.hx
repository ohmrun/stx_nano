package stx.core.pack;

class Err<T>{
  static public var UUID(default,never):String = "e30e1389-4a72-41fe-ba9f-d7ddf3d1e247";

  public var uuid(get,null) : String;
  private function get_uuid(){
    return UUID;
  }
  public function new(data,prev,?pos){
    this.data = data;
    this.prev = prev;
    this.pos  = pos;   
  }
  public var prev(default,null)             : Option<Err<T>>;
  public var data(default,null)             : Option<Failure<T>>;
  public var pos(default,null)              : Pos;

  public function map<U>(fn:T->U):Err<U>{
    var next_data = this.data.map(
      function (t:Failure<T>) : Failure<U> {
        return switch(t){
          case ERR_OF(t)          : ERR_OF(fn(t));
          case ERR(spec)          : ERR(spec);
        }
      }
    );
    var next_prev : Option<Err<U>> = switch(this.prev){
      case Some(err)  : Some(err.map(fn));
      case null       : None;
      default         : None;
    };
    return new Err(
      next_data,
      next_prev,
      this.pos
    );
  }
  public function copy(?data:Option<Failure<T>>,?prev:Option<Err<T>>,?pos:Pos):Err<T>{
    return new Err(
      __.option(data).defv(this.data),
      __.option(prev).defv(this.prev),
      __.option(pos).defv(this.pos)
    );
  }
  public function next(that:Err<T>):Err<T>{
    var last  = that.copy();
    var stack : Array<Err<T>> = [];
    while(last.prev.is_defined()){
      stack.push(last.prev.fudge());
      last = last.prev.fudge();
    }
    var next = Lambda.fold(stack,
      (next:Err<T>,memo:Err<T>) -> next.copy(null,
        memo),
      this
    );
    return next;
  }
  
  public function head():Option<T>{
    return switch(this.data){
      case Some(ERR_OF(v))  : Some(v);
      default               : None;
    }
  }
}
