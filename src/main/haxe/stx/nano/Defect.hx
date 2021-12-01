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
  public inline function toErrorHere(?pos:Pos):Error<E>{
    return this.error.tail().lfold(
      (next:E,memo:Error<E>) -> Error.make(__.option(next),Some(memo),pos),
      Error.make(this.error.head(),None,pos)
    );
  }
  @:from static public function fromException<E>(err:Exception<E>):Defect<E>{
    return make(Iter.lift(err.content()).map_filter(
      (x) -> switch(x){
        case EXCEPT(e)        : Some(e);
        default               : None;
      }
    ));
  }
  @:from static public function fromError<E>(self:Error<E>):Defect<E>{
    return Defect.make(self.content());
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