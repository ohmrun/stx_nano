package stx.nano.lift;

class LiftOptionToChunk{
  static public function toChunk<T,E>(opt:StdOption<T>):Chunk<T,E>{
    return switch (opt){
      case Some(v)  : Val(v);
      case None     : Tap;
    }
  }
}