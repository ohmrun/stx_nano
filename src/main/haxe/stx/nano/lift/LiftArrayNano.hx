package stx.nano.lift;

class LiftArrayNano{
  /**
    from thx.core
    It returns the cross product between two arrays.
    ```haxe
    var r = [1,2,3].cross([4,5,6]);
    trace(r); // [[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]]
    ```
  **/
  static public function cross<T,Ti>(self:StdArray<T>,that:StdArray<Ti>):Array<Couple<T,Ti>>{
    return self.cross_with(that,__.couple);
  }
  static public function zip<T,Ti>(self:StdArray<T>,that:StdArray<Ti>):Array<Couple<T,Ti>>{
    return self.zip_with(that,__.couple);
  }
}