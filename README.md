# stx_nano

`using stx.Nano` pulls in: `Couple<L,R>, Err<E>, FailCode, Failure, Fault, Position, Primitive, Report, Res, Unique, VBlock, Wildcard, Y`

`Couple<L,R>` is a two-tuple implemented as a function handler.  
`Err<E>` is a flexible error class, can be accessed through `__.fault()`.  
`FailCode` is an enumeration of fails, can be used in a typed Err<E> without effecting the type.  
`Failure<E>` allows `FailCodes` and whatever type `E` is in `Err` to get along.  
`Fault` is a static extension of `Wildcard` that produces an error api, capturing the position information.  
`Primitive` is an enumeration of Primitive haxe scalars.  
`Report<E>` is `Option<Err,E>>` with convenience functions.  
`Res<E>` is `Outcome<Err<E>>`.  
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

## using Err

```haxe
  enum ErrorVal{
    E_SomeError;
    E_SomeOther_Error;
  }
  enum SuperErrorVal{
    E_SuperError;
    E_SubsytemError(v:ErrorVal);
  }
  static function main(){
    //                v--`haxe.PosInfos` injected here`
    var e0 = __.fault( ).of(E_SomeError);//Err<ErrorVal>
    var e1 = __.fault( ).of(E_SomeOtherError);//Err<ErrorVal>

    var e2 = e0.next(e1);//both of these errors now available downstream.
    var e3 = __.fault().err(FailCode.E_ResourceNotFound);//Err<Unknown>;

    var e4 = e2.next(e3);//Type compatible

    var e5 = __.fault().of(E_SuperError);

    var report0 = Report.pure(e4);//Err<ErrorVal>
    var report1 = Report.pure(e5);//Err<SuperErrorVal>

    var report2 = report0.errata(
      (err) -> err.map(E_SubsystemError)
    );//Err<SuperErrorVal>

    var report3 = report1.merge(report2);

    if(!report3.ok()){
      report3.crunch();//throws if defined
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