package stx.nano.lift;

import tink.core.Outcome as TinkOutcome;

class LiftTinkOutcomeToChunk{
  static public function core<T,E>(oc:TinkOutcome<T,Error<E>>):Chunk<T,E>{
    return Chunk.fromTinkOutcome(oc);
  }
}