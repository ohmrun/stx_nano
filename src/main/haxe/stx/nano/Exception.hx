package stx.nano;

typedef ExceptionDef<E>            = Error<Declination<E>>;

@:using(stx.nano.Exception.ExceptionLift)
@:forward abstract Exception<E>(ExceptionDef<E>) from ExceptionDef<E> to ExceptionDef<E>{
  static public var _(default,never) = ExceptionLift;
  public function new(self) this = self;
  static public function lift<E>(self:ExceptionDef<E>):Exception<E> return new Exception(self);
  static public function make<E>(data:Option<Declination<E>>,lst:Option<Exception<E>>,?pos:Pos):Exception<E>{
    return lift(new stx.pico.error.term.ErrorBase(data,lst.map(x -> x.prj()),Some(pos)));
  }
  public function prj():ExceptionDef<E> return this;
  private var self(get,never):Exception<E>;
  private function get_self():Exception<E> return lift(this);

  public function concat(that:Exception<E>){
    return _.concat(this,that);
  }
  public var lst(get,never) : Option<Exception<E>>;
  public function get_lst() : Option<Exception<E>>{
    return this.lst.map(lift);
  }
  public function errate<EE>(fn:E->EE):Exception<EE>{
    return _.errate(this,fn);
  }
}
class ExceptionLift{
  static public inline function lift<E>(self:ExceptionDef<E>):Exception<E>{
    return Exception.lift(self);
  }
  static public function concat<E>(self:ExceptionDef<E>,that:Exception<E>):Exception<E>{
    return lift(self.concat(that.prj()));
  }
  static public function errate<E,EE>(self:ExceptionDef<E>,fn:E->EE):Exception<EE>{
    return lift(self.errate(x -> x.map(fn)));
  }
}