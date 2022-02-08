package stx.nano.lift;

class LiftErrorDigestToRejection{
  static public function toRejection<E>(self:Error<Digest>):Rejection<E>{
    return self.errate(DIGEST);
  }
}