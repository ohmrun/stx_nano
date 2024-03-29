package stx;

#if (sys || nodejs)
import sys.FileSystem;
import sys.io.File;
#end

using stx.Pico;

class Nano{
  static public function digests(wildcard:Wildcard):Digests{
    return wildcard;
  } 
  static public function stx<T>(wildcard:Wildcard):STX<T>{
    return STX;
  }
  static public var _(default,never) = LiftNano;
  
}
class Maps{
  static public function map_into<K,Vi,Vii>(self:Map<K,Vi>,fn:Vi -> Vii,memo:Map<K,Vii>):Map<K,Vii>{
    for(k => v in self){
      memo.set(k,fn(v));
    }
    return memo;
  }
}
class PicoNano{
  // static public function Option(pico:Pico):Stx<stx.pico.Option.Tag>{
  //   return __.stx();
  // }
}
class LiftArrayToCluster{
  static public inline function toCluster<T>(self:Array<T>):Cluster<T>{
    return Cluster.lift(self);
  }
  /**
    Cluster is an immutable Array.
  **/
  static public inline function imm<T>(self:Array<T>):Cluster<T>{
    return toCluster(self);
  }
}
typedef Dyn                     = Dynamic;

@:using(stx.Nano.Tup2Lift)
enum Tup2<L,R>{
  tuple2(l:L,r:R);
}
class Tup2Lift{
  /**
   * create a function from `fn` that can be applied to a value of `Tup<L,R>`
   * @param self 
   * @return R
   */
  static public inline function detuple<L,R,Z>(self:Tup2<L,R>,fn:L->R->Z):Z{
    return switch(self){
        case tuple2(l,r) : fn(l,r);
    }
  }
  /**
   * consume value by applying `fn` on it.
   * @param self 
   * @param fn 
   * @return Tup2<L,RR>
   */
  static public inline function reduce<L,R,Z>(self:Tup2<L,R>,fn:L->R->Z):Z{
    return switch(self){
      case tuple2(l,r) : fn(l,r);
    }
  }
  /**
   * produce left hand value
   * @param self 
   * @param fn 
   * @return Tup2<L,RR>
   */
  static public inline function fst<L,R>(self:Tup2<L,R>):L{
    return reduce(self,(l,_) -> l);
  }
  /**
   * produce right hand value
   * @param self 
   * @param fn 
   * @return Tup2<L,RR>
   */
  static public inline function snd<L,R>(self:Tup2<L,R>):R{
    return reduce(self,(_,r) -> r);
  }
  /**
   * apply `fn` to `fst`
   * @param self 
   * @param fn 
   * @return Tup2<L,RR>
   */
  static public inline function mapl<L,LL,R>(self:Tup2<L,R>,fn:L->LL):Tup2<LL,R>{
    return reduce(self,(l,r) -> tuple2(fn(l),r));
  }
  /**
   * apply `fn` to `snd`
   * @param self 
   * @param fn 
   * @return Tup2<L,RR>
   */
  static public inline function mapr<L,R,RR>(self:Tup2<L,R>,fn:R->RR):Tup2<L,RR>{
    return reduce(self,(l,r) -> tuple2(l,fn(r)));
  }
  static public inline function toKV<L,R>(self:Tup2<L,R>):KV<L,R>{
    return reduce(self,KV.make);
  }
}
enum Tup3<Ti,Tii,Tiii>{
  tuple3(tI:Ti,tII:Tii,tIII:Tiii);
}

typedef StdMath                 = std.Math;

typedef CoupleDef<Ti,Tii>       = stx.nano.Couple.CoupleDef<Ti,Tii>;
typedef CoupleCat<Ti,Tii>       = stx.nano.Couple.CoupleCat<Ti,Tii>;
typedef Couple<Ti,Tii>          = stx.nano.Couple<Ti,Tii>;
typedef Twin<T>                 = Couple<T,T>;

typedef TripleDef<Ti,Tii,Tiii>  = stx.nano.Triple.TripleDef<Ti,Tii,Tiii>;
typedef Triple<Ti,Tii,Tiii>     = stx.nano.Triple<Ti,Tii,Tiii>;

