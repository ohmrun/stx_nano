package stx.nano;

typedef Defect<E> = {
  final error : Cluster<E>;
}
@:using(stx.nano.Defect.DefectLift)
@:forward abstract Defect<E>(DefectDef<E>) from DefectDef<E> to DefectDef<E>{
  static public var _(default,never) = DefectLift;
  public function new(self:Cluster<E>){
    this = self;
  }
  @:noUsing static public function lift<E>(self:DefectDef<E>){
    return new Defect(self);
  }
  @:noUsing static public function unit<E>():Defect<E>{
    return lift({ error : Cluster.unit() });
  }
  @:noUsing static public function pure<E>(e:E):Defect<E>{
    return make(Cluster.lift([e]));
  }
  @:noUsing static public function make<E>(?data:Cluster<E>){
    return __.option(data).map(x -> { error : lift(x)) } .def(unit);
  }
  @:to public inline function toErr():Err<E>{
    return Err.grow(this);
  }
  @:from static public function fromErr<E>(err:Err<E>):Defect<E>{
    return make(Iter.lift(err).toCluster().map_filter(
      (x) -> switch(x.data){
        case Some(ERR_OF(e))  : Some(e);
        default               : None;
      }
    ));
  }
  public function elide():Defect<Dynamic>{
    return this;
  }
  public function entype<E>():Defect<E>{
    return cast this;
  }
  @:to public function toError(){
    return {
      
    }  
  }
}
class DefectLift{
  static public function concat<E>(self:Defect<E>,that:Defect<E>):Defect<E>{
    return { error : self.error.concat(that.error) };
  }
  static public function errate<E,EE>(self:Defect<E>,fn:E->EE):Defect<EE>{
    return Defect.make(self.error.map(fn));
  }
}