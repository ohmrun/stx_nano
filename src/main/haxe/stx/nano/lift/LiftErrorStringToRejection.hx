package stx.nano.lift;

class LiftErrorStringToRejection{
  static public function toRejection<E>(self:Error<String>):Rejection<E>{
    return Rejection.lift(self.errate(x -> REFUSE(new ESubsumed(x))));
  }
}
class ESubsumed extends Digest{
  public function new(string){
    super("01FT8HA5MKCMG7X3VW2DQ1YAN2",string);
  }
}