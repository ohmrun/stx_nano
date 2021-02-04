package stx.nano.lift;

import haxe.Constraints;

class LiftIMapToArrayKV{
  static public function toArrayKV<K,V>(map:IMap<K,V>):Array<KV<K,V>>{
    var out = [];
    for(key => val in map){
      out.push(KV.fromTup(__.couple(key,val)));
    }
    return out;
  }
}