package stx.nano;

typedef IterKVDef<K,V> = KeyValueIterable<K,V>;

@:using(stx.nano.IterKV.IterKVLift)
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

class IterKVLift{
  static public function map<K,V,VV>(self:IterKV<K,V>,fn:V->VV):IterKV<K,VV>{
    return IterKV.lift({
      keyValueIterator : () -> {
        final iterator = self.keyValueIterator();
        return {
          next : () -> {
            final kv = iterator.next();
            return { key : kv.key, value : fn(kv.value) };
          },
          hasNext : () -> {
            return iterator.hasNext();
          }
        }
      }
    });
  }

  static public function map_zip<K,V,Z>(self:IterKV<K,V>,fn:K->V->Z):Iter<Z>{
    return Iter.lift({
      iterator : () -> {
        final iterator = self.keyValueIterator();
        return {
          next : () -> {
            final kv = iterator.next();
            return fn(kv.key,kv.value);
          },
          hasNext : () -> {
            return iterator.hasNext();
          }
        }
      }
    });
  }
  static public function map_both<K,KK,V,VV>(self:IterKV<K,V>,lhs:K->KK,rhs:V->VV):IterKV<KK,VV>{
    return IterKV.lift({
      keyValueIterator : () -> {
        final iterator = self.keyValueIterator();
        return {
          next : () -> {
            final kv = iterator.next();
            return { key : lhs(kv.key), value : rhs(kv.value) };
          },
          hasNext : () -> {
            return iterator.hasNext();
          }
        }
      }
    });
  }
  static public function toCluster<K,V>(self:IterKV<K,V>):Cluster<{key : K, value : V}>{
    final out = [];
    for(key => val in self){
      out.push({key : key, value : val});
    }
    return out;
  }
}