typedef UpshotSum<T,E>          = stx.nano.Upshot.UpshotSum<T,E>;
typedef Upshot<T,E>             = stx.nano.Upshot<T,E>;

// typedef DeclineSum<T>       = stx.nano.Decline.DeclineSum<T>;
//typedef Decline<T>          = stx.nano.Decline<T>;

typedef Digests                 = stx.nano.Digests;

typedef Fault                   = stx.nano.Fault;

typedef VBlockDef<T>            = stx.nano.VBlock.VBlockDef<T>;
typedef VBlock<T>               = stx.nano.VBlock<T>;


typedef PledgeDef<T,E>          = stx.nano.Pledge.PledgeDef<T,E>;
typedef Pledge<T,E>             = stx.nano.Pledge<T,E>;

//typedef Refuse<E>            = stx.nano.Refuse<E>;
//typedef RefuseDef<E>         = stx.nano.Refuse.RefuseDef<E>;

typedef ByteSize                = stx.nano.ByteSize;
typedef Endianness              = stx.nano.Endianness;
/*
typedef YDef<P, R>              = stx.nano.Y.YDef<P,R>;
typedef Y<P, R>                 = stx.nano.Y<P,R>;

typedef RecursiveDef<P>         = RecursiveDef<P> -> P; 
typedef Recursive<P>            = RecursiveDef<P>;
*/

class LiftPos{
  @:noUsing static public function lift(pos:Pos):Position{
    return new Position(pos);
  }
}
typedef LiftErrorStringToRefuse     = stx.nano.lift.LiftErrorStringToRefuse;
typedef LiftTinkErrorToRefuse       = stx.nano.lift.LiftTinkErrorToRefuse;
typedef LiftRefuseToUpshot             = stx.nano.lift.LiftRefuseToRes;
typedef LiftErrorToReport           = stx.nano.lift.LiftErrorToReport;
typedef LiftErrorToAlert            = stx.nano.lift.LiftErrorToAlert;
typedef LiftErrorToRefuse           = stx.nano.lift.LiftErrorToRefuse;
typedef LiftFuture                  = stx.nano.lift.LiftFuture;
typedef LiftIMapToArrayKV           = stx.nano.lift.LiftIMapToArrayKV;
typedef LiftOptionNano              = stx.nano.lift.LiftOptionNano;
typedef LiftArrayNano               = stx.nano.lift.LiftArrayNano;
typedef LiftNano                    = stx.nano.lift.LiftNano;
typedef LiftErrToChunk              = stx.nano.lift.LiftErrToChunk;
typedef LiftResToChunk              = stx.nano.lift.LiftResToChunk;
typedef LiftOptionToChunk           = stx.nano.lift.LiftOptionToChunk;
typedef LiftTinkOutcomeToChunk      = stx.nano.lift.LiftTinkOutcomeToChunk;
typedef LiftIterableToIter          = stx.nano.lift.LiftIterableToIter;
typedef LiftArrayToIter             = stx.nano.lift.LiftArrayToIter;
typedef LiftIteratorToIter          = stx.nano.lift.LiftIteratorToIter;
typedef LiftMapToIter               = stx.nano.lift.LiftMapToIter;
typedef LiftMapToIterKV             = stx.nano.lift.LiftMapToIterKV;
typedef LiftStringMapToIter         = stx.nano.lift.LiftStringMapToIter;
typedef LiftStringMapToIterKV       = stx.nano.lift.LiftStringMapToIterKV;
typedef LiftJsPromiseToContract     = stx.nano.lift.LiftJsPromiseToContract;
typedef LiftContractToJsPromise     = stx.nano.lift.LiftContractToJsPromise;
typedef LiftJsPromiseToPledge       = stx.nano.lift.LiftJsPromiseToPledge;
typedef LiftFutureResToPledge       = stx.nano.lift.LiftFutureResToPledge;
typedef LiftError                   = stx.nano.lift.LiftError;
typedef LiftErrorDigestToRefuse  = stx.nano.lift.LiftErrorDigestToRefuse;
typedef LiftBytes                   = stx.nano.lift.LiftBytes;

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
typedef PrimitiveSum            = stx.nano.Primitive.PrimitiveSum;
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
typedef DefectDef<E>            = stx.nano.Defect.DefectDef<E>;
typedef DefectApi<E>            = stx.nano.Defect.DefectApi<E>;
typedef DefectCls<E>            = stx.nano.Defect.DefectCls<E>;
/**
 * `Defect` type error with no associated information.
 */
