package stx;

//@back2dos haxetink
typedef PosDef = 
  #if macro
    haxe.macro.Expr.Position;
  #else
    haxe.PosInfos;
  #end



typedef Pos                     = PosDef;

enum Tup2<L,R>{
  tuple2(l:L,r:R);
}
enum Tup3<Ti,Tii,Tiii>{
  tuple3(tI:Ti,tII:Tii,tIII:Tiii);
}
typedef StdType                 = std.Type;

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

typedef Wildcard                = stx.nano.Wildcard;

typedef Report<E>               = stx.nano.Report<E>;
typedef Position                = stx.nano.Position;
typedef PrimitiveDef            = stx.nano.Primitive.PrimitiveDef;
typedef Primitive               = stx.nano.Primitive;

typedef SlotCls<T>              = stx.nano.Slot.SlotCls<T>;
typedef Slot<T>                 = stx.nano.Slot<T>;

typedef Unique<T>               = stx.nano.Unique<T>;
typedef KV<K,V>                 = stx.nano.KV<K,V>;
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
typedef IdentDef                = stx.nano.IdentDef;

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