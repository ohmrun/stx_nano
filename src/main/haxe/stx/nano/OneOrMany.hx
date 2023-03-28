package stx.nano;

/**
 * Graceful handing of 
 */
enum OneOrManySum<T>{
  OneOf(v:T);
  ManyOf(arr:Cluster<T>);
}
abstract OneOrMany<T>(OneOrManySum<T>) from OneOrManySum<T> to OneOrManySum<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:OneOrManySum<T>):OneOrMany<T> return new OneOrMany(self);
  
  @:noUsing @:from static public function fromT<T>(self:T):OneOrMany<T>{
    return lift(OneOf(self));
  }
  @:noUsing @:from static public function fromCluster<T>(self:Cluster<T>){
    return lift(ManyOf(self));
  }
  @:noUsing @:from static public function fromArray<T>(self:Array<T>){
    return lift(ManyOf(Cluster.lift(self)));
  }
  @:to public function toArray():Array<T>{
    return switch(this){
      case OneOf(v)     : [v];
      case ManyOf(arr)  : @:privateAccess arr.prj();
    }
  }

  public function prj():OneOrManySum<T> return this;
  private var self(get,never):OneOrMany<T>;
  private function get_self():OneOrMany<T> return lift(this);
}