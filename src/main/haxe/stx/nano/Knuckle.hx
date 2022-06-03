package stx.nano;

enum KnuckleSum{
  Ordinal(idx:Register);
  Nominal(str:String,idx:Register);
}
@:using(stx.nano.Knuckle.KnuckleLift)
abstract Knuckle(KnuckleSum) from KnuckleSum to KnuckleSum{
  static public var _(default,never) = KnuckleLift;
  public inline function new(self:KnuckleSum) this = self;
  @:noUsing static inline public function lift(self:KnuckleSum):Knuckle return new Knuckle(self);

  public function prj():KnuckleSum return this;
  private var self(get,never):Knuckle;
  private function get_self():Knuckle return lift(this);

  @:from static public function fromRegister(self:Register){
    return lift(Ordinal(self));
  }
  @:from static public function fromString(self:String){
    return lift(Nominal(self,Register.unit()));
  }
  @:from static public function fromNull(self:Null<Dynamic>){
    return lift(Ordinal(Register.unit()));
  }
  public function toString(){
    return switch(this){
      case Nominal(str,i) : '.${str}@$i';
      case Ordinal(i)     : '[$i]';
    }
  }
  //TODO what's the more general case?
  @:op(A==A)
  public function equals(r:Knuckle):Bool{
    var l = this;
    return switch([l,r]){
      case [Nominal(l,lI),Nominal(r,rI)]  : l == r && lI == rI;
      case [Ordinal(l),Ordinal(r)]        : l == r;
      default                             : false;
    }
  }
}
class KnuckleLift{
  static public inline function lift(self:KnuckleSum):Knuckle{
    return Knuckle.lift(self);
  }
}