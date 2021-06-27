package stx.nano;

typedef TimeStampDef = {
  final exact : Int;
  final realm : Float;
  final index : Int;
}
@:forward abstract TimeStamp(TimeStampDef){
  private function new(self) this = self;
  @:allow(stx.nano.LogicalClock) static private function pure(v:TimeStampDef){
    return new TimeStamp(v);
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