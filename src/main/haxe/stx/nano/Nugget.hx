package stx.nano;

interface NuggetApi<T>{
  public function put(v:T):Void;
  public function use(v:T->Void):Void;
}
class NuggetCls<T> implements NuggetApi<T>{
  private var val(default,null):T;
  public function new(?val:T){
    this.val = val;
  } 
  public function put(v:T){
    if(val!=null){
      throw 'already set value on Nugget';
    }
  }
  public function use(fn:T->Void){
    if(this.val == null){
      throw 'val on Nugget unset';
    }
  }
}
private class Delegate<T>{
  public final delegate : T;
  public function new(delegate){
    this.delegate = delegate;
  }
}
// abstract class Tap<T> implements NuggetApi<T> extends Delegate<NuggetApi<T>>{
//   public function new(delegate){
//     super(delegate);
//   }
//   abstract function tap(fn:T->Void):Void;
//   public function put(v:T){
//     this.delegate.put(v);
//     this.tap(v);
//   }
//   public function use(fn:T->Void){
//     this.delegate.use(fn);
//   }
// }
// private class AnonTap<T> extends Tap<T>{
//   private final _tap : T -> Void;
//   public function new(delegate,_tap){
//     super(delegate);
//     this._tap = tap;
//   }
//   public inline function tap(v:T){
//     this._tap(v);
//   }
// }
class FutureNugget<T> extends NuggetCls<T>{
  final fut : Future<T>;
  public function new(fut){
    super();
    this.fut = fut;
  }
  override public function put(v:T){
    throw 'Future Nugget resolves internally';
  }
  override public function use(fn:T->Void){
    this.fut.handle(fn);
  }
}
// abstract class FlatMap<T,Ti> implements NuggetApi<Ti> extends Delegate<Nugget<Ti>>{
//   final inner : Null<Nugget<Ti>>;

//   public function new(delegate){
//     super(delegate);
//   }
//   abstract public function flat_map(fn:T->Nugget<Ti>):Nugget<Ti>;

//   public function put(v:Ti){
//     this.delegate.use(
//       (v:T) -> {
//         inner = flat_map(v);
//         inner.put(v);
//       }
//     );
//   }
// }
abstract Nugget<T>(NuggetApi<T>) from NuggetApi<T> to NuggetApi<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:NuggetApi<T>):Nugget<T> return new Nugget(self);

  public function prj():NuggetApi<T> return this;
  private var self(get,never):Nugget<T>;
  private function get_self():Nugget<T> return lift(this);
}

@:forward(use) abstract Absorbable<T>(NuggetApi<T>) from NuggetApi<T>{
  public function new(self:NuggetApi<T>){
    this = self;
  }
  @:noUsing static public function lift<T>(self:NuggetApi<T>):Absorbable<T>{
    return new Absorbable(self);
  }
  @:noUsing static public function pure<T>(v:T):Absorbable<T>{
    return lift(new NuggetCls(v));
  }
  static public function later<T>(ft:Future<T>):Absorbable<T>{
    return lift(new FutureNugget(ft));
  }
}
abstract Producable<T>(NuggetApi<T>) from NuggetApi<T>{
  public function new(self:NuggetApi<T>){
    this = self;
  }
  @:noUsing static public function lift<T>(self:NuggetApi<T>){
    return new Producable(self);
  } 
  static public function unit<T>():Producable<T>{
    return lift(new NuggetCls()); 
  }
  public function go(v:T){
    this.put(v);
    return Absorbable.lift(this);
  }
} 