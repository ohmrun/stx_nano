package stx.nano;

typedef AlertDef<E> = Future<Report<E>>;

@:using(stx.nano.Alert.AlertLift)
@:forward abstract Alert<E>(AlertDef<E>) from AlertDef<E> to AlertDef<E>{
  static public var _(default,never) = AlertLift;
  static public function unit<E>():Alert<E>{
    return Future.irreversible((cb) -> cb(Report.unit()));
  }
  static public function pure<E>(e:Error<E>):Alert<E>{
    return Future.irreversible((cb) -> cb(Report.pure(e)));
  }
  static public function make<E>(self:Report<E>):Alert<E>{
    return Future.irreversible((cb) -> cb(self));
  }
  //TODO not sure about this
  static public function any<E>(arr:Cluster<Alert<E>>):Alert<E>{
    return lift(__.nano().Ft().bind_fold(
      arr,
      (next:Alert<E>,memo:Report<E>) -> next.prj().map(
        (report:Report<E>) -> memo.merge(report)
      ),
      Report.unit()
    ));
  }
  static public function seq<T,E>(arr:Cluster<T>,fn:T->Alert<E>):Alert<E>{
    return lift(
      __.nano().Ft().bind_fold(
        arr,
        (next:T,memo:Report<E>) -> memo.fold(
          (err) -> err.report().alert(),
          ()    -> fn(next)
        ),
        Report.unit()
      )
    );
  }
  public function new(self) this = self;
  static public function lift<E>(self:AlertDef<E>):Alert<E> return new Alert(self);

  public function prj():AlertDef<E> return this;
  private var self(get,never):Alert<E>;
  private function get_self():Alert<E> return lift(this);

  public function errata<EE>(fn:Error<E>->Error<EE>):Alert<EE>{
    return this.map(report -> report.errata(fn));
  }
  public function errate<EE>(fn:E->EE):Alert<EE>{
    return errata((err) -> err.map(fn));
  }
  public function handle(fn:Report<E>->Void):CallbackLink{
    return this.handle(fn);
  }
}
class AlertLift{
  static public function fold<E,Z>(self:AlertDef<E>,pure:Error<E>->Z,unit:Void->Z):Future<Z>{
    return self.map(
      report -> report.fold(pure,unit)
    );
  }
  static public function execute<E>(self:AlertDef<E>,fn:Void->Alert<E>):Alert<E>{
    return self.flatMap(
      report -> report.fold(
        err -> Alert.pure(err),
        ()  -> fn()
      )
    );
  }
  static public function adjust<E>(self:AlertDef<E>,fn:Report<E>->Alert<E>):Alert<E>{
    return Alert.lift(
      self.flatMap(
        (report) -> fn(report)
      ) 
    );
  }
  static public function tap<E>(self:AlertDef<E>,fn:Report<E>->?Pos->Void,?pos:Pos):Alert<E>{
    return Alert.lift(self.map(
      (report) -> {
        fn(report,pos);
        return report;
      }
    ));
  }
  static public function flat_fold<E,T>(self:AlertDef<E>,ers:Error<E>->Future<T>,nil:Void->Future<T>):Future<T>{
    return self.flatMap(
      (report) -> report.fold(
        ers,
        nil
      )
    );
  }
  static public function resolve<E,T>(self:AlertDef<E>,val:T):Pledge<T,E>{
    return Pledge.lift(fold(self,(e) -> __.reject(e.except()),() -> __.accept(val)));
  }
  static public function ignore<E>(self:AlertDef<E>,?fn:E->Bool):Alert<E>{
    return Alert.lift(self.map(
      (report:Report<E>) -> report.ignore(fn)
    ));
  }
  static public function anyway<E>(self:AlertDef<E>,fn:Report<E>->Alert<E>):Alert<E>{
    return self.flatMap(
      (report) -> fn(report).prj()
    );
  }
  static public function toTinkPromise<E>(self:AlertDef<E>):tink.core.Promise<Noise>{
    return fold(
      self,
      er -> tink.core.Outcome.Failure(er.toTinkError()),
      () -> tink.core.Outcome.Success(Noise)
    );
  }
}