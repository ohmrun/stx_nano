package stx.nano;

/**
 * Base type for error building capabilities of the `stx.nano.Wildcard` static extension.
 * ```haxe
 * __.fault()
 * ```
 */
abstract Fault(Null<Pos>) from Null<Pos>{
  public function new(self) this = self;
  
  /**
   * Lift function for Fault
   * @see https://github.com/ohmrun/docs/blob/main/conventions.md#lift
   * @param self 
   */
  @:stx.code.construct.lift
  @:noUsing static public function lift(self:Null<Pos>){
    return new Fault(self);
  }
  /**
   * Turns any value of type `E` into a `Refuse<E>`
   * @param fn 
   * @return Refuse<E>
   */
  inline public function of<E>(data:E):Refuse<E>{
    return Refuse.make(__.option(EXTERNAL(data)),None,this);
  }
  inline public function decline<E>(self:Decline<E>):Refuse<E>{
    return Refuse.make(Some(self),None,this);
  }
  inline public function explain<E>(fn:CTR<Digests,Digest>):Refuse<E>{
    return Refuse.make(Some(INTERNAL(fn.apply(__.digests()))),None,this);
  }
  inline public function digest(fn:CTR<Digests,Digest>):Error<Digest>{
    return Error.make(Some(fn(__.digests())),None,this);
  }
}