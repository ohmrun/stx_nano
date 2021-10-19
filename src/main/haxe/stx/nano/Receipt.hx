package stx.nano;

typedef ReceiptDef<T,E> = {
  final value : Null<T>;
  final error : Defect<E>;
}
@:using(stx.nano.Receipt.ReceiptLift)
@:forward abstract Receipt<T,E>(ReceiptDef<T,E>) from ReceiptDef<T,E> to ReceiptDef<T,E>{
  static public var _(default,never) = ReceiptLift;
  public function new(self) this = self;
  @:noUsing static public function lift<T,E>(self:ReceiptDef<T,E>):Receipt<T,E> return new Receipt(self);
  static public function unit<T,E>(){
    return make(null,Defect.unit());
  }
  @:noUsing static public function make<T,E>(value:Null<T>,?error:Defect<E>){
    return lift({ value : value, error : Defect.make(error)});
  }
  public function prj():ReceiptDef<T,E> return this;
  private var self(get,never):Receipt<T,E>;
  private function get_self():Receipt<T,E> return lift(this);

  @:noUsing static public function fromDefect<T,E>(self:Defect<E>):Receipt<T,E>{
    return lift({ value : null, error : self});
  }
  @:noUsing static public function pure<T,E>(self:T):Receipt<T,E>{
    return lift({ value : self, error : Defect.unit()});
  }
}
class ReceiptLift extends Clazz{
  static public function make(){
    return new ReceiptLift();
  }
  static public function lift<T,E>(self:ReceiptDef<T,E>):Receipt<T,E>{
    return Receipt.lift(self);
  }
  static public function errate<T,E,EE>(self:ReceiptDef<T,E>,fn:E->EE):Receipt<T,EE>{
    return errata(self,x -> x.map(fn));
  }
  static public function errata<T,E,EE>(self:ReceiptDef<T,E>,fn:Defect<E>->Defect<EE>){
    return Receipt.make(self.value,fn(self.error));
  }
  static public function copy<T,E>(self:ReceiptDef<T,E>,?value:T,?error:Defect<E>){
    return lift({
      value : __.option(value).defv(self.value),
      error : __.option(error).defv(self.error)
    });
  }
  static public function map<T,Ti,E>(self:ReceiptDef<T,E>,fn:T->Ti):Receipt<Ti,E>{
    return Receipt.make(
      __.option(self.value).fold(
        ok -> fn(ok),
        () -> null
      ),
      self.error
    );
  }
  static public function is_defined<T,E>(self:ReceiptDef<T,E>){
    return self.value != null;
  }
  static public function has_errors<T,E>(self:ReceiptDef<T,E>){
    return self.error.is_defined();
  }
}