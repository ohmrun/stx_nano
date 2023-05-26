package stx.nano.lift;

class LiftOptionNano{
  static public function zip<T,TT>(self:OptionSum<T>,that:OptionSum<TT>):OptionSum<Couple<T,TT>>{
    return switch([self,that]){
      case [Some(l),Some(r)]  : Some(__.couple(l,r));
      default                 : None;
    }
  }
  /**
   * `__.crack()` if `self` is not defined, returns value otherwise.
   * @param self 
   * @param fn 
   * @param pos 
   * @return T
   */
  //TODO (09-05-2023) use CTR
  @stx.fudge
  static public inline function fudge<T,E>(self:Null<Option<T>>,?err:CTR<Fault,Refuse<E>>,?pos:Pos):T{
    final exception = Option.make(err).defv(__.fault().explain(_ -> _.e_undefined()));
    return switch(self){
      case Some(v)  : v;
      case None     : exception.apply(pos).crack(); null;
      case null     : exception.apply(pos).crack(); null;
    }
  }
  /**
   * Helper to lift an `Option` to an `Upshot` using `CTR<Fault,Refuse<E>>`
   * @param self 
   * @param fn 
   * @param pos 
   * @return Upshot<T,E>
   */
  static public function resolve<T,E>(self:Option<T>,fn:CTR<Fault,Refuse<E>>,?pos:Pos):Upshot<T,E>{
    return self.fold(
      __.accept,
      () -> __.reject(fn.apply(__.fault(pos)))
    );
  }
}