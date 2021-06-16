package stx.nano;

import haxe.Constraints.IMap;

typedef ClusterDef<T> = Array<T>; 

@:using(stx.nano.Cluster.ClusterLift)
abstract Cluster<T>(ClusterDef<T>) from ClusterDef<T> to ClusterDef<T>{
  public function new(self) this = self;
  static public function lift<T>(self:ClusterDef<T>):Cluster<T> return new Cluster(self);

  public function prj():ClusterDef<T> return this;
  private var self(get,never):Cluster<T>;
  private function get_self():Cluster<T> return lift(this);
}
class ClusterLift{
  static public var _(default,never) = stx.lift.ArrayLift;
  static public inline function lift<T>(self:Array<T>):Cluster<T> return Cluster.lift(self); 
  
  static public function flatten<T>(self:Array<Array<T>>):Cluster<T>                                                      return lift(_.flatten(self));
  static public function interleave<T>(self: StdArray<StdArray<T>>):Cluster<T>                                            return lift(_.interleave(self));
  static public inline function is_defined<T>(self:StdArray<T>):Bool                                                      return      _.is_defined(self);
  static public function cons<T>(self:StdArray<T>,t:T):Cluster<T>                                                         return lift(_.cons(self,t));
  static public function snoc<T>(self:StdArray<T>,t:T):Cluster<T>                                                         return lift(_.snoc(self,t));
  static public inline function set<T>(self:StdArray<T>,i:Int,v:T):Cluster<T>                                             return lift(_.set(self,i,v));
  static public inline function get<T>(self:StdArray<T>,i:Int):T                                                          return      _.get(self,i);
  static public function head<T>(self:StdArray<T>):Option<T>                                                              return      _.head(self);
  static public function tail<T>(self:StdArray<T>):Cluster<T>                                                             return lift(_.tail(self));
  static public function last<T>(self:StdArray<T>):Option<T>                                                              return      _.last(self);
  static public function copy<T>(self:StdArray<T>):Cluster<T>                                                             return lift(_.copy(self));
  static public function concat<T>(self:StdArray<T>,that:Iterable<T>):Cluster<T>                                          return lift(_.concat(self,that));
  static public function bind_fold<T,Ti,TT>(self:StdArray<T>,pure:Ti->TT,init:Ti,bind:TT->(Ti->TT)->TT,fold:T->Ti->Ti):TT return      _.bind_fold(self,pure,init,bind,fold);
  static public function reduce<T,TT>(self:StdArray<T>,unit:Void->TT,pure:T->TT,plus:TT->TT->TT):TT                       return      _.reduce(self,unit,pure,plus);
  static public function map<T,TT>(self:StdArray<T>,fn:T->TT):Cluster<TT>                                                 return lift(_.map(self,fn));
  static public function mapi<T,TT>(self:StdArray<T>,fn:Int->T->TT):Cluster<TT>                                           return lift(_.mapi(self,fn));
  static public function flat_map<T,TT>(self:StdArray<T>,fn:T->Iterable<TT>):Cluster<TT>                                  return lift(_.flat_map(self,fn));
  static public function lfold<T,TT>(self:StdArray<T>,fn:T->TT->TT,memo:TT):TT                                            return      _.lfold(self,fn,memo);
  static public function lfold1<T>(self:StdArray<T>,fn:T->T->T):Option<T>                                                 return      _.lfold1(self,fn);
  static public function rfold<T,TT>(self:StdArray<T>,fn:T->TT->TT,z:TT):TT                                               return      _.rfold(self,fn,z);
  static public function rfold1<T>(self:StdArray<T>,fn:T->T->T):Option<T>                                                 return      _.rfold1(self,fn);
  static public function lscan<T>(self:StdArray<T>,f: T -> T -> T,init: T):Cluster<T>                                     return lift(_.lscan(self,f,init));
  static public function lscan1<T>(self:StdArray<T>,f: T -> T -> T):Cluster<T>                                            return lift(_.lscan1(self,f));
  static public function rscan<T>(self:StdArray<T>,init: T, f: T -> T -> T):Cluster<T>                                    return lift(_.rscan(self,init,f));
  static public function rscan1<T>(self:StdArray<T>,fn: T -> T -> T):Cluster<T>                                           return lift(_.rscan1(self,fn));
  static public function filter<T>(self:StdArray<T>,fn:T->Bool):Cluster<T>                                                return lift(_.filter(self,fn));
  static public function map_filter<T,TT>(self:StdArray<T>,fn:T->Option<TT>):Cluster<TT>                                  return lift(_.map_filter(self,fn));
  static public function whilst<T>(self:StdArray<T>,fn:T->Bool):Cluster<T>                                                return lift(_.whilst(self,fn));

