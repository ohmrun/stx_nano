package stx.nano;

enum abstract ByteSize(StdString) from StdString to StdString{
  var I8      = 'i8';

  var I16BE   = 'i16+';
  var I16LE   = 'i16-';
  var UI16BE  = 'ui16+';
  var UI16LE  = 'ui16-';

  var I24BE   = 'i24+';
  var I24LE   = 'i24-';
  var UI24BE  = 'ui24+';
  var UI24LE  = 'ui24-';

  var I32BE   = 'i32+';
  var I32LE   = 'i32-';

  var FBE     = 'fbe';
  var FLE     = 'fle';
  var DBE     = 'dbe';
  var DLE     = 'dle';

  var LINE    = 'ln';

  public function endianness():Option<Endianness>{
    return switch(this){
      case I16BE | UI16BE | I24BE | UI24BE | I32BE | FBE | DBE : Some(BIG_ENDIAN);
      case I16LE | UI16LE | I24LE | UI24LE | I32LE | FLE | DLE : Some(LITTLE_ENDIAN);
      default : None;
    }
  }
  public var length(get,never):Int;

  private function get_length():Int{
    return switch(this){
      case I8                               : 1;
      case I16BE | I16LE | UI16BE | UI16LE  : 2;
      case I24BE | I24LE | UI24BE | UI24LE  : 3;
      case I32BE | I32LE | FBE    | FLE     : 4;
      case DBE   | DLE                      : 8;
      default                               : -1;
    }
  }
  public function get_width():Option<Int>{
    final l = get_length();
    return l == -1 ? None : Some(l);
  }
}