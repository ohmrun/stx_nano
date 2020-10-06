package stx.nano;

typedef StringableDef = {
  public function toString():String;
}
@:forward abstract Stringable(StringableDef) from StringableDef to StringableDef{
  @:noUsing static public function lift(self:StringableDef):Stringable{
    return new Stringable(self);
  }
  public function new(self) this = self;
}