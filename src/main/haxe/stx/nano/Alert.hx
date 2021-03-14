package stx.nano;

typedef AlertDef<E> = Future<Report<E>>;

abstract Alert<E>(AlertDef<E>) from AlertDef<E> to AlertDef<E>{
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