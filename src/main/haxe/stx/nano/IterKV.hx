package stx.nano;

typedef IterKVDef<K,V> = KeyValueIterable<K,V>;

@:forward abstract IterKV<K,V>(IterKVDef<K,V>) from IterKVDef<K,V> to IterKVDef<K,V>{
  public function new(self) this = self;
  @:noUsing static public function lift<K,V>(self:IterKVDef<K,V>):IterKV<K,V> return new IterKV(self);

  public function prj():IterKVDef<K,V> return this;
  private var self(get,never):IterKV<K,V>;
  private function get_self():IterKV<K,V> return lift(this);

  @:to public function toIter():Iter<KV<K,V>>{
    return ({ iterator : this.keyValueIterator }:Iter<{ key : K, value : V}>).map((t) -> KV.make(t.key,t.value));
  }
  @:from static public function fromEnsemble<V>(self:Ensemble<V>):IterKV<String,V>{
    return lift({
      keyValueIterator : () -> self.prj().keyValueIterator()
    });
  }
}