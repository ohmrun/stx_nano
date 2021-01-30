package stx.nano.lift;
class LiftIterableToIter{
  static public function toIter<T>(it:Iterable<T>):Iter<T>{
    return it;
  }
}