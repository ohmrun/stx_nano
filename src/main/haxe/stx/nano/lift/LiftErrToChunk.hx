package stx.nano.lift;
class LiftErrToChunk{
  static public function toChunk<T,E>(err:Err<E>):Chunk<T,E>{
    return stx.nano.Chunk.fromError(err);
  }
}