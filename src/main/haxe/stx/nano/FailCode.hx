package stx.nano;

@:allow(stx) enum abstract FailCode(String){
  private function new(self){
    this = self;
  }
  var E_ResourceNotFound;
  var E_IteratorExhaustedUnexpectedly;
  var E_UnexpectedNullValueEncountered;
  var E_OptionForcedError;
  var E_ValueNotReady;
  var E_AbstractMethod;
  var E_IndexOutOfBounds;
  var E_UndefinedError;

  static private function fromString(str:String):FailCode{
    return new FailCode(str);
  }
  public function toString(){
    return this;
  }
}