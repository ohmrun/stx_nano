package stx.nano;

class Bools{
  /**

  **/
  static public function truthiness(str:String){
    return switch(__.option(str).map(StringTools.trim).defv(null)){
      case "true"   : true;
      case "1"      : true;
      case "0"      : false;
      case "false"  : false;
      case null     : false;
      default       : true; 
    }
  }
}