package stx.nano;

@:pure typedef DefectDef<E> = {
  public var error(get,null):Errata<E>;
  public function get_error():Errata<E>;

  public function toDefect():Defect<E>;
}
@:pure interface DefectApi<E>{
  public var error(get,null):Errata<E>;
  public function get_error():Errata<E>;
  public function toDefect():Defect<E>;
}
@:pure class DefectCls<E> implements DefectApi<E>{
  public var error(get,null):Errata<E>;
  public function get_error():Errata<E>{ 
    return error;
  }
  public function new(error:Errata<E>){
    this.error = __.option(error).def(Errata.unit);
  }
  public function toDefect():Defect<E>{
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
    return lift(new DefectCls(Errata.unit()));
  }
  @:noUsing static public function pure<E>(e:E):Defect<E>{
    return make(Errata.lift([e]));
  }
  @:noUsing static public function make<E>(?data:Errata<E>){
    return __.option(data).map((x:Errata<E>) -> lift(new DefectCls(x))).def(unit);
  }
  public inline function toErrorAt(?pos:Pos):Error<E>{
    return Errata._.toErrorAt(this.error,pos);
  }
  // @:from static public function fromRejection<E>(err:Rejection<E>):Defect<E>{
  //   return make(Errata.lift(err).map_filter(
  //     (x) -> switch(x){
  //       case REJECT(e)        : Some(e);
  //       default               : None;
  //     }
  //   ));
  // }
  @:from static public function fromError<E>(self:Error<E>):Defect<E>{
    return Defect.make(Errata.lift(self));
  }
  public function elide():Defect<Dynamic>{
    return this;
  }
  public function entype<E>():Defect<E>{
    return cast this;
  }
  @:to public function toError():Error<E>{
    return this.error.toError();
  }
  public function prj():DefectDef<E>{
    return this;
  }
}
class DefectLift{
  static public function concat<E>(self:Defect<E>,that:Defect<E>):Defect<E>{
    return Defect.make(self.error.concat(that.error));
  }
  static public function errate<E,EE>(self:Defect<E>,fn:E->EE):Defect<EE>{
    return Defect.make(self.error.errata(e -> e.errate(fn)));
  }
}