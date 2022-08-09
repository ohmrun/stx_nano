package stx.nano;

enum TrivalentSum{
  Nay;
  Maybe;
  Yay;
}
abstract Trivalent(TrivalentSum) from TrivalentSum to TrivalentSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:TrivalentSum):Trivalent return new Trivalent(self);

  public function prj():TrivalentSum return this;
  private var self(get,never):Trivalent;
  private function get_self():Trivalent return lift(this);

  @:from static public function fromBool(b:Bool):Trivalent{
    return b ? Yay : Nay;
  }

  @:op(A && B)
  public function and(that:Trivalent){
    switch([this,that]){
      case [Yay,Yay]      : Yay;
      case [Nay,Nay]      : Nay;
      case [Maybe,Maybe]  : Maybe;
      default             : Maybe;
    }
  }
  @:op(A || B)
  public function or(that:Trivalent){
    switch([this,that]){
      case [Yay,Yay]      : Yay;
      case [Nay,Nay]      : Nay;
      case [Nay,Yay]      : Yay;
      case [Yay,Nay]      : Yay;
      case [Maybe,Nay]    : Maybe;
      case [Nay,Maybe]    : Maybe;
      case [Maybe,Maybe]  : Maybe;
      case [Maybe,Yay]    : Yay;
      case [Yay,Maybe]    : Yay;
    }
  }
}