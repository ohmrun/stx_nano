package stx.nano.lift;

class LiftErrorStringToRefuse{
  static public function toRefuse<E>(self:Error<String>):Refuse<E>{
    return Refuse.lift(self.errate(x -> INTERIOR(new ESubsumed(x))));
  }
}
class ESubsumed extends Digest{
  public function new(string){
    super("01FT8HA5MKCMG7X3VW2DQ1YAN2",string);
  }
}