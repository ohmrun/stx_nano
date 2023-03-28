package stx.nano;

typedef RosterDef<T> = Dynamic<T>;

/**
 * Slim abstract over `Dynamic<T>` with a getter.
 */
@:pure abstract Roster<T>(RosterDef<T>) from RosterDef<T> to RosterDef<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:RosterDef<T>):Roster<T> return new Roster(self);

  @:arrayAccess
  public function get(key:String):T{
    return (this:haxe.DynamicAccess<T>).get(key);
  }
  public function prj():RosterDef<T> return this;
  private var self(get,never):Roster<T>;
  private function get_self():Roster<T> return lift(this);
}