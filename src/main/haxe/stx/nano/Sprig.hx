package stx.nano;

/**
  Intending to group Haxe's byte-like types. 
**/
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

  public function toString(){
    return switch(this){
      case Textal(str) : str;
      case Byteal(b)   : b.toString();
    }
  }
  public function fold<Z>(textal:String -> Z,byteal:Numeric -> Z) : Z {
    return switch(this){
      case Textal(txt) : textal(txt);
      case Byteal(num) : byteal(num);
    } 
  }
}