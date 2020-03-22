package stx.core.pack;

import stx.core.pack.couple.Constructor;

@:using(stx.core.pack.couple.Implementation)
@:callable abstract Couple<Ti,Tii>(CoupleDef<Ti,Tii>) from CoupleDef<Ti,Tii> to CoupleDef<Ti,Tii>{
  static public inline function _() return Constructor.ZERO;
  
}