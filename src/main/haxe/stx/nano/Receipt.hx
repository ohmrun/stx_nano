package stx.nano;

interface ReceiptApi<T,E> extends DefectApi<E>{
  final value : Null<T>;
}
class ReceiptCls<T,E> extends DefectCls<E> implements ReceiptApi<T,E>{
  public final value : Null<T>;
  public function new(error,value:Null<T>){
    super(error);
    this.value = value;
  }
}
typedef ReceiptDef<T,E> = DefectDef<E> & {
  final value : Null<T>;
}
@:using(stx.nano.Receipt.ReceiptLift)
@:forward abstract Receipt<T,E>(ReceiptDef<T,E>) from ReceiptDef<T,E> to ReceiptDef<T,E>{
  static public var _(default,never) = ReceiptLift;
  public function new(self) this = self;
  @:noUsing static public function lift<T,E>(self:ReceiptDef<T,E>):Receipt<T,E> return new Receipt(self);
  static public function unit<T,E>(){
    return make(null,Iter.unit());
  }
  @:noUsing static public function make<T,E>(value:Null<T>,?error:Iter<E>){
    return lift(new ReceiptCls(__.option(error).defv(Iter.unit()),value));
  }
  public function prj():ReceiptDef<T,E> return this;
  private var self(get,never):Receipt<T,E>;
  private function get_self():Receipt<T,E> return lift(this);

  @:noUsing static public function fromDefect<T,E>(self:Defect<E>):Receipt<T,E>{
    return make(null,self.error);
  }
  @:noUsing static public function pure<T,E>(self:T):Receipt<T,E>{
    return make(self,Iter.unit());
  }
  @:to public function toError(){
    return this.error.toError();
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
    return errata(self,x -> x.errate(fn));
  }
  static public function errata<T,E,EE>(self:ReceiptDef<T,E>,fn:Error<E>->Error<EE>){
    return Receipt.make(
      self.value,
      self.error.errata(fn)
    );
  }
  static public function copy<T,E>(self:ReceiptDef<T,E>,?value:T,?error:Iter<E>){
    return Receipt.make(
      __.option(value).defv(self.value),
      __.option(error).defv(self.error)
    );
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
  static public function toRes<T,E>(self:Receipt<T,E>):Res<T,E>{
    return switch(self.has_errors()){
      case true   : __.reject(self.toDefect().toError());
      case false  : __.accept(self.value); 
    }
  }
}