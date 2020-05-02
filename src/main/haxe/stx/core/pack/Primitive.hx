package stx.core.pack;

enum PrimitiveDef{
  PNull;
  PBool(b:Bool);
  PInt(int:Int);
  PFloat(fl:Float);
  PString(str:StdString);
}

abstract Primitive(PrimitiveDef) from PrimitiveDef to PrimitiveDef{
  @:from @:noUsing static public function fromInt(i:Int):Primitive{
    return PInt(i);
  }
  @:from @:noUsing static public function fromFloat(i:Float):Primitive{
    return PFloat(i);
  }
  @:from @:noUsing static public function fromBool(i:Bool):Primitive{
    return PBool(i);
  }
  @:from @:noUsing static public function fromString(i:StdString):Primitive{
    return PString(i);
  }
  public function toAny():Any{
    return switch (this){
      case PString(str) : str;
      case PInt(int)    : int;
      case PFloat(fl)   : fl;
      case PBool(b)     : b;
      case PNull        : null;
    }
  }
  public function toString():String{
    return switch (this){
      case PString(str) : str;
      case PInt(int)    : '$int';
      case PFloat(fl)   : '$fl';
      case PBool(b)     : '$b';
      case PNull        : 'null';
    }
  }
  public function prj():PrimitiveDef{
    return this;
  }
  static public function lt(l:Primitive,r:Primitive){
    return switch([l,r]){
      case [PString(str),PString(str0)] : str < str0;
      case [PInt(int),PInt(int0)]       : int < int0;
      case [PFloat(fl),PFloat(fl0)]     : fl < fl0;
      case [PBool(false),PBool(true)]   : true;
      case [PBool(_),PBool(_)]          : false;
      case [x,y]  :
        Type.enumIndex((x:Dynamic)) < Type.enumIndex((y:Dynamic));
    }
  }
  static public function eq(l:Primitive,r:Primitive){
    return switch([l,r]){
      case [PNull,PNull]                : true;
      case [PString(str),PString(str0)] : str == str0;
      case [PInt(int),PInt(int0)]       : int == int0;
      case [PFloat(fl),PFloat(fl0)]     : fl == fl0;
      case [PBool(true),PBool(true)]    : true;
      case [PBool(false),PBool(false)]  : true;
      case [PBool(_),PBool(_)]          : false;
      default                           : false;
    }
  }
}