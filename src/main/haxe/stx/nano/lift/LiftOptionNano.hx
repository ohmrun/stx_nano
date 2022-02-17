package stx.nano.lift;

class LiftOptionNano{
  static public function zip<T,TT>(self:OptionSum<T>,that:OptionSum<TT>):OptionSum<Couple<T,TT>>{
    return switch([self,that]){
      case [Some(l),Some(r)]  : Some(__.couple(l,r));
      default                 : None;
    }
  }
  static public inline function fudge<T,E>(self:Null<Option<T>>,?err:Error<E>):T{
    final exception = Option.make(err.except()).defv(__.fault().explain(_ -> _.e_undefined()));
    return switch(self){
      case Some(v)  : v;
      case None     : throw exception;
      case null     : throw exception;
    }
  }
  static public function resolve<T,E>(self:Option<T>,fn:Fault->Rejection<E>,?pos:Pos){
    return self.fold(
      __.accept,
      () -> __.reject(fn(__.fault(pos)))
    );
  }
}