package stx.nano;

enum NumericSum{
  NInt(int:Int);
  NInt64(int:Int64);
  NFloat(f:Float);
}
abstract Numeric(NumericSum) from NumericSum to NumericSum{
  public function new(self) this = self;
  static public function lift(self:NumericSum):Numeric return new Numeric(self);

  public function prj():NumericSum return this;
  private var self(get,never):Numeric;
  private function get_self():Numeric return lift(this);

  public function toString(){
    return switch(self){
      case NInt(v)    : '$v';
      case NInt64(v)  : '$v';
      case NFloat(v)  : '$v';
    }
  }
}