package stx.core.pack.couple;

class Constructor extends Clazz{
  static public var ZERO(default,never)   = new Constructor();
  public var _(default,never)             = new Destructure();
  
  #if thx_core
    public function fromThxTuple<Pi,Pii>(tup:ThxTuple<Pi,Pii>):Couple<Pi,Pii>{
      return (cb) -> cb(tup._0,tup._1);
    }

    public function toThxTuple<Pi,Pii>(tup:Couple<Pi,Pii>):ThxTuple<Pi,Pii>{
      return new ThxTuple(fst(tup),snd(tup));
    }
  #end
}