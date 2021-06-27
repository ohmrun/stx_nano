package stx.nano;

typedef KVDef<K,V> = {
  final key : K;
  final val : V;
}
@:forward abstract KV<K,V>(KVDef<K,V>){
  public function new(self) this = self;
  public function map<U>(fn:V->U):KV<K,U>{
    return {
      key : this.key,
      val : fn(this.val)
    };
  }
  @:from static public function fromObj<K,V>(self:KVDef<K,V>):KV<K,V>{
    return new KV(self);
  }
  @:from static public function fromTup<K,V>(tp:Couple<K,V>):KV<K,V>{
    return new KV({ key : tp.fst(), val : tp.snd()});
  }
  public function fst():K{
    return this.key;
  }
  public function snd():V{
    return this.val;
  }
  public function into<Z>(fn:K->V->Z):Z{
    return fn(this.key,this.val);
  }
  public function decouple<Z>(fn:K->V->Z):Z{
    return fn(this.key,this.val);
  }
}