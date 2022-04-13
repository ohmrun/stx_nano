package stx.nano;

typedef CTRDef<P,R> = P -> R;

@:callable abstract CTR<P,R>(CTRDef<P,R>) from CTRDef<P,R> to CTRDef<P,R>{
  public function new(self) this = self;
  @:noUsing static public function lift<P,R>(self:CTRDef<P,R>):CTR<P,R> return new CTR(self);

  public function prj():CTRDef<P,R> return this;
  private var self(get,never):CTR<P,R>;
  private function get_self():CTR<P,R> return lift(this);

  @:from static public function fromR<P,R>(r:R):CTR<P,R>{
    return lift((_:P) -> r);
  }
}