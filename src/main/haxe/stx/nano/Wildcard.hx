package stx.nano;

/**
`Wildcard` along with [static extensions](https://haxe.org/manual/lf-static-extension.html) produces a floating global accessor available everywhere it's constructor is imported.

```haxe
using stx.Nano;
using LiftSomething;

class LiftSomething{
  static public function make_option<T>(wildcard:Wildcard,?v:T):Option<T>{
    return v == null ? None : Some(v);
  }
  static function main(){
    var val     = __.make_option(1);
    var nothing = __.make_option(null);
  }
}

```
**/
enum Wildcard{
  __;
}