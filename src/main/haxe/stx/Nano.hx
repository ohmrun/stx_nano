package stx;

class Nano{
  static public var _(default,never) = LiftNano;
}
//@back2dos haxetink
@:pure typedef PosDef = 
  #if macro
    haxe.macro.Expr.Position;
  #else
    haxe.PosInfos;
  #end


typedef Dyn                     = Dynamic;
typedef Pos                     = PosDef;

@:using(stx.Nano.Tup2Lift)
enum Tup2<L,R>{
  tuple2(l:L,r:R);
}
class Tup2Lift{
  static public inline function cat<L,R,Z>(self:Tup2<L,R>,fn:L->R->Z):Z{
    return switch(self){
      case tuple2(l,r) : fn(l,r);
    }
  }
  static public inline function fst<L,R>(self:Tup2<L,R>):L{
    return cat(self,(l,_) -> l);
  }
  static public inline function snd<L,R>(self:Tup2<L,R>):R{
    return cat(self,(_,r) -> r);
  }
}
enum Tup3<Ti,Tii,Tiii>{
  tuple3(tI:Ti,tII:Tii,tIII:Tiii);
}
typedef StdType                 = std.Type;
typedef StdMath                 = std.Math;

typedef CoupleDef<Ti,Tii>       = stx.nano.Couple.CoupleDef<Ti,Tii>;
typedef CoupleCat<Ti,Tii>       = stx.nano.Couple.CoupleCat<Ti,Tii>;
typedef Couple<Ti,Tii>          = stx.nano.Couple<Ti,Tii>;
typedef Twin<T>                 = Couple<T,T>;

typedef TripleDef<Ti,Tii,Tiii>  = stx.nano.Triple.TripleDef<Ti,Tii,Tiii>;
typedef Triple<Ti,Tii,Tiii>     = stx.nano.Triple<Ti,Tii,Tiii>;

typedef ResSum<T,E>             = stx.nano.Res.ResSum<T,E>;
typedef Res<T,E>                = stx.nano.Res<T,E>;

typedef Err<E>                  = stx.nano.Err<E>;
typedef FailureSum<T>           = stx.nano.Failure.FailureSum<T>;
typedef Failure<T>              = stx.nano.Failure<T>;
typedef FailCode                = stx.nano.FailCode;
typedef Fault                   = stx.nano.Fault;

typedef VBlockDef<T>            = stx.nano.VBlock.VBlockDef<T>;
typedef VBlock<T>               = stx.nano.VBlock<T>;


typedef PledgeDef<T,E>          = stx.nano.Pledge.PledgeDef<T,E>;
typedef Pledge<T,E>             = stx.nano.Pledge<T,E>;

/*
typedef YDef<P, R>              = stx.nano.Y.YDef<P,R>;
typedef Y<P, R>                 = stx.nano.Y<P,R>;

typedef RecursiveDef<P>         = RecursiveDef<P> -> P; 
typedef Recursive<P>            = RecursiveDef<P>;
*/

class LiftPos{
  static public function lift(pos:Pos):Position{
    return new Position(pos);
  }
}
typedef LiftFuture              = stx.nano.lift.LiftFuture;
typedef LiftIMapToArrayKV       = stx.nano.lift.LiftIMapToArrayKV;
typedef LiftOptionNano          = stx.nano.lift.LiftOptionNano;
typedef LiftArrayNano           = stx.nano.lift.LiftArrayNano;
typedef LiftNano                = stx.nano.lift.LiftNano;
typedef LiftErrToChunk          = stx.nano.lift.LiftErrToChunk;
typedef LiftResToChunk          = stx.nano.lift.LiftResToChunk;
typedef LiftOptionToChunk       = stx.nano.lift.LiftOptionToChunk;
typedef LiftTinkOutcomeToChunk  = stx.nano.lift.LiftTinkOutcomeToChunk;
typedef LiftIterableToIter      = stx.nano.lift.LiftIterableToIter;
typedef LiftArrayToIter         = stx.nano.lift.LiftArrayToIter;
typedef LiftIteratorToIter      = stx.nano.lift.LiftIteratorToIter;
typedef LiftMapToIter           = stx.nano.lift.LiftMapToIter;
typedef LiftStringMapToIter     = stx.nano.lift.LiftStringMapToIter;
typedef LiftJsPromiseToContract = stx.nano.lift.LiftJsPromiseToContract;
typedef LiftContractToJsPromise = stx.nano.lift.LiftContractToJsPromise;
typedef LiftJsPromiseToPledge   = stx.nano.lift.LiftJsPromiseToPledge;
typedef LiftFutureResToPledge   = stx.nano.lift.LiftFutureResToPledge;

class LiftArrayClassWithUnderscore{
  static public function graft(clazz:Class<Array<Dynamic>>){
    return stx.lift.ArrayLift;
  }
}
typedef LiftPath                = stx.nano.lift.LiftPath;

typedef Wildcard                = stx.nano.Wildcard;

