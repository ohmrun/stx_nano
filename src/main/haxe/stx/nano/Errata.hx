package stx.nano;

typedef ErrataDef<E> = Iter<E>;

@:using(stx.nano.Errata.ErrataLift)
abstract Errata<E>(ErrataDef<E>) from ErrataDef<E> to ErrataDef<E>{
  static public var _(default,never) = ErrataLift;
  public function new(self) this = self;
  static public function lift<E>(self:ErrataDef<E>):Errata<E> return new Errata(self);
  static public function unit<E>():Errata<E>{
    return lift(Iter.unit());
  }
  public function prj():ErrataDef<E> return this;
  private var self(get,never):Errata<E>;
  private function get_self():Errata<E> return lift(this);

  public function elide<EE>():Errata<EE>{
    return cast this;
  }
  // static public function toError<E>(self:ErrataDef<E>):Error<E>{
  //   return toErrorAt(self,null);
  // }
  // static public function toErrorAt<E>(self:ErrataDef<E>,?pos:Pos):Error<E>{
  //   return _.toErrorAt(self,pos);
  // }
}
class ErrataLift{
  static public function errata<E,EE>(self:ErrataDef<E>,fn:Error<E>->Error<EE>):Errata<EE>{
    return self.is_defined().if_else(
      () -> fromError(fn(toError(self))),
      () -> Errata.lift(self).elide()
    );
  }
  static public function toError<E>(self:ErrataDef<E>):Error<E>{
    return toErrorAt(self,null);
  }
  static public function toErrorAt<E>(self:ErrataDef<E>,?pos:Pos):Error<E>{
    var all = Lambda.array(self);
        all.reverse();
    
    function rec(arr:Array<E>):Error<E>{
      var head = arr.head();
      var tail = arr.tail();
      return switch([head,tail.is_defined()]){
        case [Some(h),true]   : Error.make(Some(h),Some(rec(tail)),pos);
        case [Some(h),false]  : Error.make(Some(h),None,pos);
        case [None,_]         : Error.make(None,None,pos);
      }
    }
    var result = rec(all);
    return result;
  }
  static public function fromError<E>(self:Error<E>):Errata<E>{
      return Errata.lift({
        iterator : () -> {
          hasNext : () -> self != null,
          next    : () -> {
            final val   = self.val.defv(null);
            self        = self.lst.defv(null);
            return val;
          }
        }
      });
  }
  static public function concat<E>(self:ErrataDef<E>,that:Errata<E>):Errata<E>{
    return Errata.lift(IterableLift.concat(self.prj(),that.prj()));
  }
  static public function is_defined<E>(self:ErrataDef<E>):Bool{
    return self.is_defined();
  }
}