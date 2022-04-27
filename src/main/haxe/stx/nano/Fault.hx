package stx.nano;

abstract Fault(Null<Pos>) from Null<Pos>{
  public function new(self) this = self;
  @:noUsing static public function lift(self:Null<Pos>){
    return new Fault(self);
  }
  inline public function of<E>(data:E):Refuse<E>{
    return Refuse.make(__.option(EXTERIOR(data)),None,this);
  }
  inline public function decline<E>(self:Decline<E>):Refuse<E>{
    return Refuse.make(Some(self),None,this);
  }
  inline public function explain<E>(fn:Digests->Digest):Refuse<E>{
    return Refuse.make(Some(INTERIOR(fn(__.digests()))),None,this);
  }
  inline public function digest(fn:Digests->Digest):Error<Digest>{
    return Error.make(Some(fn(__.digests())),None,this);
  }
}