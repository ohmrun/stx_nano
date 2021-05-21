package stx.nano;

typedef TripleDef<Ti,Tii,Tiii>   =  (Ti -> Tii -> Tiii -> Void) -> Void;

@:using(stx.nano.Triple.TripleLift)
@:callable abstract Triple<Ti,Tii,Tiii>(TripleDef<Ti,Tii, Tiii>) from TripleDef<Ti,Tii, Tiii> to TripleDef<Ti,Tii, Tiii>{
  static public var _(default,never) = TripleLift;
  public function toString(){
    return TripleLift.toString(this);
  }
}
class TripleLift{
  static public function map<Ti,Tii,Tiii,TT>(self: TripleDef<Ti,Tii,Tiii>,fn:Tiii->TT): Triple<Ti,Tii,TT>{
    return (tp:Ti->Tii->TT->Void) -> self(
      (tI,tII,tIII) -> tp(tI,tII,fn(tIII))
    );
  }
  static public function fst<Ti,Tii,Tiii>(self : TripleDef<Ti,Tii,Tiii>) : Ti{
    return detriple(self,(tI,_,_) -> tI);
  }
  static public function snd<Ti,Tii,Tiii>(self : TripleDef<Ti,Tii,Tiii>) : Tii{
    return detriple(self,(_,tII,_) -> tII);
  }
  static public function thd<Ti,Tii,Tiii>(self : TripleDef<Ti,Tii,Tiii>) : Tiii{
    return detriple(self,(_,_,tIII) -> tIII);
  }
  static public function equals<Ti,Tii,Tiii>(lhs : TripleDef<Ti,Tii,Tiii>,rhs : Triple<Ti,Tii,Tiii>) : Bool{
    return detriple(lhs,
      (t0I, t0II, t0III) -> detriple(rhs,(t1I,t1II,t1III) -> 
        (t0I == t1I) && (t0II == t1II) && (t0III == t1III)
    ));
  }
  static public function reduce<Ti,Tii,Tiii,TT>(self: TripleDef<Ti,Tii,Tiii>,f_a:Ti->TT,f_b:Tii->TT,f_c:Tiii->TT,plus:TT->TT->TT):TT{
    return detriple(self,(tI,tII,tIII) -> plus(plus(f_a(tI),f_b(tII)),f_c(tIII)));
  }
  static public function detriple<Ti,Tii,Tiii,Tiv>(self:TripleDef<Ti,Tii,Tiii>,fn:Ti->Tii->Tiii->Tiv):Tiv{
    var out = null;
    self(
      (tI,tII,tIII) -> {
        out = fn(tI,tII,tIII);
      }
    );
    return out;
  }
  static public function tup<Ti,Tii, Tiii>(self:TripleDef<Ti,Tii,Tiii>):Tup3<Ti,Tii,Tiii>{
    return detriple(self,tuple3);
  }
  static public function toString<Ti,Tii, Tiii>(self:TripleDef<Ti,Tii,Tiii>):String{
    return detriple(self,
      (a,b,c) -> '($a $b $c)'
    );
  }
}