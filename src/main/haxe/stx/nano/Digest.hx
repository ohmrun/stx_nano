package stx.nano;

@:allow(stx) enum abstract Digest(String){
  private function new(self){
    this = self;
  }
  var E_Undefined;

  static private function fromString(str:String):Digest{
    return new Digest(str);
  }
  public function toString(){
    return this;
  }
}