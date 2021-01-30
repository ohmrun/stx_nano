package stx.nano.lift;
class LiftMapToIter{
  static public function toIter<K,V>(map:Map<K,V>):Iter<KV<K,V>>{
    return {
      iterator : function() {
        var source = map.keyValueIterator();
        return{
          next : function(){
            var out = source.next();
            return {
              key : out.key,
              val : out.value
            };
          },
          hasNext: source.hasNext
        }  
      }
    }
  }
}