package stx.nano;

//TODO uint?
enum NumericSum{
  NInt(int:Int);
  NInt64(int:Int64);
  NFloat(f:Float);
}
abstract Numeric(NumericSum) from NumericSum to NumericSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:NumericSum):Numeric return new Numeric(self);

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
  public function get_width(){
    return switch(this){
      case NInt(int)      : 4;
      case NInt64(int)    : 8;
      case NFloat(f)      : 8;
    }
  }
  public function intoBytes(){

  }
}