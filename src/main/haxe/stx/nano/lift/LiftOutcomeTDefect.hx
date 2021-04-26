package stx.nano.lift;

class LiftOutcomeTDefect{
  static public function zip<Ti,Tii,E>(self:Outcome<Ti,Defect<E>>,that:Outcome<Tii,Defect<E>>){
    return switch([self,that]){
      case [Success(l),Success(r)] : __.success(__.couple(l,r));
      case [Failure(l),Failure(r)] : __.failure(l.concat(r));
      case [Failure(l),_]          : __.failure(l);
      case [_,Failure(r)]          : __.failure(r);
    }
  }
}