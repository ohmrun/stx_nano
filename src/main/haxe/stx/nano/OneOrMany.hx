package stx.nano;

enum OneOrManySum<T>{
  OneOf(v:T);
  ManyOf(arr:Array<T>);
}
abstract OneOrMany<T>(OneOrManySum<T>) from OneOrManySum<T> to OneOrManySum<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:OneOrManySum<T>):OneOrMany<T> return new OneOrMany(self);
  
  @:noUsing @:from static public function fromT<T>(self:T):OneOrMany<T>{
    return lift(OneOf(self));
  }
  @:noUsing @:from static public function fromArray<T>(self:Array<T>){
    return lift(ManyOf(self));
  }
  @:to public function toArray():Array<T>{
    return switch(this){
      case OneOf(v)     : [v];
      case ManyOf(arr)  : arr;
    }
  }

  public function prj():OneOrManySum<T> return this;
  private var self(get,never):OneOrMany<T>;
  private function get_self():OneOrMany<T> return lift(this);
}