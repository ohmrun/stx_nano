package stx.core.type;

//hat-tip @back2dos haxetink
typedef PosDef = 
  #if macro
    haxe.macro.Expr.Position;
  #else
    haxe.PosInfos;
  #end
