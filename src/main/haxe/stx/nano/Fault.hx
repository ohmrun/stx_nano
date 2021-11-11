package stx.nano;

abstract Fault(Null<Pos>) from Null<Pos>{
  public function new(self) this = self;
  @:noUsing static public function lift(self:Null<Pos>){
    return new Fault(self);
  }
  inline public function of<E>(data:E):Err<E>{
    return new Err(__.option(ERR_OF(data)),None,this);
  }
  inline public function empty<E>():Err<E>{
    return new Err(None,None,this);
  }
  @:deprecated
  inline public function any<E>(msg:String):Err<E>{
    return new Err(ERR(FailCode.fromString(msg)),null,this);
  }
  inline public function external<E>(msg:String):Err<E>{
    return new Err(ERR(FailCode.fromString(msg)),null,this);
  }
  inline public function failure<E>(failure:Failure<Dynamic>):Err<E>{
    return new Err(Some(failure),null,this);
  }
  inline public function internal<E>(code:FailCode):Err<E>{
    return new Err(Some(ERR(code)),null,this);
  }
  @:deprecated
  inline public function code<E>(code:FailCode):Err<E>{
    return new Err(Some(ERR(code)),null,this);
  }
  @:deprecated
  inline public function err<E>(code:FailCode):Err<E>{
    return new Err(Some(ERR(code)),null,this);
  }
}