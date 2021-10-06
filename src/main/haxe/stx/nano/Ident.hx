package stx.nano;

typedef IdentDef = {
  final name    : String;
  final ?pack   : Way; 
}

@:forward abstract Ident(IdentDef) from IdentDef to IdentDef{
  public function new(self) this = self;
  static public function lift(self:IdentDef):Ident return new Ident(self);

  public function prj():IdentDef return this;
  private var self(get,never):Ident;
  private function get_self():Ident return lift(this);

  public function toWay():Way{
    return (this.pack == null).if_else(
      () -> Way.unit().snoc(this.name),
      () -> this.pack.snoc(this.name) 
    );
  }
}