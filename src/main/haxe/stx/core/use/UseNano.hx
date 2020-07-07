package stx.core.use;

class UseNano{
  static public function if_else<R>(b:Bool,_if:Void->R,_else:Void->R):R{
    return b ? _if() : _else();
  }
  static public function here(wildcard:Wildcard,?pos:Pos):Pos{
    return pos;
  }
  static public function test(wildcard:Wildcard,arr:Iterable<haxe.unit.TestCase>){
    var runner = new haxe.unit.TestRunner();
    for(t in arr){
      runner.add(t);
    }
    runner.run();
  }    
  /**
		Returns a unique identifier, each `x` replaced with a hex character.
	**/
  static public function uuid(v:Wildcard, value : String = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx') : String {
    var reg = ~/[xy]/g;
    return reg.map(value, function(reg) {
        var r = std.Std.int(Math.random() * 16) | 0;
        var v = reg.matched(0) == 'x' ? r : (r & 0x3 | 0x8);
        return StringTools.hex(v);
    }).toLowerCase();
  }
  /**
    Best guess at platform filesystem seperator string
  **/
  static public function sep(_:Wildcard):String{
    #if sys
      var out = new haxe.io.Path(Sys.getCwd()).backslash ? "\\" : "/";
    #else
      var out = "/";
    #end
    return out;
  }
  static public function option<T>(wildcard:Wildcard,v:T):Option<T>{
    return switch(v){
      case null : None;
      default   : Some(v);
    }
  }
  static public function success<T,E>(wildcard:Wildcard,t:T):Res<T,E>{
    return Res.success(t);
  }
  static public function failure<T,E>(wildcard:Wildcard,e:Err<E>):Res<T,E>{
    return Res.failure(e);
  }
  static public function fault(wildcard:Wildcard,?pos:Pos):Fault{
    return new Fault(pos);
  }
  static public function couple<Ti,Tii>(wildcard:Wildcard,tI:Ti,tII:Tii):Couple<Ti,Tii>{
    return (fn:Ti->Tii->Void) -> {
      fn(tI,tII);
    }
  }
  static public function decouple<Ti,Tii,Tiii>(wildcard:Wildcard,fn:Ti->Tii->Tiii):Couple<Ti,Tii> -> Tiii{
    return (tp:Couple<Ti,Tii>) -> {
      tp.decouple(fn);
    }
  }
  static public function toCouple<Ti,Tii>(self:CoupleDef<Ti,Tii>):Couple<Ti,Tii>{
    return self;
  }

  /**
    make Some(Couple<L,R>) if Option<L> is defined;
  **/
  static public function lbump<L,R>(wildcard:Wildcard,tp:Couple<Option<L>,R>):Option<Couple<L,R>>{
    return tp.decouple(
      (lhs,rhs) -> lhs.fold(
        (l) -> Some(__.couple(l,rhs)),
        ()  -> None
      )
    );
  }
  /**
    make Some(Couple<L,R>) if Option<R> is defined;
  **/
  static public function rbump<L,R>(wildcard:Wildcard,tp:Couple<L,Option<R>>):Option<Couple<L,R>>{
    return tp.decouple(
      (lhs,rhs) -> rhs.fold(
        r   -> (Some(__.couple(lhs,r))),
        ()  -> None
      )
    );
  }
  @:noUsing static public function fromPos(pos:Pos):Position{
    return Position.fromPos(pos);
  }
  #if tink_core
  static public function future<T>(wildcard:Wildcard):Couple<tink.core.Future.FutureTrigger<T>,tink.core.Future<T>>{
    var trigger = tink.core.Future.trigger();
    var future  = trigger.asFuture();
    return __.couple(trigger,future);
  }
  #end
  static public function tracer<T>(v:Wildcard,?pos:Pos):T->T{
    return function(t:T):T{
      trace(t,pos);
      return t;
    }
  }
  static public function traced<T>(v:Wildcard,?pos:Pos):T->Void{
    #if !macro
      var infos :haxe.PosInfos = pos;
    #else
      var infos = null;
    #end
    return function(d:T):Void{
      haxe.Log.trace(d,infos);
    }
  }
  static public function through<T>(__:Wildcard):T->T{
    return (v:T) -> v;
  }
  static public function command<T>(__:Wildcard,fn:T->Void):T->T{
    return (v:T) -> {
      fn(v);
      return v;
    }
  }
  static public function perform<T>(__:Wildcard,fn:Void->Void):T->T{
    return (v:T) -> {
      fn();
      return v;
    }
  }
  static public function execute<T,E>(__:Wildcard,fn:Void->Option<Err<E>>):T->Res<T,E>{
    return (v:T) -> switch(fn()){
      case Some(e)  : __.failure(e);
      default       : __.success(v);
    }
  }
  static public function left<Ti,Tii>(__:Wildcard,tI:Ti):Either<Ti,Tii>{
    return Left(tI);
  }
  static public function right<Ti,Tii>(__:Wildcard,tII:Tii):Either<Ti,Tii>{
    return Right(tII);
  }
  #if tink_core
  static public function fudge<T>(future:tink.core.Future<T>):Option<T>{
    var result    = None;
    var cancelled = false;
    future.handle(
      (x) -> {
        cancelled = true;
        result    = Some(x);
      }
    );
    return result;
  }
  #end
  static public inline function crack<E>(wildcard:Wildcard,e:E){
    throw e;
  }
  static public inline function report<E>(wildcard:Wildcard,report:Report<E>):Void{
    report.crunch();
  }
  static public function definition<T>(wildcard:Wildcard,t:T):Class<T>{
    return std.Type.getClass(t);
  }
  static public function vblock<T>(wildcard:Wildcard,t:T):VBlock<T>{
    return ()->{};
  }
  static public function noop<T>(wildcard:Wildcard):T->T{
    return (t:T) -> (t:T);
  }
  static public function nullify<T>(wildcard:Wildcard):T->Void{
    return (function(t:T){

  });
  }
}