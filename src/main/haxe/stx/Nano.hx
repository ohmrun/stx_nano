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

typedef CoupleDef<Ti,Tii>       = stx.core.pack.Couple.CoupleDef<Ti,Tii>;
typedef CoupleCat<Ti,Tii>       = stx.core.pack.Couple.CoupleCat<Ti,Tii>;
typedef Couple<Ti,Tii>          = stx.core.pack.Couple<Ti,Tii>;

typedef ResSum<T,E>             = OutcomeSum<T,Err<E>>;
typedef Res<T,E>                = stx.core.pack.Res<T,E>;

typedef Err<E>                  = stx.core.pack.Err<E>;
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
#else
  
#end
