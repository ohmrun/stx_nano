package stx.nano.lift;
class LiftStringToResource{
  static public inline function resource(stx:Wildcard,str:String,?pos:Pos):Resource{
    return new Resource(str,pos);
  }
}