package stx.nano;


abstract Way(Cluster<String>) from Cluster<String> to Cluster<String>{
  public function new(self) this = self;
  static public function lift(self:Cluster<String>):Way return new Way(self);
  @:noUsing static public function unit():Way{
    return lift(Cluster.unit());
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
  public function concat(that:String):Way{
    return lift(this.snoc(that));
  }
  public function toOsString():String{
    return (Std.downcast(this,Array)).join(__.sep()); 
  }
}