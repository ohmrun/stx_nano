package stx.nano;

class Err<T>{
  
  static public final UUID:String = "e30e1389-4a72-41fe-ba9f-d7ddf3d1e247";

  public var uuid(get,never) : String;
  private function get_uuid(){
    return UUID;
  }
  public function new(data:Option<Failure<T>>,?prev:Option<Err<T>>,?pos:Pos){
    this.data = data;
    this.prev = __.option(prev).defv(None);
    this.pos  = __.option(pos);   
  }
  public final prev             : Option<Err<T>>;
  public final data             : Option<Failure<T>>;
  public final pos              : Option<Pos>;

  public inline function errate<U>(fn:T->U):Err<U> return map(fn);
  
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
      this.pos.defv(null)
    );
  }
  // public function app<U>(fn:Failure<T>->Failure<U>):Err<U>{
  //   return new Err(this.data.map(fn),this.prev,this.pos);
  // }
  public function copy(?data:Option<Failure<T>>,?prev:Option<Err<T>>,?pos:Option<Pos>):Err<T>{
    return new Err(
      __.option(data).defv(this.data),
      __.option(prev).defv(this.prev),
      __.option(pos.defv(null)).defv(this.pos.defv(null))
    );
  }
  public function last():Err<T>{
    var self = this;
    while(self.prev != None){
      switch(self.prev){
        case Some(last) : self = last;
        default: break;
      }
    }
    return self;
  }
  @:deprecated public function next(that:Err<T>):Err<T>{
    return merge(that);
  }   
  public function merge(that:Err<T>):Err<T>{
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
  
  public function fault():Fault{
    return Fault.lift(this.pos.defv(null));
  }
  public function toString(){
    var p  = Std.string(pos.map(x -> Position.lift(x).toStringClassMethodLine()));
    var e  = Std.string(this.data);
    return '$e at ($p)';
  }
  public function iterator(){
    var cursor = Some(this);

    return {
      hasNext : () -> cursor.is_defined(),
      next    : () -> {
        var value = cursor.fudge();
        cursor = value.prev;
        return value;
      }
    }
  }
  #if tink_core
  @:noUsing static public function fromTinkError<E>(err:tink.core.Error):Err<E>{
    return new Err(ERR(FailCode.fromString(err.message)),null,err.pos);
  }
  #end
  public function value():Option<T>{
    return this.data.flat_map(
      (f) -> f.fold(
        Some,
        (_) -> None
      )
    );
  }
  public function elide():Err<Dynamic>{
    return this.map(
      (v:T) -> (v:Dynamic)
    );
  }
  @:noUsing static public function grow<E>(arr:Cluster<E>,?pos:Pos):Err<E>{
    return arr.tail().lfold(
      (next:E,memo:Err<E>) -> new Err(__.option(ERR_OF(next)),Some(memo),pos),
      new Err(arr.head().map(ERR_OF),None,pos)
    );
  }
  public function report():Report<T>{
    return Report.pure(this);
  }
  public function alert():Alert<T>{
    return report().alert();
  }
  public function toTinkError(code=500):tink.core.Error{
    return tink.core.Error.withData(code, 'TINK_ERROR', this.data, this.pos.defv(null));
  }
}
