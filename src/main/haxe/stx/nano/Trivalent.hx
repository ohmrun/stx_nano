package stx.nano;

enum TrivalentSum{
  Yay;
  Nay;
  Maybe;
}
abstract Trivalent(TrivalentSum) from TrivalentSum to TrivalentSum{
  public function new(self) this = self;
  static public function lift(self:TrivalentSum):Trivalent return new Trivalent(self);

  public function prj():TrivalentSum return this;
  private var self(get,never):Trivalent;
  private function get_self():Trivalent return lift(this);
}