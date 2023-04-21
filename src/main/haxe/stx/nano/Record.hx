package stx.nano;

#if stx_assert
  using stx.Assert;
#end

import haxe.DynamicAccess;

typedef RecordDef<T> = Cluster<Field<Void -> T>>;

@:forward(iterator,length) abstract Record<T>(RecordDef<T>) from RecordDef<T>{
  static public var _(default,never) = RecordLift;

  static public function unit<T>():Record<T>{
    return new Record([].imm());
  }
  @:noUsing static public function lift<T>(self:RecordDef<T>):Record<T>{
    return new Record(self);
  }
  public function new(?self:RecordDef<T>) this = self == null ? [] : self;

  public function size(){
    return this.length;
  }
  public function add(that:Field<Void -> T>):Record<T>{
    return this.concat([that]);
  }
  #if stx_assert
  public function equals(that:Record<T>,with:Eq<T>):Bool{
    return if(this.length != that.size()){
      false;
    }else{
      var ok = true;
      for(v in this){
        var key   = v.key;
        var other = that.get(key);
        switch(other){
          case None       : false;
          case Some(v0)   : 
            if(!with.comply(v.val(),v0()).is_ok()){
              ok = false;
              break;
            } 
        } 
      };
      ok;
    }
  }
  #end
  public function get(key:String):Option<Void -> T>{
    var out = None;
    for(v in this){
      if(v.key == key){
        out = Some(v);
        break;
      }
    }
    return switch(out){
      case Some(v)  : Some(v.val);
      default       : None;
    }
  }
  public function has(key){
    return get(key).map((_) -> true).def(()->false);
  }
  public function fold<U>(fn:Field<Void -> T>->U->U,i:U):U{
    var current = i;
    for(v in this){
      current = fn(v,current);
    }
    return current;
  }
  static public function reduct<T>(){
    return function(next:Field<Void -> T>,memo:Record<T>):Record<T>{
      return memo.add(next);
    }
  }
  public function map<U>(fn:T->U):Record<U>{
    return this.map(
      (fld:Field<Void -> T>) -> fld.map(
        (thk) -> {
          return () -> fn(thk());
        }
      )
    ).lfold(reduct(),new Record());
  }
  public function concat(that:Record<T>):Record<T>{
    return lift(this.concat(that.prj()));
  }
  public function imap<U>(fn:Int->T->U):Record<U>{
    return this.imap(
      (i,fld) -> fld.map(
        (thk) -> {
          return () -> fn(i,thk());
        }
      )
    ).lfold(reduct(),new Record());
  }
  @:from static public function fromUnderlying<T>(arr:Cluster<Field<Void -> T>>){
    return new Record(arr);
  }
  @:from static public function fromMap<T>(self:Map<String,T>){
    var arr = [];
    for(key => val in self){
      arr.push(stx.Field.make(key,() -> val));
    }
    return new Record(Cluster.lift(arr));
  }
  public function prj():Cluster<Field<Void -> T>>{
    return this;
  }
  public function toCluster():Cluster<Field<Void -> T>>{
    return this;
  }
  
}
class RecordLift{
  #if (stx_assert || stx)
  static public function ord<T>(inner:Ord<T>):Ord<Record<T>>{
    return new stx.assert.ord.term.Record(inner);
  }
  static public function eq<T>(inner):Eq<Record<T>>{
    return new stx.assert.eq.term.Record(inner);
  }
  #end
}