typedef ReportSum<E>            = stx.nano.ReportSum<E>;
typedef Report<E>               = stx.nano.Report<E>;
typedef Position                = stx.nano.Position;
typedef PrimitiveDef            = stx.nano.Primitive.PrimitiveDef;
typedef Primitive               = stx.nano.Primitive;

typedef SlotCls<T>              = stx.nano.Slot.SlotCls<T>;
typedef Slot<T>                 = stx.nano.Slot<T>;

typedef Unique<T>               = stx.nano.Unique<T>;
typedef KV<K,V>                 = stx.nano.KV<K,V>;
typedef KVDef<K,V>              = stx.nano.KV.KVDef<K,V>;
typedef Iter<T>                 = stx.nano.Iter<T>;

typedef StringableDef           = stx.nano.Stringable.StringableDef;
typedef Stringable              = stx.nano.Stringable;

typedef Defect<E>               = stx.nano.Defect<E>;
typedef Scuttle                 = Defect<tink.core.Noise>;
typedef Reaction<T>             = Outcome<T,Scuttle>;

typedef Resource                = stx.nano.Resource;
typedef LiftStringToResource    = stx.nano.lift.LiftStringToResource;
typedef Embed<T>                = stx.nano.Embed<T>;

typedef ChunkSum<T,E>           = stx.nano.Chunk.ChunkSum<T,E>;
typedef Chunk<T,E>              = stx.nano.Chunk<T,E>;

typedef ContractDef<T,E>        = stx.nano.Contract.ContractDef<T,E>;
typedef Contract<T,E>           = stx.nano.Contract<T,E>;

typedef EnumValue               = stx.nano.EnumValue;
typedef Blob                    = stx.nano.Blob;
typedef Field<T>                = stx.nano.Field<T>;

typedef OneOrManySum<T>         = stx.nano.OneOrMany.OneOrManySum<T>;
typedef OneOrMany<T>            = stx.nano.OneOrMany<T>;
typedef CompilerTarget          = stx.nano.CompilerTarget;
typedef Enum<T>                 = stx.nano.Enum<T>;
typedef Introspectable          = stx.nano.Introspectable;
typedef AlertDef<E>             = stx.nano.Alert.AlertDef<E>;
typedef Alert<E>                = stx.nano.Alert<E>;
typedef Signal<T>               = stx.nano.Signal<T>;
//typedef Stream<T,E>             = stx.nano.Stream<T,E>;


typedef Char                    = stx.nano.Char;
typedef Chars                   = stx.nano.Chars;
typedef Ints                    = stx.nano.Ints;
typedef Floats                  = stx.nano.Floats;
typedef Math                    = stx.nano.Math;
typedef Bools                   = stx.nano.Bools;
typedef TimeStamp               = stx.nano.TimeStamp;
typedef TimeStampDef            = stx.nano.TimeStamp.TimeStampDef;
typedef LogicalClock            = stx.nano.LogicalClock;
typedef Cluster<T>              = stx.nano.Cluster<T>;
typedef Catalog<T>              = stx.nano.Catalog<T>;
typedef Unfold<T,R>             = stx.nano.Unfold<T,R>;

typedef LiftOutcomeTDefect      = stx.nano.lift.LiftOutcomeTDefect;

class LiftFutureToSlot{
  static public inline function toSlot<T>(ft:tink.core.Future<T>,?pos:Pos):Slot<T>{
    return Slot.Guard(ft,pos);
  }
}
class LiftLazyFutureToSlot{
  static public inline function toSlot<T>(fn:Void -> tink.core.Future<T>):Slot<T>{
    return Slot.Guard(fn());
  }
}
// class LiftStringableToString{
//   static public function toString(str:Stringable):String{
//     //trace("STRINGABLE");
//     return str.toString();
//   }
// }
// class LiftTToString{
//   static public function toString<T>(self:T):String{
//     //trace("ANYTHING");
//     return Std.string(self);
//   }
// }

abstract FPath(Chars){
  static public function lift(self:Chars) return new FPath(self);
  public function new(self) this = self;
  @:noUsing static public function pure(str:Chars):FPath{
    return new FPath(str);
  }
  public function into(str:String):FPath{
    return lift(Nano._.if_else(
      has_end_slash(),
      () -> '$this$str',
      () -> '$this/$str'
    ));
  }
  public function trim_end_slash(){
    return Nano._.if_else(
      has_end_slash(),
      () -> lift(this.rdropn(1)),
      () -> lift(this)
    );
  }
  public function has_end_slash(){
    return StringTools.endsWith(this,'/');   
  }
  public function is_absolute(){
    return StringTools.startsWith(this,'/');
  }
  @:noUsing static public function fromString(str:String):FPath{
    return lift(str);
  }
  public function toString(){
    return this;
  }
  public function toArray(){
    var splut = this.split('/');
    if(is_absolute()){
      splut.shift();
    }
    if(has_end_slash()){
      splut.pop();
    }
    return splut;
  }
  public function head(){
    return toArray().head();
  }
  public function prj(){
    return this;
  }
}
typedef Unspecified = stx.nano.Unspecified;
typedef Timer       = stx.nano.Timer;