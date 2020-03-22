package stx;

#if !stx_core
typedef PosDef                  = stx.core.type.PosDef;
typedef Pos                     = PosDef;

typedef CoupleDef<Ti,Tii>       = stx.core.type.CoupleDef<Ti,Tii>;
typedef Couple<Ti,Tii>          = stx.core.pack.Couple<Ti,Tii>;

typedef ResDef<T,E>             = OutcomeSum<T,Err<E>>;
typedef Res<T,E>                = stx.core.pack.Res<T,E>;

typedef Err<E>                  = stx.core.pack.Err<E>;
typedef Failure<T>              = stx.core.pack.Failure<T>;
typedef FailCode                = stx.core.pack.FailCode;
typedef Fault                   = stx.core.pack.Fault;

typedef VBlockDef<T>            = Void -> Void;
typedef VBlock<T>               = stx.core.pack.VBlock<T>;

typedef YDef<P, R>              = Recursive<P -> R>; 
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
