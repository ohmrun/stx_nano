package stx.nano;

interface PartialFunctionApi<P,R> extends ApplyApi<P,R>{
  public function guard(v:P):Bool;
}
abstract class PartialFunctionCls<P,R> implements PartialFunctionApi<P,R>{
  abstract public function guard(v:P):Bool;
}
@:forward abstract PartialFunction<P,R>(PartialFunctionApi<P,R>) from PartialFunctionApi<P,R> to PartialFunctionApi<P,R>{
  public function new(self) this = self;
  @:noUsing static public function lift<P,R>(self:PartialFunctionApi<P,R>):PartialFunction<P,R> return new PartialFunction(self);

  public function prj():PartialFunctionApi<P,R> return this;
  private var self(get,never):PartialFunction<P,R>;
  private function get_self():PartialFunction<P,R> return lift(this);
}