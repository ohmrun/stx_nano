package stx.nano;

@:allow(stx) enum abstract FailCode(String){
  private function new(self){
    this = self;
  }
  var E_Undefined;

  static private function fromString(str:String):FailCode{
    return new FailCode(str);
  }
  public function toString(){
    return this;
  }
}