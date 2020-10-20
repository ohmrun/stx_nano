package stx;

#if !stx_core
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

/*
typedef YDef<P, R>              = stx.nano.Y.YDef<P,R>;
typedef Y<P, R>                 = stx.nano.Y<P,R>;

typedef RecursiveDef<P>         = RecursiveDef<P> -> P; 
typedef Recursive<P>            = RecursiveDef<P>;
*/

typedef LiftOptionNano          = stx.nano.lift.LiftOptionNano;
typedef LiftArrayNano           = stx.nano.lift.LiftArrayNano;
typedef LiftNano                = stx.nano.lift.LiftNano;
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
class LiftStringableToString{
  static public function toString(str:Stringable):String{
    //trace("STRINGABLE");
    return str.toString();
  }
}
class LiftTToString{
  static public function toString<T>(self:T):String{
    //trace("ANYTHING");
    return Std.string(self);
  }
}