package stx.nano;

/**
 * Api for `stx.nano.Equity`
 */
interface EquityApi<I,O,E> extends ReceiptApi<O,E>{
  public final asset : I;
  public function toEquity():EquityDef<I,O,E>;
}
/**
 * Cls for `stx.nano.Equity`
 */
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
/**
 * Def for `stx.nano.Equity`
 */
typedef EquityDef<I,O,E> = ReceiptDef<O,E> & {
  final asset : I;
  public function toEquity():EquityDef<I,O,E>;
} 
/**
 * Represents a value containing some prior value: `asset`, 
 * some possible computed value: `value` (from `Receipt`), 
 * and some possible error `error` (from `Defect`)
 */
@:using(stx.nano.Equity.EquityLift)
@:forward abstract Equity<I,O,E>(EquityDef<I,O,E>) from EquityDef<I,O,E> to EquityDef<I,O,E>{
  static public var _(default,never) = EquityLift;
  public function new(self) this = self;
  /**
   * @see https://github.com/ohmrun/docs/blob/main/conventions.md#lift
   * @param self 
   * @param fn 
   * @return Equity<I,O,EE>
   */
  @:noUsing static public function lift<I,O,E>(self:EquityDef<I,O,E>):Equity<I,O,E> return new Equity(self);

  /**
   * @see https://github.com/ohmrun/docs/blob/main/conventions.md#prj
   * @return EquityDef<I,O,E> return this
   */
  public function prj():EquityDef<I,O,E> return this;

  /**
   * @see https://github.com/ohmrun/docs/blob/main/conventions.md#self
   */
  private var self(get,never):Equity<I,O,E>;
  private function get_self():Equity<I,O,E> return lift(this);

  @:noUsing static public function make<I,O,E>(asset:I,value:Null<O>,?error:Refuse<E>){
    return lift(new EquityCls(error,value,asset).toEquity());
  }
  @:to public function toError(){
    return this.error.toError();
  }

}
class EquityLift extends Clazz{
  @:noUsing static public function make(){
    return new EquityLift();
  }
  @:noUsing static public function lift<I,O,E>(self:EquityDef<I,O,E>):Equity<I,O,E>{
    return Equity.lift(self);
  }
  static public function errate<I,O,E,EE>(self:EquityDef<I,O,E>,fn:E->EE):Equity<I,O,EE>{
    return errata(self,x -> x.errate(fn));
  }
  static public function errata<I,O,E,EE>(self:EquityDef<I,O,E>,fn:Refuse<E>->Refuse<EE>):Equity<I,O,EE>{
    return Equity.make(
      self.asset,
      self.value,
      self.error.errata(fn)
    );
  }
  static public function copy<I,O,E>(self:EquityDef<I,O,E>,asset:I,?value:O,?error:Refuse<E>){
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
  static public function has_value<I,O,E>(self:EquityDef<I,O,E>){
    return self.value != null;
  }
  static public function has_asset<I,O,E>(self:EquityDef<I,O,E>){
    return self.asset != null;
  }
  static public function is_ok<I,O,E>(self:EquityDef<I,O,E>){
    return !self.error.is_defined();
  }
  static public function defect<I,O,E>(self:EquityDef<I,O,E>,error:Refuse<E>){
    return copy(self,null,null,self.error.concat(error));
  }
  static public function relate<I,O,E>(self:EquityDef<I,O,E>,value:O):Equity<I,O,E>{
    return if(lift(self).has_error()){
      self;
    }else{
      copy(self,null,value);
    }
  }
  static public function clear<P,Ri,Rii,E>(self:EquityDef<P,Ri,E>):Equity<P,Rii,E>{
    return Equity.make(self.asset,null,self.error);
  }
  static public function refuse<P,R,E>(self:EquityDef<P,R,E>,error:Refuse<E>):Equity<P,R,E>{
    return Equity.make(self.asset,self.value,self.error.concat(error));
  }
  static public function defuse<P,R,E,EE>(self:EquityDef<P,R,E>):Equity<P,R,EE>{
    return Equity.make(self.asset,self.value,Refuse.unit());
  }

  static public inline function toChunk<I,O,E>(self:EquityDef<I,O,E>):Chunk<O,E>{
    return switch(has_value(self)){
      case true    : Val(self.value); 
      case false   : switch(has_error(self)){
        case true   : End(self.error.toError());
        case false  : Tap;
      } 
    }
  }
  static public function rebase<P,Oi,Oii,E>(self:EquityDef<P,Oi,E>,chunk:Chunk<Oii,E>):Equity<P,Oii,E>{
    return switch(chunk){
      case Val(oII) : relate(clear(self),oII);
      case End(e)   : refuse(clear(self),e);
      case Tap      : clear(self);
    }
  }
  static public function adjust<P,Oi,Oii,E>(self:EquityDef<P,Oi,E>,fn:Oi->Upshot<Oii,E>):Equity<P,Oii,E>{
    return lift(self).has_value().if_else(
      () -> fn(self.value).fold(
        ok -> lift(self).clear().relate(ok),
        er -> lift(self).clear().refuse(er)
      ),
      () -> lift(self).clear()
    );
  }
  // static public function zip<P,Oi,Oii,E>(self:EquityDef<P,Oi,E>,that:EquityDef<P,Oii,E>):Equity<P,Couple<Oi,Oii>,E>{
  //   return if(self.has_errors() || that.has_errors()){
  //     Equity.make()
  //   }
  // }
}