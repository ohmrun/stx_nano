package stx.nano;

class Introspectable extends Clazz{
  public function locals(){
    return __.definition(this).locals();
  }
}