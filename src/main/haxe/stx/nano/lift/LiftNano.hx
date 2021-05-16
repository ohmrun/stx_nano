package stx.nano.lift;

import stx.alias.StdType;

class LiftNano{
  static public function nano(wildcard:Wildcard):Module{
    return new stx.nano.Module();
  }
  /**
    shortcut for creating a variadic array: `Array<Dynamic>`
  **/
  static public function arrd(wildcard:Wildcard,arr:Array<Dynamic>):Array<Dynamic>{
    return arr;
  }
  /**
    Useful for all sorts, 
    ```haxe
    (true).if_else(
      () -> {},//if true
      () -> {}//if false
    );
    ```
  **/
  static public function if_else<R>(b:Bool,_if:Void->R,_else:Void->R):R{
    return b ? _if() : _else();
  }
  /**
    Returns the posititon in the code at the site of it's use. 
  **/
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
  /**
    Most used wildcard, creates an option, often used like: `__.option(value).defv(fallback)`
  **/
  static public function option<T>(wildcard:Wildcard,v:T):Option<T>{
    return switch(v){
      case null : None;
      default   : Some(v);
    }
  }
  /**
    
  **/
  static public function accept<T,E>(wildcard:Wildcard,t:T):Res<T,E>{
    return Res.accept(t);
  }
  static public function reject<T,E>(wildcard:Wildcard,e:Err<E>):Res<T,E>{
    return Res.reject(e);
  }
  static public function success<T,E>(wildcard:Wildcard,t:T):Outcome<T,E>{
    return Outcome.success(t);
  }
  static public function failure<T,E>(wildcard:Wildcard,e:E):Outcome<T,E>{
    return Outcome.failure(e);
  }
  
  static public function fault(wildcard:Wildcard,?pos:Pos):Fault{
    return new Fault(pos);
  }
  static public function couple<Ti,Tii>(wildcard:Wildcard,tI:Ti,tII:Tii):Couple<Ti,Tii>{
    return (fn:Ti->Tii->Void) -> {
      fn(tI,tII);
    }
  }
  static public function pair<Ti,Tii>(wildcard:Wildcard,tI:Ti,tII:Tii):Pair<Ti,Tii>{
    return new tink.core.Pair(tI,tII);
  }
  static public function decouple<Ti,Tii,Tiii>(wildcard:Wildcard,fn:Ti->Tii->Tiii):Couple<Ti,Tii> -> Tiii{
    return (tp:Couple<Ti,Tii>) -> {
      tp.decouple(fn);
    }
  }
  static public function triple<Ti,Tii,Tiii>(wildcard:Wildcard,tI:Ti,tII:Tii,tIII:Tiii):Triple<Ti,Tii,Tiii>{
    return (fn:Ti->Tii->Tiii->Void) -> {
      fn(tI,tII,tIII);
    }
  }
  static public function detriple<Ti,Tii,Tiii,Tiv>(wildcard:Wildcard,fn:Ti->Tii->Tiii->Tiv):Triple<Ti,Tii,Tiii> -> Tiv{
    return (tp:Triple<Ti,Tii,Tiii>) -> {
      tp.detriple(fn);
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
  static public inline function tracer<T>(v:Wildcard,?pos:haxe.PosInfos):T->T{
    return function(t:T):T{
      haxe.Log.trace(t,pos);
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
      case Some(e)  : __.reject(e);
      default       : __.accept(v);
    }
  }
  static public function left<Ti,Tii>(__:Wildcard,tI:Ti):Either<Ti,Tii>{
    return Left(tI);
  }
  static public function right<Ti,Tii>(__:Wildcard,tII:Tii):Either<Ti,Tii>{
    return Right(tII);
  }
  static public function either<T>(either:Either<T,T>):T{
    return either.fold(
      l -> l,
      r -> r 
    );
  }
  #if tink_core
  static public function value<T>(future:tink.core.Future<T>):Option<T>{
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
  static public inline function report<E>(wildcard:Wildcard,?e:Failure<E>,?pos:Pos):Report<E>{
    return e == null ? Report.unit() : Report.make0(e,pos);
  }
  // static public inline function pos<P,R>(fn:Binary<P,Null<Pos>,R>,?pos:Pos):Unary<P,R>{
  //   return fn.bind(_,pos);
  // }
  static public function definition<T>(wildcard:Wildcard,t:T):Class<T>{
    return std.Type.getClass(t);
  }
  static public function identifier<T>(self:Class<T>):Identifier{
    return new Identifier(StdType.getClassName(self));
  }
  static public function locals<T>(self:Class<T>){
    return StdType.getInstanceFields(self);
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
  static public function passthrough<T>(wildcard:Wildcard,fn:T->Void):T->T{
    return (function(t:T):T{
      fn(t);
      return t;
    });
  }
  static public function not(bool:Bool){
    return !bool;
  } 
  static public function toPosition(pos:Pos):Position{
    return Position.lift(pos);
  }
  static public function chunk<T>(_:Wildcard,v:Null<T>):Chunk<T,Dynamic>{
    return switch(v){
      case null : Tap;
      default   : Val(v);
    }
  }
  static public function ident(wildcard:Wildcard,str:String):Identifier{
    return new Identifier(str);
  }
  static public function toIdentifier(pos:Pos):Identifier{
    return Identifier.lift(Position.lift(pos).className);
  }
  static public function toAlert<E>(ft:Future<Report<E>>):Alert<E>{
    return Alert.lift(ft);
  }
  static public function toString(pos:Pos):String{
    var id = toIdentifier(pos);
    var fn = pos.toPosition().methodName;
    return '${id}.${fn}';
  }
}