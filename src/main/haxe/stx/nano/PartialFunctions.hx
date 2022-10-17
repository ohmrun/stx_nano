package stx.nano;

typedef PartialFunctionsDef<P,R> = Cluster<PartialFunction<P,R>>;

abstract PartialFunctions<P,R>(PartialFunctionsDef<P,R>) from PartialFunctionsDef<P,R> to PartialFunctionsDef<P,R>{
  public function new(self) this = self;
  @:noUsing static public function lift<P,R>(self:PartialFunctionsDef<P,R>):PartialFunctions<P,R> return new PartialFunctions(self);

  public function prj():PartialFunctionsDef<P,R> return this;
  private var self(get,never):PartialFunctions<P,R>;
  private function get_self():PartialFunctions<P,R> return lift(this);

  public function apply(v:P):Option<R>{
    return this.lfold(
      (next:PartialFunction<P,R>,memo:Option<R>) -> {
        switch(memo){
          case Some(x)  : Some(x);
          default       : 
            switch(next.guard(v)){
              case true  : Some(next.apply(v));
              case false : None;
            }
        }
      },
      None
    );
  }
}