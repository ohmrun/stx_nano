package stx.nano;

typedef AlertDef<E> = Future<Report<E>>;

@:using(stx.nano.Alert.AlertLift)
@:forward abstract Alert<E>(AlertDef<E>) from AlertDef<E> to AlertDef<E>{
  static public var _(default,never) = AlertLift;
  static public function unit<E>():Alert<E>{
    return Future.irreversible((cb) -> cb(Report.unit()));
  }
  static public function pure<E>(e:Err<E>):Alert<E>{
    return Future.irreversible((cb) -> cb(Report.pure(e)));
  }
  static public function any<E>(arr:Array<Alert<E>>):Alert<E>{
    return lift(__.nano().Ft().bind_fold(
      arr,
      (next:Alert<E>,memo:Report<E>) -> next.prj().map(
        (report:Report<E>) -> memo.merge(report)
      ),
      Report.unit()
    ));
  }
  public function new(self) this = self;
  static public function lift<E>(self:AlertDef<E>):Alert<E> return new Alert(self);

  public function prj():AlertDef<E> return this;
  private var self(get,never):Alert<E>;
  private function get_self():Alert<E> return lift(this);

  public function errata<EE>(fn:Err<E>->Err<EE>){
    return this.map(report -> report.errata(fn));
  }
  public function errate<EE>(fn:E->EE){
    return errata((err) -> err.map(fn));
  }
  public function handle(fn:Report<E>->Void):CallbackLink{
    return this.handle(fn);
  }
}
class AlertLift{
  static public function fold<E,Z>(self:Alert<E>,pure:Err<E>->Z,unit:Void->Z):Future<Z>{
    return self.prj().map(
      report -> report.fold(pure,unit)
    );
  }
  static public function execute<E>(self:Alert<E>,fn:Void->Alert<E>):Alert<E>{
    return self.prj().flatMap(
      report -> report.fold(
        err -> Alert.pure(err),
        ()  -> fn()
      )
    );
  }
}