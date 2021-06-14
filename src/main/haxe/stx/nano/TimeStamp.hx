package stx.nano;

abstract TimeStamp({
  exact : Int,
  realm : Float,
  index : Int
}){
  private function new(self) this = self;
  @:allow(stx.nano.LogicalClock) static private function pure(v){
    return new TimeStamp(v);
  }
  public var realm(get,never):Float;
  function get_realm(){
    return this.realm;
  }
  public var index(get,never):Int;
  public function get_index(){
    return this.index;
  }
  public var exact(get,never):Int;
  public function get_exact(){
    return this.exact;
  }
  @:op(A<B)
  public function compare_to(that:TimeStamp){
    return if(this.realm > that.realm){ 
      1;
    }else if(this.realm == that.realm){
      this.exact > that.exact ? 1 : -1;
    }else{
      -1;
    }
  }
}