package stx.nano;

typedef EnquireDef<P> = {
  public final enquire : P;
}
@:using(stx.nano.Enquire.EnquireDef)
abstract Enquire<P>(EnquireDef<P>) from EnquireDef<P> to EnquireDef<P>{
  public function new(self) this = self;
  static public function lift<P>(self:EnquireDef<P>):Enquire<P> return new Enquire(self);

  public function prj():EnquireDef<P> return this;
  private var self(get,never):Enquire<P>;
  private function get_self():Enquire<P> return lift(this);
}
class EnquireLift{

}