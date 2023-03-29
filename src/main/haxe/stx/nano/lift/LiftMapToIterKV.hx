package stx.nano.lift;

class LiftMapToIterKV{
  static public function toIterKV<K,V>(map:Map<K,V>):IterKV<K,V>{
    return {
      keyValueIterator : function() {
        var source = map.keyValueIterator();
        return{
          next : function(){
            var out = source.next();
            return out;
          },
          hasNext: source.hasNext
        }  
      }
    }
  }
}