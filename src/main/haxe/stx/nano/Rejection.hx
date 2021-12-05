package stx.nano;

typedef RejectionDef<E>            = Error<Declination<E>>;

@:using(stx.nano.Rejection.RejectionLift)
@:forward abstract Rejection<E>(RejectionDef<E>) from RejectionDef<E> to RejectionDef<E>{
  static public var _(default,never) = RejectionLift;
  public function new(self) this = self;
  static public function lift<E>(self:RejectionDef<E>):Rejection<E> return new Rejection(self);
  static public function make<E>(data:Option<Declination<E>>,lst:Option<Rejection<E>>,?pos:Pos):Rejection<E>{
    // #if stx_assert
    // __.assert().exists(data);
    // __.assert().exists(lst);
    // #end
    return lift(new stx.pico.error.term.ErrorBase(data,lst.map(x -> x.prj()),Some(pos)));
  }
  public function prj():RejectionDef<E> return this;
  private var self(get,never):Rejection<E>;
  private function get_self():Rejection<E> return lift(this);

  public function concat(that:Rejection<E>){
    return _.concat(this,that);
  }
  public var lst(get,never) : Option<Rejection<E>>;
  public function get_lst() : Option<Rejection<E>>{
    return this.lst.map(lift);
  }
  public function errate<EE>(fn:E->EE):Rejection<EE>{
    return _.errate(this,fn);
  }
}
class RejectionLift{
  static public inline function lift<E>(self:RejectionDef<E>):Rejection<E>{
    return Rejection.lift(self);
  }
  static public function concat<E>(self:RejectionDef<E>,that:Rejection<E>):Rejection<E>{
    return lift(self.concat(that.prj()));
  }
  static public function errate<E,EE>(self:RejectionDef<E>,fn:E->EE):Rejection<EE>{
    return lift(self.errate(x -> x.map(fn)));
  }
}