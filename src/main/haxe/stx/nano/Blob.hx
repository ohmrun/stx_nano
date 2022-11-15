package stx.nano;

/**
  Treat some `Any` value as a scalar value.
**/
abstract Blob(Any) from Any{
	public inline function asInt():Int 					return this;
	public inline function asString():String 		return this;
	public inline function asBool():Bool				return this;
  public inline function asFloat():Float			return this;
  
  public inline function typeof(){
    return std.Type.typeof(this);
  }
}