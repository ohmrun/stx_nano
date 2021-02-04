package stx.nano;

@:forward abstract Field<V>(KV<StdString,V>) from KV<StdString,V> to KV<StdString,V>{
  public function new(self:KV<StdString,V>) this = self;
  @:noUsing @:from static public function fromTup<V>(tp:Couple<StdString,V>):Field<V>{
    return new Field({ key : tp.fst(), val : tp.snd()});
  }
  static public function create<V>(key:StdString,val:V){
    return new Field({
      key : key,
      val : val
    });
  }
  public function map<U>(fn:V->U):Field<U>{
    return this.map(fn);
  }
  public function into<R>(fn:StdString->V->R):R{
    return fn(this.key,this.val);
  }
  public function toCouple():Couple<StdString,V>{
    return __.couple(this.key,this.val);
  }
}