package stx.nano;

typedef LedgerDef<I,O,E> = Future<Equity<I,O,E>>;

@:using(stx.nano.Ledger.LedgerLift)
abstract Ledger<I,O,E>(LedgerDef<I,O,E>) from LedgerDef<I,O,E> to LedgerDef<I,O,E>{
  static public var _(default,never) = LedgerLift;
  public function new(self) this = self;
  @:noUsing static public function lift<I,O,E>(self:LedgerDef<I,O,E>):Ledger<I,O,E> return new Ledger(self);

  public function prj():LedgerDef<I,O,E> return this;
  private var self(get,never):Ledger<I,O,E>;
  private function get_self():Ledger<I,O,E> return lift(this);

  @:noUsing static public function fromEquity<I,O,E>(self:Equity<I,O,E>):Ledger<I,O,E>{
    return lift(Future.irreversible(
      (cb) -> cb(self)
    ));
  }
}
class LedgerLift extends Clazz{
  @:noUsing static public function make(){
    return new LedgerLift();
  }
  @:noUsing static public function lift<I,O,E>(self:LedgerDef<I,O,E>):Ledger<I,O,E>{
    return Ledger.lift(self);
  }
  static public function errata<I,O,E,EE>(self:LedgerDef<I,O,E>,fn:Refuse<E>->Refuse<EE>):Ledger<I,O,EE>{
    return self.map((x:Equity<I,O,E>) -> x.errata(fn));
  }
  static public function errate<I,O,E,EE>(self:LedgerDef<I,O,E>,fn:E->EE):Ledger<I,O,EE>{
    return lift(self.map(x -> x.errate(fn)));
  }
  static public function flat_map<I,O,Oi,E>(self:LedgerDef<I,O,E>,fn:O->Ledger<I,Oi,E>):Ledger<I,Oi,E>{
    return self.flatMap(
      (x:Equity<I,O,E>) -> __.option(x.value).fold(
        ok -> fn(ok).errata(e -> x.error.toError().concat(e)),
        () -> Ledger.fromEquity(Equity.make(x.asset,null,x.error))
      )
    );
  }
  static public function map<I,O,Oi,E>(self:LedgerDef<I,O,E>,fn:O->Oi):Ledger<I,Oi,E>{
    return self.map((x:Equity<I,O,E>) -> x.map(fn));
  }
  static public function escape<I,O,E,Z>(self:LedgerDef<I,O,E>,fn:Equity<I,O,E>->Z):Future<Z>{
    return self.map(fn);
  }
}