package stx.core.pack.couple;

class Implementation{
  static public inline function _() return Constructor.ZERO._;

  static public function map<Ti,Tii,TT>(self: Couple<Ti,Tii>,fn:Tii->TT): Couple<Ti,TT>                       return _().map(fn,self);
  static public function lmap<Ti,Tii,TT>(self: Couple<Ti,Tii>,fn:Ti->TT):Couple<TT,Tii>                       return _().lmap(fn,self);
  static public function rmap<Ti,Tii,TT>(self: Couple<Ti,Tii>,fn:Tii->TT):Couple<Ti,TT>                       return _().rmap(fn,self);
  static public function fst<Ti, Tii>(self : Couple<Ti, Tii>) : Ti                                            return _().fst(self);
  static public function snd<Ti, Tii>(self : Couple<Ti, Tii>) : Tii                                           return _().snd(self);
  static public function swap<Ti, Tii>(self : Couple<Ti, Tii>) : Couple<Tii, Ti>                              return _().swap(self);
  static public function equals<Ti, Tii>(lhs : Couple<Ti, Tii>,rhs : Couple<Ti, Tii>) : Bool                  return _().equals(rhs,lhs);
  static public function reduce<Ti,Tii,TT>(self: Couple<Ti,Tii>,flhs:Ti->TT,frhs:Tii->TT,plus:TT->TT->TT):TT  return _().reduce(flhs,frhs,plus,self);
 
  static public function decouple<Ti,Tii,Tiii>(self:Couple<Ti,Tii>,fn:Ti->Tii->Tiii):Tiii                     return _().decouple(fn,self);
  static public function cat<Ti,Tii>(self:Couple<Ti,Tii>):{ a : Ti, b : Tii }                                 return _().cat(self);
}