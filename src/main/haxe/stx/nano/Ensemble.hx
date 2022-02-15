package stx.nano;


typedef EnsembleDef<T> = haxe.DynamicAccess<T>;

@:using(stx.nano.Ensemble.EnsembleLift)
@:forward abstract Ensemble<T>(EnsembleDef<T>) from EnsembleDef<T> to EnsembleDef<T>{
  
  @:op(A.B) static public function object_access<T>(self:Ensemble<T>, str:String):T{
    return self.prj()[str];
  }

  public function new(self) this = self;
  static public function lift<T>(self:EnsembleDef<T>):Ensemble<T> return new Ensemble(self);
  static public function unit<T>():Ensemble<T>{
    return lift({});
  }
  public function prj():EnsembleDef<T> return this;
  private var self(get,never):Ensemble<T>;
  private function get_self():Ensemble<T> return lift(this);

  public function set(key:String,val:T):Ensemble<T>{
    var next = copy().prj();
        next[key] = val;
    return lift(next);
  } 
  public function concat(that:IterKV<String,T>){
    var next = copy().prj();
    for( k => v in that){
      next[k] = v;
    }
    return lift(next);
  }
  public function copy():Ensemble<T>{
    var next : haxe.DynamicAccess<T> = {};
    for(k => v in this.keyValueIterator()){
      next[k] = v;
    }
    return lift(next);
  }
  @:from static public function fromClusterCouple<V>(self:Cluster<Couple<String,V>>):Ensemble<V>{
    var thiz : haxe.DynamicAccess<V> = {};
    for(tup in self.iterator()){
      tup(
        (l:String,r:V) -> {
          thiz[l] = r;
        }
      );
    }
    return lift(thiz);
  }
  public function toCluster():Cluster<Field<T>>{
    final next = [];
    for(k => v in this){
      next.push(Field.make(k,v));
    }
    return Cluster.lift(next);
  }
  public function toClusterCouple():Cluster<Couple<String,T>>{
    final next = [];
    for(k => v in this){
      next.push(__.couple(k,v));
    }
    return Cluster.lift(next);
  }
}

class EnsembleLift{

}