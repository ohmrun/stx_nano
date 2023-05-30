package stx.nano;

enum PrimitiveSum{
  PNull;
  PBool(b:Bool);
  PSprig(sprig:Sprig);
}

abstract Primitive(PrimitiveSum) from PrimitiveSum to PrimitiveSum{
  @:from @:noUsing static public function fromInt(i:Int):Primitive{
    return PSprig(Byteal(NInt(i)));
  }
  @:from @:noUsing static public function fromFloat(i:Float):Primitive{
    return PSprig(Byteal(NFloat(i)));
  }
  @:from @:noUsing static public function fromBool(i:Bool):Primitive{
    return PBool(i);
  }
  @:from @:noUsing static public function fromString(i:StdString):Primitive{
    return PSprig(Textal(i));
  }
  public function toAny():Any{
    return switch (this){
      case PSprig(Byteal(NInt(n)))    : n;
      case PSprig(Byteal(NInt64(n)))  : n;
      case PSprig(Byteal(NFloat(n)))  : n;
      case PSprig(Textal(t))          : t;
      case PBool(b)                   : b;
      case PNull                      : null;
    }
  }
  public function toString():String{
    return switch (this){
      case PSprig(Byteal(NInt(n)))    : '$n';
      case PSprig(Byteal(NInt64(n)))  : '$n';
      case PSprig(Byteal(NFloat(n)))  : '$n';
      case PSprig(Textal(t))          : t;
      case PBool(b)                   : '$b';
      case PNull                      : 'null';
    }
  }
  public function prj():PrimitiveSum{
    return this;
  }
  static public function lt(l:Primitive,r:Primitive){
    return switch([l,r]){
      case [PSprig(Textal(str)),PSprig(Textal(str0))]                       : str < str0;
      case [PSprig(Byteal(NInt64(int))),PSprig(Byteal(NInt64(int0)))]       : int < int0;
      case [PSprig(Byteal(NInt(int))),PSprig(Byteal(NInt(int0)))]           : int < int0;
      case [PSprig(Byteal(NFloat(fl))),PSprig(Byteal(NFloat(fl0)))]         : fl < fl0;
      case [PBool(false),PBool(true)]                                       : true;
      case [PBool(_),PBool(_)]                                              : false;
      case [x,y]  :
        Type.enumIndex((x:Dynamic)) < Type.enumIndex((y:Dynamic));
    }
  }
  static public function eq(l:Primitive,r:Primitive){
    return switch([l,r]){
      case [PNull,PNull]                                                    : true;
      case [PSprig(Textal(str)),PSprig(Textal(str0))]                       : str == str0;
      case [PSprig(Byteal(NInt64(int))),PSprig(Byteal(NInt64(int0)))]       : int == int0;
      case [PSprig(Byteal(NInt(int))),PSprig(Byteal(NInt(int0)))]           : int == int0;
      case [PSprig(Byteal(NFloat(fl))),PSprig(Byteal(NFloat(fl0)))]         : fl == fl0;
      case [PBool(true),PBool(true)]                                        : true;
      case [PBool(false),PBool(false)]                                      : true;
      case [PBool(_),PBool(_)]                                              : false;
      default                                                               : false;
    }
  }
}