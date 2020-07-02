package stx.core.pack;

import tink.core.Lazy;
import tink.core.Future;

enum SlotDef<T>{
  Ready(f:Void->T);
  Guard(fn:Void -> Future<Slot<T>>);
}
@:using(stx.core.pack.Slot.SlotLift)
abstract Slot<T>(SlotDef<T>) from SlotDef<T> to SlotDef<T>{
  static public var _(default,never) = SlotLift;
  public function new(self) this = self;
  static public function lift<T>(self:SlotDef<T>):Slot<T> return new Slot(self);
  

  public function prj():SlotDef<T> return this;
  private var self(get,never):Slot<T>;
  private function get_self():Slot<T> return lift(this);
}
class SlotLift{
  static public inline function map<T,TT>(self:Slot<T>,fn:T->TT):Slot<TT>{
    return switch(self){
      case Ready(t)   : Ready(() -> fn(t()));
      case Guard(f)   : Guard(
        () -> f().map( (slot:Slot<T>) -> map(slot,fn) )
      );
    }
  }
  static public function flat_map<T,TT>(self:Slot<T>,fn:T->Slot<TT>):Slot<TT>{
    return switch(self){
      case Ready(t) : fn(t());
      case Guard(f) : Guard(
       () -> f().map((s:Slot<T>) -> s.flat_map(fn)) 
      );
    }
  }
  static public function value<T>(self:Slot<T>):Option<T>{
    return switch(self){
      case Ready(t) : Some(t());
      default       : None;
    }
  }
  static public inline function handle<T>(self:Slot<T>,fn:T->Void):Void{
    switch(self){
      case Ready(f)   : fn(f());
      case Guard(f)   : f().handle((slot) -> slot.handle(fn));
    }
  }
  static public function toFuture<T>(self:Slot<T>):Future<T>{
    return switch(self){
      case Ready(f) : Future.lazy(Lazy.ofFunc(f));
      case Guard(f) : f().flatMap( slot -> slot.toFuture() );
    }
  }
}