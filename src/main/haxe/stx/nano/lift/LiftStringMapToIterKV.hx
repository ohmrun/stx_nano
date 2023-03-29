package stx.nano.lift;

class LiftStringMapToIterKV{
  static public function toIterKV<V>(map:StringMap<V>):IterKV<String,V>{
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