package stx.nano;

enum SprigSum{
  Textal(str:String);
  Byteal(byte:Numeric);
}
abstract Sprig(SprigSum) from SprigSum to SprigSum{
  public function new(self) this = self;
  static public function lift(self:SprigSum):Sprig return new Sprig(self);

  @:to public function toPrimitive():Primitive{
    return PSprig(this);
  }
  public function prj():SprigSum return this;
  private var self(get,never):Sprig;
  private function get_self():Sprig return lift(this);
}