package stx.nano;

@:pure typedef DefectDef<E> = {
  public var error(get,null):Refuse<E>;
  public function get_error():Refuse<E>;

  public function toDefect():Defect<E>;

  public function raise():Void;
}
@:pure interface DefectApi<E>{
  public var error(get,null):Refuse<E>;
  public function get_error():Refuse<E>;
  public function toDefect():Defect<E>;


  public function raise():Void;
}
@:pure class DefectCls<E> implements DefectApi<E>{
  public var error(get,null):Refuse<E>;
  public function get_error():Refuse<E>{ 
    return error;
  }
  public function new(error:Refuse<E>){
    this.error = __.option(error).def(Refuse.unit);
  }
  public function toDefect():Defect<E>{
    return this;
  }
  public function raise():Void{
    throw this;
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
    return lift(new DefectCls(Refuse.unit()));
  }
  @:noUsing static public function pure<E>(e:E):Defect<E>{
    return make(Refuse.pure(e));
  }
  @:noUsing static public function make<E>(?data:Refuse<E>){
    return __.option(data).map((x:Refuse<E>) -> lift(new DefectCls(x))).def(unit);
  }
  // public inline function toRefuseAt(?pos:Pos):RefuseAt<E>{
  //   return Refuse._.toRefuse(this.error,pos);
  // }
  @:from static public function fromRefuse<E>(self:Refuse<E>):Defect<E>{
    return Defect.make(Refuse.lift(self));
  }
  public function elide():Defect<Dynamic>{
    return this;
  }
  public function entype<E>():Defect<E>{
    return cast this;
  }
  @:to public function toRefuse():Refuse<E>{
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
  // static public function errate<E,EE>(self:Defect<E>,fn:E->EE):Defect<EE>{
  //   return Defect.make(self.error.errata(e -> e.errate(fn)));
  // }
  static public function has_error<E>(self:Defect<E>):Bool{
    return self.error.is_defined();
  }
}