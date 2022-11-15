# stx_nano

`using stx.Nano;` pulls in: `Couple<L,R>, Err<E>, Digest, Failure<E>, Fault<E>, Pos, adPosition, Primitive, Report, Res, Unique, VBlock, Wildcard, Y`

`Couple<L,R>` is a two-tuple implemented as a function handler.  
`Digest` is an enumeration of fails, can be used in a typed Err<E> without effecting the type.  
`Failure<E>` allows `Digests` and whatever type `E` is in `Err` to get along.  
`Fault` is a static extension of `Wildcard` that produces an error api, capturing the position information.  
`Primitive` is an enumeration of Primitive haxe scalars.  
`Report<E>` is `Option<Err,E>>` with convenience functions.  
`Res<E>` is like `Outcome<Err<E>>`.  
`Unique<T>` allows runtime unique values to be created, using the equality properties of functions under the hood.  
`VBlock<T>` is a carrier for a virtual type, not connected to a value, but useful for various type foo.  
`Y<T>`  is an implementation of the y-combinator  


## Using Wildcard

```haxe
using stx.Nano;
using LiftSomething;

class LiftSomething{
  static public function option<T>(wildcard:Wildcard,?v:T):Option<T>{
    return v == null ? None : Some(v);
  }
  static function main(){
    var val     = __.option(1);
    var nothing = __.option(null);
  }
}
  

```


### using Couple

```haxe
  var tp    = __.couple("string",1);
      tp    = tp.map( n -> n + 1);
      tp    = tp.lmap( s -> '$s' );
      
  var next  = tp.decouple(
    (a,b) -> '$a $b'
  );
  var next  = __.decouple(
    (a,b) -> '$a $b'
  )(tp);
```

### using Res

  `fold`, `map`, `flat_map` and `zip` defined.

```haxe
  var success = __.success("yay");
  var failure = __.failure(__.fault().of(E_SomeOther_Error));
      failure = failure.errata((err) -> err.map(E_SubsystemError));
  
  var ok      = success.fudge();//"yay"
  var no      = failure.fudge();//throws
```