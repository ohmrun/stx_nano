package stx.nano;

typedef CoupleDef<Ti,Tii> = (Ti -> Tii -> Void) -> Void;
typedef CoupleCat<Ti,Tii> = Array<Either<Ti,Tii>>;//[Left(tI),Right(tII)]

/**
 * ```haxe    
 * using stx.Nano;
 * function test_couple(){
 *  final cp = __.couple(1,2);
 *  final val = __.decouple(
 *    (l,r) -> l + r
 *  );
 * }
 * ```
 */
@:using(stx.nano.Couple.CoupleLift)
@:callable abstract Couple<Ti,Tii>(CoupleDef<Ti,Tii>) from CoupleDef<Ti,Tii> to CoupleDef<Ti,Tii>{
  static public var _(default,never) = CoupleLift;
  @:noUsing static public function make<Ti,Tii>(lhs:Ti,rhs:Tii):Couple<Ti,Tii>{
    return (cb) -> cb(lhs,rhs);
  }
  #if thx_core
    public function fromThxTuple<Pi,Pii>(tup:ThxTuple<Pi,Pii>):Couple<Pi,Pii>{
      return (cb) -> cb(tup._0,tup._1);
    }

    public function toThxTuple<Pi,Pii>(tup:Couple<Pi,Pii>):ThxTuple<Pi,Pii>{
      return new ThxTuple(fst(tup),snd(tup));
    }
  #end
  public function toString(){
    return CoupleLift.toString(this);
  }
}
class CoupleLift{
  static public function map<Ti,Tii,TT>(self: Couple<Ti,Tii>,fn:Tii->TT): Couple<Ti,TT>{
    return (tp:Ti->TT->Void) -> self(
      (ti,tii) -> tp(ti,fn(tii))
    );
  }
  static public function mapl<Ti,Tii,TT>(self: Couple<Ti,Tii>,fn:Ti->TT):Couple<TT,Tii>{
    return (tp) -> self(
      (ti,tii) -> tp(fn(ti),tii)
    );
  }
  static public function mapr<Ti,Tii,TT>(self: Couple<Ti,Tii>,fn:Tii->TT):Couple<Ti,TT>{
    return map(self,fn);
  }
  static public function fst<Ti, Tii>(self : Couple<Ti, Tii>) : Ti{
    return decouple(self,(tI,_) -> tI);
  }
  static public function snd<Ti, Tii>(self : Couple<Ti, Tii>) : Tii{
    return decouple(self,(_,tII) -> tII);
  }
  static public function swap<Ti, Tii>(self : Couple<Ti, Tii>) : Couple<Tii, Ti>{
    return (tp) -> self((ti,tii) -> tp(tii,ti));
  }
  static public function equals<Ti, Tii>(lhs : Couple<Ti, Tii>,rhs : Couple<Ti, Tii>) : Bool{
    return decouple(lhs,
      (t0l, t0r) -> decouple(rhs,(t1l, t1r) -> 
        (t0l == t1l) && (t0r == t1r)
    ));
  }
  static public function reduce<Ti,Tii,TT>(self: Couple<Ti,Tii>,flhs:Ti->TT,frhs:Tii->TT,plus:TT->TT->TT):TT{
    return decouple(self,(tI,tII) -> plus(flhs(tI),frhs(tII)));
  }
  static public function decouple<Ti,Tii,Tiii>(self:Couple<Ti,Tii>,fn:Ti->Tii->Tiii):Tiii{
    var out = null;
    self(
      (ti,tii) -> {
        out = fn(ti,tii);
      }
    );
    return out;
  }
  static public function cat<Ti,Tii>(self:Couple<Ti,Tii>):Cluster<Either<Ti,Tii>>{
    return decouple(self,(l,r) -> [Left(l),Right(r)]);
  }
  static public function tup<Ti,Tii>(self:Couple<Ti,Tii>):Tup2<Ti,Tii>{
    return decouple(self,tuple2);
  }
  static public function toString<Ti,Tii>(self:Couple<Ti,Tii>):String{
    return decouple(self,
      (l,r) -> '($l $r)'
    );
  }
}