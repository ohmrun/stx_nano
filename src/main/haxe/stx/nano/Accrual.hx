package stx.nano;

typedef AccrualDef<T,E> = Future<Receipt<T,E>>;

@:using(stx.nano.Accrual.AccrualLift)
abstract Accrual<T,E>(AccrualDef<T,E>) from AccrualDef<T,E> to AccrualDef<T,E>{
  static public var _(default,never) = AccrualLift;
  public inline function new(self) this = self;
  @:noUsing static public inline function unit<T,E>(){
    return Future.irreversible(
      cb -> cb(Receipt.unit())
    );
  }
  @:noUsing static public function fromReceipt<T,E>(self:Receipt<T,E>):Accrual<T,E>{
    return lift(Future.irreversible(
      (cb) -> cb(self)
    ));
  }
  @:noUsing static public function lift<T,E>(self:AccrualDef<T,E>):Accrual<T,E> return new Accrual(self);

  public function prj():AccrualDef<T,E> return this;
  private var self(get,never):Accrual<T,E>;
  private function get_self():Accrual<T,E> return lift(this);
}
class AccrualLift extends Clazz{
  static public function make(){
    return new AccrualLift();
  }
  static inline public function lift<T,E>(self:AccrualDef<T,E>){
    return Accrual.lift(self);
  }
  static public function errata<T,E,EE>(self:AccrualDef<T,E>,fn:Defect<E>->Defect<EE>):Accrual<T,EE>{
    return self.map((x:Receipt<T,E>) -> x.errata(fn));
  }
  static public function errate<T,E,EE>(self:AccrualDef<T,E>,fn:E->EE):Accrual<T,EE>{
    return lift(self.map(x -> x.errate(fn)));
  }
  static public function flat_map<T,Ti,E>(self:AccrualDef<T,E>,fn:T->Accrual<Ti,E>):Accrual<Ti,E>{
    return self.flatMap(
      (x:Receipt<T,E>) -> __.option(x.value).fold(
        ok -> fn(ok).errata(e -> x.error.concat(e)),
        () -> Accrual.fromReceipt(Receipt.fromDefect(x.error))
      )
    );
  }
  static public function map<T,Ti,E>(self:AccrualDef<T,E>,fn:T->Ti):Accrual<Ti,E>{
    return self.map((x:Receipt<T,E>) -> x.map(fn));
  } 
}