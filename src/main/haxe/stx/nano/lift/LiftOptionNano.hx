package stx.nano.lift;

class LiftOptionNano{
  static public function zip<T,TT>(self:OptionSum<T>,that:OptionSum<TT>):OptionSum<Couple<T,TT>>{
    return switch([self,that]){
      case [Some(l),Some(r)]  : Some(__.couple(l,r));
      default                 : None;
    }
  }
  static public function fudge<T,E>(self:Null<Option<T>>,?err:Err<E>):T{
    err = Option.make(err).defv(__.fault().err(E_OptionForcedError));
    return switch(self){
      case Some(v)  : v;
      case None     : throw err;
      case null     : throw err;
    }
  }
  static public function resolve<T,E>(self:Option<T>,err:E,?pos:Pos){
    return self.fold(
      __.accept,
      () -> __.reject(__.fault(pos).of(err))
    );
  }
}