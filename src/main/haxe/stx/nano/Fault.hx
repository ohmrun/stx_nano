package stx.nano;

abstract Fault(Null<Pos>) from Null<Pos>{
  public function new(self) this = self;
  @:noUsing static public function lift(self:Null<Pos>){
    return new Fault(self);
  }
  inline public function of<E>(data:E):Rejection<E>{
    return Rejection.make(__.option(EXCEPT(data)),None,this);
  }
  inline public function decline<E>(self:Declination<E>):Rejection<E>{
    return Rejection.make(Some(self),None,this);
  }
  inline public function explain<E>(fn:Digests->Digest):Rejection<E>{
    return Rejection.make(Some(REFUSE(fn(__.digests()))),None,this);
  }
}