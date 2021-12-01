package stx.nano;

@:using(stx.nano.Declination.DeclinationLift)
enum DeclinationSum<T>{
  EXCEPT(v:T);//ERR_OF
  REFUSE(digest:Digest);
}
@:using(stx.nano.Declination.DeclinationLift)
abstract Declination<T>(DeclinationSum<T>) from DeclinationSum<T> to DeclinationSum<T>{
  static public var _(default,never) = DeclinationLift;
  public function new(self) this = self;
  @:noUsing static public inline function lift<T>(self:DeclinationSum<T>):Declination<T> return new Declination(self);

  @:from static public function fromDigest<T>(code:Digest):Declination<T>{
    return REFUSE(code);
  }
  static public function fromErrOf<T>(v:T):Declination<T>{
    return EXCEPT(v);
  }
  public function report(?pos:Pos):Report<Declination<T>>{
    return Report.pure(Nano._.fault(__,pos).decline(this));
  }
  public function prj():Declination<T> return this;
  private var self(get,never):Declination<T>;
  private function get_self():Declination<T> return lift(this);
}
class DeclinationLift{
  static public function fold<T,Z>(self:DeclinationSum<T>,val:T->Z,def:Digest->Z):Z{
    return switch(self){
      case EXCEPT(v) :  val(v);
      case REFUSE(e)    :  def(e);
    }
  }
  static public function fold_filter<T>(self:DeclinationSum<T>,val:T->Bool,def:Digest->Bool):Option<Declination<T>>{
    return fold(
      self,
      (x) -> Nano._.if_else(
        val(x),
        () -> Option.pure(EXCEPT(x)),
        () -> Option.unit()
      ),
      x -> Nano._.if_else(
        def(x),
        () -> Option.pure(REFUSE(x)),
        () -> Option.unit()
      )
    );
  }
  static public function pick<T>(self:DeclinationSum<T>,val:T->Bool,code:Digest->Bool):Bool{
    return !(fold_filter(self,val,code).is_defined());
  }
  static  public function value<T>(self:DeclinationSum<T>):Option<T>{
    return fold(
      self,
      Some,
      (_) -> None
    );
  }
  static public function toString<T>(self:DeclinationSum<T>):String{
    return fold(
      self,
      (v) -> Std.string(v),
      (n) -> n.toString()
    );
  }
  static public function map<E,EE>(self:DeclinationSum<E>,fn:E->EE):Declination<EE>{
    return stx.nano.Declination.lift(
      fold(
        self,
        x -> EXCEPT(fn(x)),
        y -> REFUSE(y)      
      )
    );
  }
}