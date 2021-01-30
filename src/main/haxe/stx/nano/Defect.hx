package stx.nano;

@:forward abstract Defect<E>(Array<E>) from Array<E> to Array<E>{
  @:noUsing static public function unit<E>():Defect<E>{
    return [];
  }
  @:noUsing static public function pure<E>(e:E):Defect<E>{
    return [e];
  }
  @:to public inline function toErr():Err<E>{
    return Err.grow(this);
  }
  @:from static public function fromErr<E>(err:Err<E>):Defect<E>{
    return err.data.flat_map(
      (x) -> switch(x){
        case ERR_OF(e)  : Some(e);
        default         : None;
      }
    ).toArray();
  }
  public function elide():Defect<Dynamic>{
    return this;
  }
  public function entype<E>():Defect<E>{
    return cast this;
  }
  public function concat(that:Defect<E>):Defect<E>{
    return this.concat(that);
  }
}