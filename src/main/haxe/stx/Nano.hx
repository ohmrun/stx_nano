
package stx;

#if !stx_core
//hat-tip @back2dos haxetink
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
typedef CoupleDef<Ti,Tii>       = stx.core.pack.Couple.CoupleDef<Ti,Tii>;
typedef CoupleCat<Ti,Tii>       = stx.core.pack.Couple.CoupleCat<Ti,Tii>;
typedef Couple<Ti,Tii>          = stx.core.pack.Couple<Ti,Tii>;

typedef TripleDef<Ti,Tii,Tiii>  = stx.core.pack.Triple.TripleDef<Ti,Tii,Tiii>;
typedef Triple<Ti,Tii,Tiii>     = stx.core.pack.Triple<Ti,Tii,Tiii>;

typedef ResSum<T,E>             = stx.core.pack.Res.ResSum<T,E>;
typedef Res<T,E>                = stx.core.pack.Res<T,E>;

typedef Err<E>                  = stx.core.pack.Err<E>;
typedef FailureSum<T>           = stx.core.pack.Failure.FailureSum<T>;
typedef Failure<T>              = stx.core.pack.Failure<T>;
typedef FailCode                = stx.core.pack.FailCode;
typedef Fault                   = stx.core.pack.Fault;

typedef VBlockDef<T>            = stx.core.pack.VBlock.VBlockDef<T>;
typedef VBlock<T>               = stx.core.pack.VBlock<T>;

typedef YDef<P, R>              = stx.core.pack.Y.YDef<P,R>;
typedef Y<P, R>                 = stx.core.pack.Y<P,R>;

typedef RecursiveDef<P>         = RecursiveDef<P> -> P; 
typedef Recursive<P>            = RecursiveDef<P>;

typedef UseOptionNano           = stx.core.use.UseOptionNano;
typedef UseArrayNano            = stx.core.use.UseArrayNano;
typedef UseNano                 = stx.core.use.UseNano;
typedef Wildcard                = stx.core.pack.Wildcard;

typedef Report<E>               = stx.core.pack.Report<E>;
typedef Position                = stx.core.pack.Position;
typedef PrimitiveDef            = stx.core.pack.Primitive.PrimitiveDef;
typedef Primitive               = stx.core.pack.Primitive;

//typedef SlotDef<T>              = stx.core.pack.Slot.SlotDef<T>;
typedef Slot<T>                 = stx.core.pack.Slot<T>;

typedef Unique<T>               = stx.core.pack.Unique<T>;

#else
  
#end

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