package stx.nano;

@:using(stx.nano.Defect.DefectLift)
@:forward abstract Defect<E>(Cluster<E>) from Cluster<E> to Cluster<E>{
  static public var _(default,never) = DefectLift;
  public function new(self:Cluster<E>){
    this = self;
  }
  @:noUsing static public function lift<E>(self:Cluster<E>){
    return new Defect(self);
  }
  @:noUsing static public function unit<E>():Defect<E>{
    return lift(Cluster.unit());
  }
  @:noUsing static public function pure<E>(e:E):Defect<E>{
    return lift(Cluster.lift([e]));
  }
  @:noUsing static public function make<E>(?data:Cluster<E>){
    return __.option(data).map(lift).def(unit);
  }
  @:to public inline function toErr():Err<E>{
    return Err.grow(this);
  }
  @:from static public function fromErr<E>(err:Err<E>):Defect<E>{
    return Iter.lift(err).toCluster().map_filter(
      (x) -> switch(x.data){
        case Some(ERR_OF(e))  : Some(e);
        default               : None;
      }
    );
  }
  public function elide():Defect<Dynamic>{
    return this;
  }
  public function entype<E>():Defect<E>{
    return cast this;
  }
}
class DefectLift{
  static public function concat<E>(self:Defect<E>,that:Defect<E>):Defect<E>{
    return self.concat(that);
  }
  static public function errate<E,EE>(self:Defect<E>,fn:E->EE):Defect<EE>{
    return self.map(fn);
  }
}