package stx.nano;

interface ReceiptApi<T,E> extends DefectApi<E>{
  final value : Null<T>;
  public function iterator():Iterator<T>;
}
class ReceiptCls<T,E> extends DefectCls<E> implements ReceiptApi<T,E>{
  public final value : Null<T>;
  public function new(error,value:Null<T>){
    super(error);
    this.value = value;
  }
  public function iterator(){
    var done  = false;
    final test = () -> {
      done = true;
      if(error.is_defined()){
        error.raise();
      }else if(value == null){
        throw 'undefined'; 
      }
    }
    return {
      next : () -> {
        test();
        return value;
      },
      hasNext : () -> {
        if(!done){
          test();
          true;
        }else{
          false;
        }
      }
    }
  }
}
typedef ReceiptDef<T,E> = DefectDef<E> & {
  final value : Null<T>;
  public function iterator():Iterator<T>;
}
@:using(stx.nano.Receipt.ReceiptLift)
@:forward abstract Receipt<T,E>(ReceiptDef<T,E>) from ReceiptDef<T,E> to ReceiptDef<T,E>{
  static public var _(default,never) = ReceiptLift;
  public function new(self) this = self;
  @:noUsing static public function lift<T,E>(self:ReceiptDef<T,E>):Receipt<T,E> return new Receipt(self);
  static public function unit<T,E>(){
    return make(null,Refuse.unit());
  }
  @:noUsing static public function make<T,E>(value:Null<T>,?error:Refuse<E>){
    return lift(new ReceiptCls(__.option(error).defv(Refuse.unit()),value));
  }
  public function prj():ReceiptDef<T,E> return this;
  private var self(get,never):Receipt<T,E>;
  private function get_self():Receipt<T,E> return lift(this);

  @:noUsing static public function fromDefect<T,E>(self:Defect<E>):Receipt<T,E>{
    return make(null,self.error);
  }
  @:noUsing static public function pure<T,E>(self:T):Receipt<T,E>{
    return make(self,Refuse.unit());
  }
  @:to public function toError(){
    return this.error.toError();
  }
}
class ReceiptLift extends Clazz{
  @:noUsing static public function make(){
    return new ReceiptLift();
  }
  @:noUsing static public function lift<T,E>(self:ReceiptDef<T,E>):Receipt<T,E>{
    return Receipt.lift(self);
  }
  static public function errate<T,E,EE>(self:ReceiptDef<T,E>,fn:E->EE):Receipt<T,EE>{
    return errata(self,x -> x.errate(fn));
  }
  static public function errata<T,E,EE>(self:ReceiptDef<T,E>,fn:Refuse<E>->Refuse<EE>){
    return Receipt.make(
      self.value,
      self.error.errata(fn)
    );
  }
  static public function copy<T,E>(self:ReceiptDef<T,E>,?value:T,?error:Refuse<E>){
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
  static public function has_value<T,E>(self:ReceiptDef<T,E>){
    return self.value != null;
  }
  static public function toRes<T,E>(self:Receipt<T,E>):Res<T,E>{
    return switch(self.has_errors()){
      case true   : __.reject(self.toDefect().toRefuse());
      case false  : __.accept(self.value); 
    }
  }
}