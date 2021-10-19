package stx.nano;

typedef EquityDef<I,O,E> = ReceiptDef<O,E> & {
  final asset : I;
} 
@:using(stx.nano.Equity.EquityLift)
@:forward abstract Equity<I,O,E>(EquityDef<I,O,E>) from EquityDef<I,O,E> to EquityDef<I,O,E>{
  static public var _(default,never) = EquityLift;
  public function new(self) this = self;
  static public function lift<I,O,E>(self:EquityDef<I,O,E>):Equity<I,O,E> return new Equity(self);

  public function prj():EquityDef<I,O,E> return this;
  private var self(get,never):Equity<I,O,E>;
  private function get_self():Equity<I,O,E> return lift(this);

  @:noUsing static public function make<I,O,E>(asset:I,value:Null<O>,?error:Defect<E>){
    return lift({ asset : asset, value : value, error : Defect.make(error)});
  }
}
class EquityLift extends Clazz{
  static public function make(){
    return new EquityLift();
  }
  static public function lift<I,O,E>(self:EquityDef<I,O,E>):Equity<I,O,E>{
    return Equity.lift(self);
  }
  static public function errate<I,O,E,EE>(self:EquityDef<I,O,E>,fn:E->EE):Equity<I,O,EE>{
    return errata(self,x -> x.map(fn));
  }
  static public function errata<I,O,E,EE>(self:EquityDef<I,O,E>,fn:Defect<E>->Defect<EE>){
    return Equity.make(self.asset,self.value,fn(self.error));
  }
  static public function copy<I,O,E>(self:EquityDef<I,O,E>,asset:I,?value:O,?error:Defect<E>){
    return lift({
      asset : __.option(asset).defv(self.asset),
      value : __.option(value).defv(self.value),
      error : __.option(error).defv(self.error)
    });
  }
  static public function map<I,O,Oi,E>(self:EquityDef<I,O,E>,fn:O->Oi):Equity<I,Oi,E>{
    return Equity.make(
        self.asset,
      __.option(self.value).fold(
        ok -> fn(ok),
        () -> null
      ),
      self.error
    );
  }
  static public function mapi<I,Ii,O,E>(self:EquityDef<I,O,E>,fn:I->Ii):Equity<Ii,O,E>{
    return Equity.make(
      fn(self.asset),
      self.value,
      self.error
    );
  }
  static public function is_defined<I,O,E>(self:EquityDef<I,O,E>){
    return self.value != null;
  }
  static public function has_errors<I,O,E>(self:EquityDef<I,O,E>){
    return self.error.is_defined();
  }
  static public function defect<I,O,E>(self:EquityDef<I,O,E>,error:Defect<E>){
    return copy(self,null,null,self.error.concat(error));
  }
}