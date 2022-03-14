package stx.nano;

@:forward(length,join,tail,head,concat) abstract Way(Cluster<String>) from Cluster<String> to Cluster<String>{
  public function new(self) this = self;
  static public function lift(self:Cluster<String>):Way return new Way(self);

  @:op([]) static function array_access(self:Way, idx:Int):String;
  @:noUsing static public function unit():Way{
    return lift(Cluster.unit());
  }
  @:noUsing inline static public function fromArray(self:Array<String>){
    return lift(Cluster.lift(self));
  }
  @:noUsing static public function fromString(self:String){
    return lift(self.split(__.sep()));
  }
  public function prj():Cluster<String> return this;
  private var self(get,never):Way;
  private function get_self():Way return lift(this);

  public function snoc(that:String):Way{
    return lift(this.snoc(that));
  }
  public function concat(that:Array<String>):Way{
    return lift(this.concat(that));
  }
  public function toOsString():String{
    return (Std.downcast(this,Array)).join(__.sep()); 
  }
  @:arrayAccess
  public inline function get(i:Int){
    return this[i];
  }
  @:to public function toArray():Array<String>{
    return Std.downcast(this,Array);
  }
}