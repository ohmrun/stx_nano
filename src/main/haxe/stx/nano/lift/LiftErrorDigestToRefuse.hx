package stx.nano.lift;

class LiftErrorDigestToRefuse{
  static public function toRefuse<E>(self:Error<Digest>):Refuse<E>{
    return self.errate(INTERNAL);
  }
}