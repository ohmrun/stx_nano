package stx.core.pack;

abstract Fault(Pos) from Pos{
  public function new(self) this = self;
  inline public function of<E>(data:E, ?code):Err<E>{
    return new Err(__.option(ERR_OF(data)),None,this);
  }
  inline public function empty<E>():Err<E>{
    return new Err(None,None,this);
}
  inline public function any<E>(msg:String):Err<E>{
    return new Err(ERR(FailCode.fromString(msg)),null,this);
  }
  inline public function failure<E>(failure:Failure<Dynamic>):Err<E>{
    return new Err(Some(failure),null,this);
  }
  inline public function err<E>(code:FailCode):Err<E>{
    return new Err(Some(ERR(code)),null,this);
  }
}