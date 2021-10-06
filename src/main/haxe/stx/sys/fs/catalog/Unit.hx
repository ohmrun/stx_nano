package stx.sys.fs.catalog;

private class Unit extends Catalog<String>{
  public function encode(t:String):String{
    return t;
  }
  public function decode(str:String):String{
    return str;
  }
}