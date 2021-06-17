package stx.nano;

import haxe.Constraints.IMap;

typedef ClusterDef<T> = ClusterCls<T>;
private class ClusterCls<T>{
  public var length(get, never):Int;
  function get_length(){
    return entries.length;
  }
  private final entries  : Array<T>;
  public function new(entries:Array<T>){
    this.entries = entries;
  }
  public function fmap<TT>(fn:Array<T>->Array<TT>):Cluster<TT>{
    return new ClusterCls(fn(this.entries));
  }
  public function accs<TT>(fn:Array<T>->TT):TT{
    return fn(this.entries);
  }
  public function iterator():Iterator<T>{
    return this.entries.iterator();
  }
}

//@:using(stx.nano.Cluster.ClusterLift)
@:pure @:forward(fmap,accs,iterator) abstract Cluster<T>(ClusterDef<T>) from ClusterDef<T>{
  static public var _(default,never) = ClusterLift;
  public function new(self) this = self;
  static public function lift<T>(self:ClusterDef<T>):Cluster<T> return new Cluster(self);
  @:from static public function fromArray<T>(self:Array<T>):Cluster<T>{
<<<<<<< Updated upstream
    return lift(new ClusterCls(self));
=======
    return lift(self.copy());
>>>>>>> Stashed changes
  }
  static public function unit<T>():Cluster<T>{
    return lift(new ClusterCls([]));
  } 
  @:to public function toIterable():Iterable<T>{
    return this;
  }
<<<<<<< Updated upstream
  public function concat(that){
    return _.concat(lift(this),that);
  }
  public function copy(){
    return _.copy(this);
  }
  public function snoc(v){
    return _.snoc(this,v);
  }
  public function cons(v){
    return _.cons(this,v);
=======
  public function concat(that:Cluster<T>){
    return lift(this.concat(Std.downcast(that,Array)));
  }
  public function copy(){
    return lift(this.copy());
>>>>>>> Stashed changes
  }
}
class ClusterLift{
  static public var _(default,never) = stx.lift.ArrayLift;
  static public inline function lift<T>(self:ClusterDef<T>):Cluster<T> return Cluster.lift(self); 
<<<<<<< Updated upstream
  static public inline function fmap<T,TT>(self:Cluster<T>,fn:Array<T>->Array<TT>):Cluster<TT> return self.fmap(fn); 
  static public inline function accs<T,TT>(self:Cluster<T>,fn:Array<T>->TT):TT return self.accs(fn); 
=======
  static public inline function fmap<T,TT>(self:Cluster<T>,fn:Array<T>->Array<TT>):Cluster<TT> return lift(fn(Std.downcast(self,Array))); 
  static public inline function accs<T,TT>(self:Cluster<T>,fn:Array<T>->TT):TT return fn(Std.downcast(self,Array)); 
>>>>>>> Stashed changes

  static public function flatten<T>(self:Cluster<Array<T>>):Cluster<T>                                                    return fmap(self,_.flatten);
  static public function interleave<T>(self:Cluster<Array<T>>):Cluster<T>                                                 return fmap(self,_.interleave);
  static public inline function is_defined<T>(self:Cluster<T>):Bool                                                       return accs(self,_.is_defined);
  static public function cons<T>(self:Cluster<T>,t:T):Cluster<T>                                                          return fmap(self,_.cons.bind(_,t));
  static public function snoc<T>(self:Cluster<T>,t:T):Cluster<T>                                                          return fmap(self,_.snoc.bind(_,t));
  static public inline function set<T>(self:Cluster<T>,i:Int,v:T):Cluster<T>                                              return fmap(self,_.set.bind(_,i,v));
  static public inline function get<T>(self:Cluster<T>,i:Int):T                                                           return accs(self,_.get.bind(_,i));
  static public function head<T>(self:Cluster<T>):Option<T>                                                               return accs(self,_.head);
  static public function tail<T>(self:Cluster<T>):Cluster<T>                                                              return fmap(self,_.tail);
  static public function last<T>(self:Cluster<T>):Option<T>                                                               return accs(self,_.last);
  static public function copy<T>(self:Cluster<T>):Cluster<T>                                                              return fmap(self,_.copy);
  static public function concat<T>(self:Cluster<T>,that:Iterable<T>):Cluster<T>                                           return fmap(self,_.concat.bind(_,that));
  static public function bind_fold<T,Ti,TT>(self:Cluster<T>,pure:Ti->TT,init:Ti,bind:TT->(Ti->TT)->TT,fold:T->Ti->Ti):TT  return accs(self,_.bind_fold.bind(_,pure,init,bind,fold));
  static public function reduce<T,TT>(self:Cluster<T>,unit:Void->TT,pure:T->TT,plus:TT->TT->TT):TT                        return accs(self,_.reduce.bind(_,unit,pure,plus));
  static public function map<T,TT>(self:Cluster<T>,fn:T->TT):Cluster<TT>                                                  return fmap(self,_.map.bind(_,fn));
  static public function mapi<T,TT>(self:Cluster<T>,fn:Int->T->TT):Cluster<TT>                                            return fmap(self,_.mapi.bind(_,fn));
  static public function flat_map<T,TT>(self:Cluster<T>,fn:T->Iterable<TT>):Cluster<TT>                                   return fmap(self,_.flat_map.bind(_,fn));
  static public function lfold<T,TT>(self:Cluster<T>,fn:T->TT->TT,memo:TT):TT                                             return accs(self,_.lfold.bind(_,fn,memo));
  static public function lfold1<T>(self:Cluster<T>,fn:T->T->T):Option<T>                                                  return accs(self,_.lfold1.bind(_,fn));
  static public function rfold<T,TT>(self:Cluster<T>,fn:T->TT->TT,z:TT):TT                                                return accs(self,_.rfold.bind(_,fn,z));
  static public function rfold1<T>(self:Cluster<T>,fn:T->T->T):Option<T>                                                  return accs(self,_.rfold1.bind(_,fn));
  static public function lscan<T>(self:Cluster<T>,f: T -> T -> T,init: T):Cluster<T>                                      return fmap(self,_.lscan.bind(_,f,init));
  static public function lscan1<T>(self:Cluster<T>,f: T -> T -> T):Cluster<T>                                             return fmap(self,_.lscan1.bind(_,f));
  static public function rscan<T>(self:Cluster<T>,init: T, f: T -> T -> T):Cluster<T>                                     return fmap(self,_.rscan.bind(_,init,f));
  static public function rscan1<T>(self:Cluster<T>,fn: T -> T -> T):Cluster<T>                                            return fmap(self,_.rscan1.bind(_,fn));
  static public function filter<T>(self:Cluster<T>,fn:T->Bool):Cluster<T>                                                 return fmap(self,_.filter.bind(_,fn));
  static public function map_filter<T,TT>(self:Cluster<T>,fn:T->Option<TT>):Cluster<TT>                                   return fmap(self,_.map_filter.bind(_,fn));
  static public function whilst<T>(self:Cluster<T>,fn:T->Bool):Cluster<T>                                                 return fmap(self,_.whilst.bind(_,fn));

  static public function ltaken<T>(self:Cluster<T>,n):Cluster<T>                                                          return fmap(self,_.ltaken.bind(_,n));
  static public function ldropn<T>(self:Cluster<T>,n):Cluster<T>                                                          return fmap(self,_.ldropn.bind(_,n));
  static public function rdropn<T>(self:Cluster<T>,n:Int):Cluster<T>                                                      return fmap(self,_.rdropn.bind(_,n));
  static public inline function ldrop<T>(self:Cluster<T>, p: T -> Bool):Cluster<T>                                        return fmap(self,_.ldrop.bind(_,p));
  static public function search<T>(self:Cluster<T>,fn:T->Bool):Option<T>                                                  return accs(self,_.search.bind(_,fn));
  static public function all<T>(self:Cluster<T>,fn:T->Bool):Bool                                                          return accs(self,_.all.bind(_,fn));
  static public function any<T>(self:Cluster<T>,fn:T->Bool): Bool                                                         return accs(self,_.any.bind(_,fn));
  static public function zip_with<T,Ti,TT>(self:Cluster<T>,that:Array<Ti>,fn:T->Ti->TT):Cluster<TT>                       return fmap(self,_.zip_with.bind(_,that,fn));
  static public function cross_with<T,Ti,TT>(self :Array<T>, that :Array<Ti>,fn : T -> Ti -> TT):Cluster<TT>              return fmap(self,_.cross_with.bind(_,that,fn));
  static public function difference_with<T>(self:Cluster<T>, that:Array<T>,eq:T->T->Bool)                                 return fmap(self,_.difference_with.bind(_,that,eq));
  static public inline function union_with<T>(self:Cluster<T>, that:Array<T>,eq:T->T->Bool)                               return fmap(self,_.union_with.bind(_,that,eq));
  static public function unique_with<T>(self:Cluster<T>,eq:T->T->Bool):Cluster<T>                                         return fmap(self,_.unique_with.bind(_,eq));
  static public function nub_with<T>(self:Cluster<T>,f: T -> T -> Bool):Cluster<T>                                        return fmap(self,_.nub_with.bind(_,f));
  static public inline function intersect_with<T>(self:Cluster<T>, that: Array<T>,f: T -> T -> Bool):Cluster<T>           return fmap(self,_.intersect_with.bind(_,that,f));
  static public inline function reversed<T>(self:Cluster<T>):Cluster<T>                                                   return fmap(self,_.reversed);
  static public inline function count<T>(self:Cluster<T>, fn: T -> Bool): Int                                             return accs(self,_.count.bind(_,fn));
  static public inline function size<T>(self:Cluster<T>): Int                                                             return accs(self,_.size);
  static public inline function index_of<T>(self:Cluster<T>, t: T->Bool): Int                                             return accs(self,_.index_of.bind(_,t));
  static public inline function has<T>(self:Cluster<T>,obj:T): Option<Int>                                                return accs(self,_.has.bind(_,obj));
  static public inline function partition<T>(self:Cluster<T>,f: T -> Bool): { a : Array<T>, b :  Array<T> }               return accs(self,_.partition.bind(_,f));
  //static public function chunk<T>(self : Array<T>, size : Array<Int>) :Array<Array<T>>                                    return fmap(self,_.chunk.bind(_,size));
  static public function pad<T>(self:Cluster<T>,len:Int,?val:T):Cluster<T>                                                return fmap(self,_.pad.bind(_,len,val));
  static public inline function fill<T>(self:Cluster<T>,def:T):Cluster<T>                                                 return fmap(self,_.fill.bind(_,def));
  static public function toIterable<T>(self:Cluster<T>):Iterable<T>                                                       return accs(self,_.toIterable);
  static public inline function toMap<T>(self:Cluster<Void -> { a : String, b : T }>):Map<String,T>                       return accs(self,_.toMap);
  static public function random<T>(self:Cluster<T>):Null<T>                                                               return accs(self,_.random);
  static public function shuffle<T>(self:Cluster<T>):Cluster<T>                                                           return accs(self,_.shuffle);
  static public function and_with<T>(self:Cluster<T>,that:Array<T>,eq:T->T->Bool):Bool                                    return accs(self,_.and_with.bind(_,that,eq));
  static public function rotate<T>(self:Cluster<T>,i:Int):Cluster<T>                                                      return fmap(self,_.rotate.bind(_,i));
  static public function iterator<T>(self:Cluster<T>):Iterator<T>                                                         return accs(self,_.iterator);
  static public function elide<T>(self:Cluster<T>):Cluster<Dynamic>                                                       return map(self,(v) -> (v:Dynamic));
}