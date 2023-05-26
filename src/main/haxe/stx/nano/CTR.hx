package stx.nano;

/**
 * Means to inject constuctors into API to reduce verbosity.
 */
typedef CTRDef<P,R> = P -> R;

/**
 * Means to inject constuctors into API to reduce verbosity.
 */
@:callable abstract CTR<P,R>(CTRDef<P,R>) from CTRDef<P,R> to CTRDef<P,R>{
  public function new(self) this = self;
  @:noUsing static inline public function lift<P,R>(self:CTRDef<P,R>):CTR<P,R> return new CTR(self);

  public function prj():CTRDef<P,R> return this;
  private var self(get,never):CTR<P,R>;
  private function get_self():CTR<P,R> return lift(this);

  @:noUsing static inline public function pure<P,R>(r:R):CTR<P,R>{
    return fromR(r);
  }
  @:noUsing @:from static public function fromR<P,R>(r:R):CTR<P,R>{
    return lift((_:P) -> r);
  }
  public function apply(r:P):R{
    return this(r);
  }
  public function app(p:P):APP<P,R>{
    return tuple2(this,p);
  }
}