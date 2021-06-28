package stx.nano;


@:callable abstract Unfold<T,R>(T->Iterable<R>) from T->Iterable<R>{
  @:from static public function fromFunction<T,R>(fn:T -> Option<Couple<T, R>>):Unfold<T,R>{
    return unfold.bind(_,fn);
  }
  public inline function new( v : T->Iterable<R> ) {
    this = v;
  }
  @:noUsing static public inline function unfold<T, R>(initial: T, unfolder: T -> Option<Couple<T, R>>): Iterable<R> {
    return {
      iterator: function(): Iterator<R> {
        var _next: Option<R> = None;
        var _progress: T = initial;

        var precomputeNext = function() {
          switch (unfolder(_progress)) {
            case None:
              _progress = null;
              _next     = None;

            case Some(tup):
              _progress = tup.fst();
              _next     = Some(tup.snd());
          }
        }

        precomputeNext();

        return {
          hasNext: function(): Bool {
            return switch(_next){
              case Some(_): true;
              default: false;
            }
          },

          next: function(): R {
            var n = switch _next {
              case Some(v)  : v;
              default       : null;
            }

            precomputeNext();

            return n;
          }
        }
      }
    }
  }
}
