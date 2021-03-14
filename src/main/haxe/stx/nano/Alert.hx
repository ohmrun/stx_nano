package stx.nano;

typedef AlertDef<E> = Future<Report<E>>;

@:forward abstract Alert<E>(AlertDef<E>) from AlertDef<E> to AlertDef<E>{
  static public function unit<E>():Alert<E>{
    return Future.irreversible( (cb) -> cb(Report.unit()));
  }
  static public function pure<E>(e:Err<E>):Alert<E>{
    return Future.irreversible( (cb) -> cb(Report.pure(e)));
  }
  public function new(self) this = self;
  static public function lift<E>(self:AlertDef<E>):Alert<E> return new Alert(self);

  public function prj():AlertDef<E> return this;
  private var self(get,never):Alert<E>;
  private function get_self():Alert<E> return lift(this);

  public function errata<EE>(fn:Err<E>->Err<EE>){
    return this.map(
      report -> report.errata(
        fn
      )
    );
  }
  public function errate<EE>(fn:E->EE){
    return errata((err) -> err.map(fn));
  }
}