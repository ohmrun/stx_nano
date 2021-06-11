package stx.async;

import haxe.Timer;

//redisy
class LogicalClock{
  static var lifetime   : Int = 0;
  static var previous   : Null<Float>;
  static var counter    : Int = 0;

  static public function get():TimeStamp{
    var st = TimeStamp.pure;
    return if(previous == null){
      st({
        realm : previous = Timer.stamp(),
        index : counter,
        exact : ++lifetime
      });
    }else{
      var stamp = Timer.stamp(); 
      if(stamp == previous){
        st({
          realm : stamp,
          index : counter++,
          exact : ++lifetime 
        });
      }else{
        previous  = stamp;
        counter   = 0;
        st({
          realm : stamp,
          index : counter,
          exact : ++lifetime 
        });
      }
    }
  }
}