typedef Scuttle                 = Defect<Nada>;
typedef Reaction<T>             = Outcome<T,Scuttle>;

typedef Resource                = stx.nano.Resource;
typedef LiftStringToResource    = stx.nano.lift.LiftStringToResource;

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
typedef CompilerTargetSum       = stx.nano.CompilerTarget.CompilerTargetSum;
typedef Enum<T>                 = stx.nano.Enum<T>;
typedef Introspectable          = stx.nano.Introspectable;
typedef AlertDef<E>             = stx.nano.Alert.AlertDef<E>;
typedef Alert<E>                = stx.nano.Alert<E>;
typedef AlertTrigger<E>         = stx.nano.Alert.AlertTrigger<E>;
typedef Signal<T>               = stx.nano.Signal<T>;
//typedef Stream<T,E>             = stx.nano.Stream<T,E>;


typedef Char                    = stx.nano.Char;
typedef Chars                   = stx.nano.Chars;
typedef Ints                    = stx.nano.Ints;
typedef Numeric                 = stx.nano.Numeric;
typedef NumericSum              = stx.nano.Numeric.NumericSum;
typedef SprigSum                = stx.nano.Sprig.SprigSum;
typedef Sprig                   = stx.nano.Sprig;
typedef Floats                  = stx.nano.Floats;
typedef Math                    = stx.nano.Math;
typedef Bools                   = stx.nano.Bools;
typedef TimeStamp               = stx.nano.TimeStamp;
typedef TimeStampDef            = stx.nano.TimeStamp.TimeStampDef;
typedef LogicalClock            = stx.nano.LogicalClock;
typedef Cluster<T>              = stx.nano.Cluster<T>;
typedef ClusterDef<T>           = stx.nano.Cluster.ClusterDef<T>;
typedef Clustered<T>            = stx.nano.Clustered<T>;
typedef Roster<T>             = stx.nano.Roster<T>;
typedef Unfold<T,R>             = stx.nano.Unfold<T,R>;
typedef Counter                 = stx.nano.Counter;
typedef Json                    = stx.nano.Json;
typedef LiftOutcomeTDefect      = stx.nano.lift.LiftOutcomeTDefect;

typedef Receipt<T,E>            = stx.nano.Receipt<T,E>;
typedef ReceiptDef<T,E>         = stx.nano.Receipt.ReceiptDef<T,E>;
typedef ReceiptApi<T,E>         = stx.nano.Receipt.ReceiptApi<T,E>;
typedef ReceiptCls<T,E>         = stx.nano.Receipt.ReceiptCls<T,E>;
typedef Accrual<T,E>            = stx.nano.Accrual<T,E>;
typedef AccrualDef<T,E>         = stx.nano.Accrual.AccrualDef<T,E>;

// typedef ErrataDef<E>            = stx.nano.Errata.ErrataDef<E>;
// typedef Errata<E>               = stx.nano.Errata<E>;
typedef Ledger<I,O,E>           = stx.nano.Ledger<I,O,E>;
typedef LedgerDef<I,O,E>        = stx.nano.Ledger.LedgerDef<I,O,E>;
typedef Equity<I,O,E>           = stx.nano.Equity<I,O,E>;
typedef EquityDef<I,O,E>        = stx.nano.Equity.EquityDef<I,O,E>;
typedef EquityCls<I,O,E>        = stx.nano.Equity.EquityCls<I,O,E>;
typedef EquityApi<I,O,E>        = stx.nano.Equity.EquityApi<I,O,E>;

typedef Coord                   = stx.nano.Coord;
typedef CoordSum                = stx.nano.Coord.CoordSum;

typedef Retry                   = stx.nano.Retry;
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

typedef FPath               = stx.nano.FPath;
typedef Unspecified         = stx.nano.Unspecified;
typedef Timer               = stx.nano.Timer;

typedef CTRDef<P,R>         = stx.nano.CTR.CTRDef<P,R>;
typedef CTR<P,R>            = stx.nano.CTR<P,R>;

