package stx.nano;

typedef VBlockDef<T>            = Void -> Void;

@:callable abstract VBlock<T>(VBlockDef<T>) from VBlockDef<T>{
  static public function unit<T>():VBlock<T>{
    return () -> {}
  }
  public function new(self:VBlockDef<T>){
    this = self;
  }
}