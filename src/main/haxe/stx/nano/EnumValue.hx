package stx.nano;

abstract EnumValue(StdEnumValue) from StdEnumValue{
  static public function pure(self:StdEnumValue):EnumValue{
    return new EnumValue(self);
  }
  public function new(self:StdEnumValue) this = self;
  public function params(){
    return StdType.enumParameters(this);
  }
  public function ctr(){
    return StdType.enumConstructor(this);
  }
  public function index(){
    return StdType.enumIndex(this);
  }
  public function alike(that:EnumValue){
    return ctr() == that.ctr() && index() == that.index();
  }
  public function prj():StdEnumValue{
    return this;
  }
}