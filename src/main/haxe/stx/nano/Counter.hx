package stx.nano;

class Counter{
  private var value : Int;
  public function new(value = 0){
    this.value = value;
  }
  public function next():Int{
    var result = this.value;
    this.value = this.value + 1;
    return result;
  }
}