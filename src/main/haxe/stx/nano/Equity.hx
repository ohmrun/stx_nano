package stx.nano;

interface EquityApi<I,O,E> extends ReceiptApi<O,E>{
  public final asset : I;
  public function toEquity():EquityDef<I,O,E>;
}
class EquityCls<I,O,E> extends ReceiptCls<O,E> implements EquityApi<I,O,E> {
  public final asset : I;
  public function new(error,value:Null<O>,asset:I){
    super(error,value);
    this.asset = asset;
  }
  public function toEquity():EquityDef<I,O,E>{
    return this;
  }
}
typedef EquityDef<I,O,E> = ReceiptDef<O,E> & {
  final asset : I;
  public function toEquity():EquityDef<I,O,E>;
} 
@:using(stx.nano.Equity.EquityLift)
@:forward abstract Equity<I,O,E>(EquityDef<I,O,E>) from EquityDef<I,O,E> to EquityDef<I,O,E>{
  static public var _(default,never) = EquityLift;
  public function new(self) this = self;
  static public function lift<I,O,E>(self:EquityDef<I,O,E>):Equity<I,O,E> return new Equity(self);

  public function prj():EquityDef<I,O,E> return this;
  private var self(get,never):Equity<I,O,E>;
  private function get_self():Equity<I,O,E> return lift(this);

  @:noUsing static public function make<I,O,E>(asset:I,value:Null<O>,?error:Iter<E>){
    return lift(new EquityCls(error,value,asset).toEquity());
  }
  @:to public function toError(){
    return this.error.toError();
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
    return errata(self,x -> x.errate(fn));
  }
  static public function errata<I,O,E,EE>(self:EquityDef<I,O,E>,fn:Error<E>->Error<EE>):Equity<I,O,EE>{
    return Equity.make(
      self.asset,
      self.value,
      self.error.errata(fn)
    );
  }
  static public function copy<I,O,E>(self:EquityDef<I,O,E>,asset:I,?value:O,?error:Iter<E>){
    return lift(new EquityCls(
      __.option(error).defv(self.error),
      __.option(value).defv(self.value),
      __.option(asset).defv(self.asset)
    ).toEquity());
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
  static public function has_error<I,O,E>(self:EquityDef<I,O,E>){
    return self.error.is_defined();
  }
  static public function defect<I,O,E>(self:EquityDef<I,O,E>,error:Iter<E>){
    return copy(self,null,null,self.error.concat(error));
  }
  static public function toRes<I,O,E>(self:EquityDef<I,O,E>):Res<O,E>{
    return switch(self.error.is_defined()){
      case true   : __.reject(self.error.toError());
      case false  : __.accept(self.value); 
    }
  }
}