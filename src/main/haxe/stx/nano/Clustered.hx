package stx.nano;

@:allow(stx)
@:using(stx.nano.Cluster.ClusterLift)
abstract Clustered<T>(Array<T>) from Array<T> to Array<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:Array<T>):Clustered<T> return new Clustered(self);

  public function prj():Array<T> return this;
  private var self(get,never):Clustered<T>;
  private function get_self():Clustered<T> return lift(this);

 @:to public function toCluster(){
   return Cluster.lift(this);
 }
 @:noUsing @:from static public function fromT<T>(v:T){
   return lift(Cluster.pure(v).prj());
 }
}