  static public function ltaken<T>(self:StdArray<T>,n):Cluster<T>                                                         return lift(_.ltaken(self,n));
  static public function ldropn<T>(self:StdArray<T>,n):Cluster<T>                                                         return lift(_.ldropn(self,n));
  static public function rdropn<T>(self:StdArray<T>,n:Int):Cluster<T>                                                     return lift(_.rdropn(self,n));
  static public inline function ldrop<T>(self: StdArray<T>, p: T -> Bool):Cluster<T>                                      return lift(_.ldrop(self,p));
  static public function search<T>(self:StdArray<T>,fn:T->Bool):Option<T>                                                 return      _.search(self,fn);
  static public function all<T>(self:StdArray<T>,fn:T->Bool):Bool                                                         return      _.all(self,fn);
  static public function any<T>(self:StdArray<T>,fn:T->Bool): Bool                                                        return      _.any(self,fn);
  static public function zip_with<T,Ti,TT>(self:StdArray<T>,that:StdArray<Ti>,fn:T->Ti->TT):Cluster<TT>                   return lift(_.zip_with(self,that,fn));
  static public function cross_with<T,Ti,TT>(self :Array<T>, that :Array<Ti>,fn : T -> Ti -> TT):Cluster<TT>              return lift(_.cross_with(self,that,fn));
  static public function difference_with<T>(self:Array<T>, that:Array<T>,eq:T->T->Bool)                                   return lift(_.difference_with(self,that,eq));
  static public inline function union_with<T>(self:Array<T>, that:Array<T>,eq:T->T->Bool)                                 return lift(_.union_with(self,that,eq));
  static public function unique_with<T>(self:StdArray<T>,eq:T->T->Bool):Cluster<T>                                        return lift(_.unique_with(self,eq));
  static public function nub_with<T>(self:StdArray<T>,f: T -> T -> Bool):Cluster<T>                                       return lift(_.nub_with(self,f));
  static public inline function intersect_with<T>(self: StdArray<T>, that: StdArray<T>,f: T -> T -> Bool):Cluster<T>      return lift(_.intersect_with(self,that,f));
  static public inline function reversed<T>(self: StdArray<T>):Cluster<T>                                                 return lift(_.reversed(self));
  static public inline function count<T>(self: StdArray<T>, fn: T -> Bool): Int                                           return      _.count(self,fn);
  static public inline function size<T>(self: StdArray<T>): Int                                                           return      _.size(self);
  static public inline function index_of<T>(self: StdArray<T>, t: T->Bool): Int                                           return      _.index_of(self,t);
  static public inline function has<T>(self: StdArray<T>,obj:T): Option<Int>                                              return      _.has(self,obj);
  static public inline function partition<T>(self: StdArray<T>,f: T -> Bool): { a : StdArray<T>, b :  StdArray<T> }       return      _.partition(self,f);
  static public function chunk<T>(self : StdArray<T>, size : StdArray<Int>) :Array<Array<T>>                              return lift(_.chunk(self,size));
  static public function pad<T>(self:StdArray<T>,len:Int,?val:T):Cluster<T>                                               return lift(_.pad(self,len,val));
  static public inline function fill<T>(self:StdArray<T>,def:T):Cluster<T>                                                return lift(_.fill(self,def));
  static public function toIterable<T>(self:StdArray<T>):Iterable<T>                                                      return      _.toIterable(self);
  static public inline function toMap<T>(self:StdArray<Void -> { a : String, b : T }>):Map<String,T>                      return      _.toMap(self);
  static public function random<T>(self:StdArray<T>):Null<T>                                                              return      _.random(self);
  static public function shuffle<T>(self: StdArray<T>):Cluster<T>                                                         return      _.shuffle(self);
  static public function and_with<T>(self:Array<T>,that:Array<T>,eq:T->T->Bool):Bool                                      return      _.and_with(self,that,eq);
  static public function rotate<T>(self:Array<T>,i:Int):Cluster<T>                                                        return lift(_.rotate(self,i));
  static public function iterator<T>(self:StdArray<T>):Iterator<T>                                                        return      _.iterator(self);
  static public function elide<T>(self:StdArray<T>):Cluster<Dynamic>                                                      return map(self,(v) -> (v:Dynamic));
}