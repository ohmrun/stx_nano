package stx.nano;

import tink.core.Lazy;
import tink.core.Future;

private class SlotDef<T>{
  public function new(?data:Null<T>,?guard:Null<Future<T>>,?pos:Pos){
    this.data   = data;
    this.ready  = true;
    this.pos    = pos;

    if(guard!=null){
      this.ready  = false;  
      this.guard  = guard;
           guard.handle(handler);
    }

  }
  private function handler(data:T){
    this.ready  = true;
    this.data   = data;
  }
  public var  data(default,null)  : T;
  public var  guard(default,null) : Null<Future<T>>;
  public var  ready(default,null) : Bool;
  public var  pos(default,null)   : Pos;

  public function toString():String{
    var p = Position.lift(pos).to_vscode_clickable_link();
    return 'Slot($ready $p)';
  }
}
@:using(stx.nano.Slot.SlotLift)
@:forward abstract Slot<T>(SlotDef<T>) from SlotDef<T> to SlotDef<T>{
  static public var _(default,never) = SlotLift;
  public function new(self) this = self;
  static public inline function lift<T>(self:SlotDef<T>):Slot<T> return new Slot(self);
  

  public function prj():SlotDef<T> return this;
  private var self(get,never):Slot<T>;
  private function get_self():Slot<T> return lift(this);
  @:noUsing static public function Ready<T>(v:T,?pos:Pos):Slot<T>{
    return new SlotDef(v,null,pos);
  }
  @:noUsing static public function Guard<T>(v:Future<T>,?pos:Pos):Slot<T>{
    return new SlotDef(null,v,pos);
  }
  @:from static public inline function toSlot<T>(ft:tink.core.Future<T>):Slot<T>{
    return new SlotDef(null,ft);
  }
  @:noUsing static public function fromFunSinkVoid<O>(fn:(O->Void)->Void):Slot<O>{
    var v         = None;
    function handler(h){
      v = Some(h);
    }
    fn(handler);
    return switch(v){
      case Some(v) : Ready(v);
      case None    : Guard(Future.irreversible(fn));
    } 
  }
}
class SlotLift{
  static public inline function map<T,TT>(self:Slot<T>,fn:T->TT):Slot<TT>{
    return switch(self.ready){
      case true   : Slot.Ready(fn(self.data),self.pos);
      case false  : Slot.Guard(
        self.guard.map( (t:T) -> fn(t) ),
        self.pos
      );
    }
  }
  static public function flat_map<T,TT>(self:Slot<T>,fn:T->Slot<TT>):Slot<TT>{
    return switch(self.ready){
      case true   : fn(self.data);
      case false  : Slot.Guard(
        self.guard.flatMap(
          (t:T) -> {
            var val : Slot<TT> = fn(t);
            switch(val.ready){
              case true   : Future.lazy(() -> val.data);
              case false  : val.guard;
            }
          }
       )
      );
    }
  }
  static public function value<T>(self:Slot<T>):Option<T>{
    return switch(self.ready){
      case true     : Some(self.data);
      default       : None;
    }
  }
  static public inline function handle<T>(self:Slot<T>,fn:T->Void):Void{
    switch(self.ready){
      case true       : fn(self.data);
      case false      : self.guard.handle(fn);
    }
  }
  static public function toFuture<T>(self:Slot<T>):Future<T>{
    return switch(self.ready){
      case true     : Future.lazy(Lazy.ofFunc(() -> self.data));
      case false    : self.guard;
    }
  }
  static public function zip<T,Ti>(self:Slot<T>,that:Slot<Ti>):Slot<Couple<T,Ti>>{
    return switch([self.ready,that.ready]){
      case [true,true]    : Slot.Ready(__.couple(self.data,that.data));
      case [true,false]   : that.map(rhs -> __.couple(self.data,rhs));
      case [false,true]   : self.map(lhs -> __.couple(lhs,that.data));
      case [false,false]  : Slot.Guard(self.guard.merge(that.guard,__.couple));
    }
  }
}