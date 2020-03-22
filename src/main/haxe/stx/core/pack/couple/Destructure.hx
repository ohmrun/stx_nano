package stx.core.pack.couple;

class Destructure extends Clazz{
  public function map<Ti,Tii,TT>(fn:Tii->TT,self: Couple<Ti,Tii>): Couple<Ti,TT>{
    return (tp:Ti->TT->Void) -> self(
      (ti,tii) -> tp(ti,fn(tii))
    );
  }
  public function decouple<Ti,Tii,TT>(fn:Ti->Tii->TT,self: Couple<Ti,Tii>):TT{
    var out = null;
    self(
      (ti,tii) -> {
        out = fn(ti,tii);
      }
    );
    return out;
  }
  public function lmap<Ti,Tii,TT>(fn:Ti->TT,self:Couple<Ti,Tii>):Couple<TT,Tii>{
    return (tp) -> self(
      (ti,tii) -> tp(fn(ti),tii)
    );
  }
  public function rmap<Ti,Tii,TT>(fn:Tii->TT,self: Couple<Ti,Tii>):Couple<Ti,TT>{
    return map(fn,self);
  }
  public function fst<Ti, Tii>(self : Couple<Ti, Tii>) : Ti {
    return decouple(
      (tI,_) -> tI,
      self
    );
  }
  public function snd<Ti, Tii>(self : Couple<Ti, Tii>) : Tii {
    return decouple(
      (_,tII) -> tII,
      self
    );
  }
  public function swap<Ti, Tii>(self : Couple<Ti, Tii>) : Couple<Tii, Ti> {
    return (tp) -> self(
      (ti,tii) -> tp(tii,ti)
    );
  }
  public function equals<Ti, Tii>(rhs : Couple<Ti, Tii>,lhs : Couple<Ti, Tii>) : Bool {
    var ok = false;
    lhs(
      (t0l, t0r) -> rhs((t1l, t1r) -> {
        ok = (t0l == t1l) && (t0r == t1r);
      }
    ));
    return ok;
  }
  public function reduce<Ti,Tii,TT>(flhs:Ti->TT,frhs:Tii->TT,plus:TT->TT->TT,self: Couple<Ti,Tii>):TT{
    var out = null;
    self(
      (tI,tII) -> {
        out = plus(flhs(tI),frhs(tII));
      }
    );
    return out;
  }
  public function cat<Ti,Tii>(self:Couple<Ti,Tii>):{ a : Ti, b : Tii }{
    return decouple(
      (l,r) -> { a : l , b : r }  
    ,self);
  }
}