package stx.nano;

abstract EnumValue(StdEnumValue) from StdEnumValue{
  @:noUsing static public function pure(self:StdEnumValue):EnumValue{
    return new EnumValue(self);
  }
  @:noUsing static public function lift(self:StdEnumValue):EnumValue{
    return new EnumValue(self);
  }
  public function new(self:StdEnumValue) this = self;
  public function params(){
    return StdType.enumParameters(this);
  }
  public function ctr(){
    return StdType.enumConstructor(this);
  }
  public var index(get,never):Int;
  public function get_index():Int{
    return StdType.enumIndex(this);
  }
  public function alike(that:EnumValue){
    return ctr() == that.ctr() && index == that.index;
  }
  public function prj():StdEnumValue{
    return this;
  }
}