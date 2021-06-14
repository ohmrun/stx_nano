package stx.nano;

import haxe.Constraints;

@:using(stx.nano.Iter.IterLift)
@:forward abstract Iter<T>(Iterable<T>) from Iterable<T> to Iterable<T>{
  static public var _(default,never) = IterLift;

  public function new(self) this = self;
  public function prj():Iterable<T>{
    return this;
  }
}
class IterLift{
  static public function cross<T,Ti>(self:Iterable<T>,that:Iterable<Ti>):Iterable<Couple<T,Ti>>{
    return { iterator : function(){
      var l_it  = self.iterator();
      var r_it  = that.iterator();
      var l_val = null;

      return{
        next : function rec(){
          if(l_val != null &&  l_it.hasNext()){
            l_val = l_it.next();
          } 
          return if(r_it.hasNext()){
            __.couple(l_val,r_it.next());
          }else{
            if(l_it.hasNext()){
              r_it = that.iterator();
            }
            l_val = null;
            rec();
          }
        },
        hasNext: function(){
          return (!l_it.hasNext()) ? r_it.hasNext() : false;
        }
      };
    }
  }}
  static public function zip<L,R>(l:Iterable<L>,r:Iterable<R>):Iterable<Couple<L,R>>{
    return {
      iterator : function():Iterator<Couple<L,R>>{
        var lit = l.iterator();
        var rit = r.iterator();

        return {
          next : function(){
            return __.couple(lit.next(),rit.next()); 
          },
          hasNext : function(){
            return lit.hasNext() && rit.hasNext();
          }
        }
      }
    };
  }
  static public function ldrop<T>(it:Iterable<T>,n:Int):Iterable<T>{
    return {
      iterator : function(){
        var iter = it.iterator();
        while(n>0){
          iter.next();
          n--;
        }
        return iter;
      }
    }
  }
  static public function toMap<T,K,V,M:IMap<K,V>>(iter:Iter<T>,fn:T->Couple<K,V>,map:M):M{
    for(i in iter){
      var kv = fn(i);
          kv.decouple(map.set);
    }
    return map;
  }
  static public function map<T,Ti>(iter:Iter<T>,fn:T->Ti):Iter<Ti>{
    return {
      iterator : function(){
        var i = iter.iterator();
        return {
          next : function(){
            return fn(i.next());
          },
          hasNext: function(){
            return i.hasNext();
          }
        }
      }
    }
  }
  static public function head<T>(iter:Iterable<T>):Option<T>{
    var it = iter.iterator();
    return it.hasNext() ? Some(it.next()) : None;
  }
  static public function tail<T>(iter:Iterable<T>):Iter<T>{
    return {
      iterator : function() {
        var it = iter.iterator();
            it.next();
        return {
          next : it.next,
          hasNext : it.hasNext
        }
      }
    }
  }
    /**

    Tising starting var `z`, run `f` on each element, storing the result, and passing that result
    into the next call.
    ```
    [1,2,3,4,5].foldLeft( 100, function(init,v) return init + v ));//(((((100 + 1) + 2) + 3) + 4) + 5)
    ```

	**/
  static public function lfold<T, Z>(iter: Iterable<T>, mapper: T -> Z -> Z,seed: Z): Z {
    var folded = seed;
    for (e in iter) { folded = mapper(e,folded); }
    return folded;
  }
  static public function lfold1<T>(iter: Iterable<T>, mapper: T -> T -> T):Option<T> {
    return head(iter).map(
      (seed:T) -> lfold(tail(iter),mapper,seed)
    );
  }  
  static public function toGenerator<T>(self:Iter<T>):Void->Option<T>{
    var iter : Option<Iterator<T>> = None;
    return () -> {
      if (iter == None){
       iter = Some(self.iterator());
      }
      return iter.flat_map(
        (x) -> x.hasNext() ? Some(x.next()) : None
      );
    };
  }
  static public function toArray<T>(self:Iter<T>):Array<T>{
    var arr = [];
    for (v in self){
      arr.push(v);
    }
    return arr;
  }
  static public function foldr<T,Z>(iter:Iter<T>,fn:T->Z->Z,init:Z):Z{
    var data      = init;
    var iterator  = iter.iterator();

    function eff():Void{
      if(iterator.hasNext()){
        var next = iterator.next();
        eff();
            data = fn(next,data);
      }
    }
    eff();
    return data;
  }
  // static public function lfold<T,Z>(iter:Iter<T>,fn:T->Z->Z,init:Z):Z{
  //   var data      = init;
  //   var iterator  = iter.iterator();

  //   function eff():Void{
  //     if(iterator.hasNext()){
  //       var next = iterator.next();
  //           data = fn(next,data);
  //           eff();
  //     }
  //   }
  //   eff();
  //   return data;
  // }
  static public function search<T>(iter:Iter<T>,fn:T->Bool):Option<T>{
    return lfold(
      iter,
      (next:T,memo:Option<T>) -> memo.fold(
        Some,
        () -> fn(next).if_else(
          () -> Some(next),
          () -> None
        )
      ),
      None
    );
  }
}