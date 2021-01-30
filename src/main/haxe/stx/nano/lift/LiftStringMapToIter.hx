package stx.nano.lift;

class LiftStringMapToIter{
  static public function toIter<V>(map:haxe.ds.StringMap<V>):Iter<Couple<String,V>>{
    return LiftMapToIter.toIter(map).map((x) -> __.couple(x.fst(),x.snd()));
  }
}