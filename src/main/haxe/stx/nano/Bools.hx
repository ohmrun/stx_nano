package stx.nano;

class Bools{
  static public function truthiness(str:String){
    return switch(StringTools.trim(str)){
      case "true"   : true;
      case "1"      : true;
      case "0"      : false;
      case "false"  : false;
      case null     : false;
      default       : true; 
    }
  }
}