typedef APPDef<P,R>         = stx.nano.APP.APPDef<P,R>;
typedef APP<P,R>            = stx.nano.APP<P,R>;

typedef IdentDef            = stx.nano.Ident.IdentDef;
typedef Ident               = stx.nano.Ident;
typedef Way                 = stx.nano.Way;

typedef Ensemble<T>         = stx.nano.Ensemble<T>;
typedef EnsembleDef<T>      = stx.nano.Ensemble.EnsembleDef<T>;

typedef IterKV<K,V>         = stx.nano.IterKV<K,V>;
typedef IterKVDef<K,V>      = stx.nano.IterKV.IterKVDef<K,V>;

typedef Enquire<P>          = stx.nano.Enquire<P>;
typedef EnquireDef<P>       = stx.nano.Enquire.EnquireDef<P>;

typedef Cell<P>             = stx.nano.Cell<P>;
typedef CellDef<P>          = stx.nano.Cell.CellDef<P>;

typedef Trivalent           = stx.nano.Trivalent;
typedef TrivalentSum        = stx.nano.Trivalent.TrivalentSum;

typedef NuggetApi<P>        = stx.nano.Nugget.NuggetApi<P>;
typedef NuggetCls<P>        = stx.nano.Nugget.NuggetCls<P>;
typedef Nugget<P>           = stx.nano.Nugget<P>;

typedef Absorbable<P>       = stx.nano.Nugget.Absorbable<P>;
typedef Producable<P>       = stx.nano.Nugget.Producable<P>;

typedef Register            = stx.nano.Register;
typedef Knuckle             = stx.nano.Knuckle;
typedef KnuckleSum          = stx.nano.Knuckle.KnuckleSum;

typedef Junction<T>         = stx.nano.Junction<T>;
typedef JunctionSum<T>      = stx.nano.Junction.JunctionSum<T>;
typedef JunctionCtr<T>      = stx.nano.Junction.JunctionCtr<T>;

typedef PrimitiveType       = stx.nano.PrimitiveType;
typedef PrimitiveTypeSum    = stx.nano.PrimitiveType.PrimitiveTypeSum;
typedef PrimitiveTypeCtr    = stx.nano.PrimitiveType.PrimitiveTypeCtr;

typedef Record<T>           = stx.nano.Record<T>;
typedef RecordDef<T>        = stx.nano.Record.RecordDef<T>;

typedef Generator<T>        = stx.nano.Generator<T>;

typedef PartialFunction<P,R>      = stx.nano.PartialFunction<P,R>;
typedef PartialFunctionApi<P,R>   = stx.nano.PartialFunction.PartialFunctionApi<P,R>;
typedef PartialFunctionCls<P,R>   = stx.nano.PartialFunction.PartialFunctionCls<P,R>;

typedef PartialFunctions<P,R>     = stx.nano.PartialFunctions<P,R>;
typedef PartialFunctionsDef<P,R>  = stx.nano.PartialFunctions.PartialFunctionsDef<P,R>;

enum abstract UNIMPLEMENTED(String){
  var UNIMPLEMENTED;
}
class LiftEnumValue{
  @:noUsing static public function lift(self:stx.alias.StdEnumValue):EnumValue{
    return stx.nano.EnumValue.lift(self);
  }
}

#if (sys || nodejs)
class SysLift{
  static public function cwd(self:Class<std.Sys>)
    return {
       get : ()           -> std.Sys.getCwd(),
       put : (str:String) -> { std.Sys.setCwd(str); }
    }
  static public function fs(self:Class<std.Sys>) return new Fs();
  static public function dir(self:Class<std.Sys>) return new Dir();

  static public function env(self:Class<std.Sys>,key:String):Option<String>{
    return Option.make(std.Sys.getEnv(key));
  }
}
private class Fs extends Clazz{
  public function exists(str:String):Bool{
    return FileSystem.exists(str);
  }
  public function get(str:String):String{
    return File.getContent(str);
  }
  public inline function set(key:String,val:String):Void{
    File.saveContent(key,val);
  }
}
private class Dir extends Clazz{
  public function put(path:String){
    FileSystem.createDirectory(path);
  }
}
#end