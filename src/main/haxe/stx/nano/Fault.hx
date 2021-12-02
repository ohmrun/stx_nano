package stx.nano;

abstract Fault(Null<Pos>) from Null<Pos>{
  public function new(self) this = self;
  @:noUsing static public function lift(self:Null<Pos>){
    return new Fault(self);
  }
  inline public function of<E>(data:E):Exception<E>{
    return Exception.make(__.option(EXCEPT(data)),None,this);
  }
  inline public function decline<E>(self:Declination<E>):Exception<E>{
    return Exception.make(Some(self),None,this);
  }
  inline public function external<E>(msg:String):Exception<E>{
   return Exception.make(Some(REFUSE(Digest.fromString(msg))),None,this);
  }
  inline public function internal<E>(code:Digest):Exception<E>{
    return Exception.make(Some(REFUSE(code)),None,this);
  }
}