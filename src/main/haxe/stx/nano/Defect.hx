package stx.nano;

@:pure typedef DefectDef<E> = {
  public var error(get,null) : Iter<E>;
  public function get_error():Iter<E>;

  public function toDefect():DefectDef<E>;
}
@:pure interface DefectApi<E>{
  public var error(get,null) : Iter<E>;
  public function get_error():Iter<E>;
  public function toDefect():DefectDef<E>;
}
@:pure class DefectCls<E> implements DefectApi<E>{
  public var error(get,null) : Iter<E>;
  public function get_error():Iter<E>{ 
    return error;
  }
  public function new(error){
    this.error = error;
  }
  public function toDefect():DefectDef<E>{
    return this;
  }
}
@:using(stx.nano.Defect.DefectLift)
@:forward abstract Defect<E>(DefectDef<E>) from DefectDef<E> to DefectDef<E>{
  static public var _(default,never) = DefectLift;
  public function new(self:DefectDef<E>){
    this = self;
  }
  @:noUsing static public function lift<E>(self:DefectDef<E>){
    return new Defect(self);
  }
  @:noUsing static public function unit<E>():Defect<E>{
    return lift(new DefectCls(Iter.unit()));
  }
  @:noUsing static public function pure<E>(e:E):Defect<E>{
    return make(Iter.lift([e]));
  }
  @:noUsing static public function make<E>(?data:Iter<E>){
    return __.option(data).map((x:Iter<E>) -> lift(new DefectCls(x))).def(unit);
  }
  @:to public inline function toErr():Err<E>{
    return Err.grow(this.error.toCluster());
  }
  public inline function toErrHere(?pos:Pos):Err<E>{
    return Err.grow(this.error.toCluster(),pos);
  }
  @:from static public function fromErr<E>(err:Err<E>):Defect<E>{
    return make(Iter.lift(err).map_filter(
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
    return new stx.nano.error.term.DefectError(this.error).toError();
  }
}
class DefectLift{
  static public function concat<E>(self:Defect<E>,that:Defect<E>):Defect<E>{
    return Defect.make(self.error.concat(that.error));
  }
  static public function errate<E,EE>(self:Defect<E>,fn:E->EE):Defect<EE>{
    return Defect.make(self.error.map(fn));
  }
}