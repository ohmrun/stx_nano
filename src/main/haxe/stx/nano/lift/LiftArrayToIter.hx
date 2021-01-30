package stx.nano.lift;
class LiftArrayToIter{
  static public function toIter<T>(arr:Array<T>):Iter<T>{
    return arr;
  }
}