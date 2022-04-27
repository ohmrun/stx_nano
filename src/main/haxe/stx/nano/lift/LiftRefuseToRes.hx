package stx.nano.lift;

class LiftRefuseToRes{
  static inline public function toRes<T,E>(self:Refuse<E>):Res<T,E>{
    return Reject(self);
  }
  static inline public function reject<T,E>(self:Refuse<E>):Res<T,E>{
    return Reject(self);
  }
}