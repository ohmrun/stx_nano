package stx.nano;

typedef UniqueDef<T> = {
  public var data(default,null) : T;
  public var rtid(default,null) : Void->Void;
}

/**
  You can get around it, of course, but the identity is held within here.
**/
@:forward abstract Unique<T>(UniqueDef<T>){
  private function new(self) this = self;
  @:noUsing static public function lift<T>(self:UniqueDef<T>):Unique<T> return new Unique(self);
  @:noUsing static public function pure<T>(data:T):Unique<T> return make(data,()->{});
  @:noUsing static private function make<T>(data:T,rtid:Void->Void){
    return lift({
      data : data,
      rtid : rtid
    });
  }
  

  private function prj():UniqueDef<T> return this;
  private var self(get,never):Unique<T>;
  private function get_self():Unique<T> return lift(this);

  public function equals(that:Unique<T>){
    return this.rtid == that.rtid;
  }
  @:to public function toT():T{
    return this.data;
  }
}