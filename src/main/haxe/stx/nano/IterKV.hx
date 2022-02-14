package stx.nano;

typedef IterKVDef<K,V> = KeyValueIterable<K,V>;

@:forward abstract IterKV<K,V>(IterKVDef<K,V>) from IterKVDef<K,V> to IterKVDef<K,V>{
  public function new(self) this = self;
  static public function lift<K,V>(self:IterKVDef<K,V>):IterKV<K,V> return new IterKV(self);

  public function prj():IterKVDef<K,V> return this;
  private var self(get,never):IterKV<K,V>;
  private function get_self():IterKV<K,V> return lift(this);
}