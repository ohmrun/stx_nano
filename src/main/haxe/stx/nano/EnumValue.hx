package stx.nano;

/**
 * Thin shim over `std.EnumValue`
 */
abstract EnumValue(StdEnumValue) from StdEnumValue to StdEnumValue{
  @:noUsing static public function pure(self:StdEnumValue):EnumValue{
    return new EnumValue(self);
  }
  /**
   * @see https://github.com/ohmrun/docs/blob/main/conventions.md#lift
   * @param self 
   * @return EnumValue
   */
  @:noUsing static public function lift(self:StdEnumValue):EnumValue{
    return new EnumValue(self);
  }
  public function new(self:StdEnumValue) this = self;
  /**
   * Returns enum parameters
   */
  public function params(){
    return StdType.enumParameters(this);
  }
  /**
   * Returns the enum constructor.
   */
  public function ctr(){
    return StdType.enumConstructor(this);
  }
  /**
   * Index among the enums constructors.
   */
  public var index(get,never):Int;
  public function get_index():Int{
    return StdType.enumIndex(this);
  }
  /**
   * Partial equality, ignoreing the value of the params.
   * @param that 
   */
  public function alike(that:EnumValue){
    return ctr() == that.ctr() && index == that.index;
  }
  /**
   * @see https://github.com/ohmrun/docs/blob/main/conventions.md#prj
   * @return StdEnumValue
   */
  public function prj():StdEnumValue{
    return this;
  }
}