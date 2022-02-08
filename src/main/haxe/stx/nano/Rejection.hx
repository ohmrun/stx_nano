package stx.nano;

typedef RejectionDef<E>            = Error<Declination<E>>;

@:using(stx.nano.Rejection.RejectionLift)
@:forward abstract Rejection<E>(RejectionDef<E>) from RejectionDef<E> to RejectionDef<E>{
  static public var _(default,never) = RejectionLift;
  public inline function new(self) this = self;
  static public inline function lift<E>(self:RejectionDef<E>):Rejection<E> return new Rejection(self);
  static public inline function make<E>(data:Option<Declination<E>>,lst:Option<Rejection<E>>,?pos:Pos):Rejection<E>{
    return lift(Error.make(data,lst.map(x -> x.prj()),pos));
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
  @:from static public function fromError<E>(self:Error<E>){
    return lift(self.errate(REJECT));
  }
  @:noUsing static public function fromDefect<T,E>(self:Defect<E>):Rejection<E>{
    return fromError(self.toError());
  }
  public function iterator():Iterator<Null<Declination<E>>>{
    return this.iterator();
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
  //static public function fold<E,Z>(self:RejectionDef<E>,fn:Fault->Option<E>)
}