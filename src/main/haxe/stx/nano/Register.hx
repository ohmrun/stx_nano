package stx.nano;

@:allow(stx)
class RegisterCls{
  final index : UInt;
  final count : UInt;
  
  private function new(index,count){
    this.index = index;
    this.count = count;
  }
  @:noUsing static function make(index,count){
    return new RegisterCls(index,count);
  }
  public function equals(that:Register){
    return this.index == that.index && this.count == that.count;
  }
  public function less_than(that:Register){
    return this.index <= that.index && this.count < that.count;
  }
}
@:using(stx.nano.Register.RegisterLift)
@:forward @:allow(stx) abstract Register(RegisterCls) from RegisterCls to RegisterCls{
  static public var _(default,never) = RegisterLift;
  public function new(){
    this = @:privateAccess RegisterState.instance.next();
  }
  @:op(A<A)
  public function less_than(that:Register){
    return this.less_than(that);
  }
  @:op(A==A)
  public function equals(that:Register){
    return this.equals(that);
  }
  @:noUsing static public function unit(){
    return new Register();
  }
}
private class RegisterLift{
  
}
private class RegisterState{
  static final max  : UInt = 0xFFFFFFFF;
  static public var instance(get,null) : RegisterState;
  static public function get_instance(){
    return instance == null ? instance = new RegisterState() : instance; 
  }
  public function new(){}
  public function next(){
    final next       = {
      index : this.index,
      count : this.count
    }
    if(this.count == max){
      this.index = this.index + 1;
      this.count = 0;
    }else{
      this.count = this.count + 1;
    }
    return new RegisterCls(next.index,next.count);
  }
  private var index : UInt = 0;
  private var count : UInt = 0;
  
}
