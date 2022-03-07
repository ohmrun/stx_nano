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
@:forward(use) abstract Absorbable<T>(NuggetApi<T>) from NuggetApi<T>{
  public function new(self:NuggetApi<T>){
    this = self;
  }
  static public function lift<T>(self:NuggetApi<T>):Absorbable<T>{
    return new Absorbable(self);
  }
  static public function pure<T>(v:T):Absorbable<T>{
    return lift(new NuggetCls(v));
  }
}
@:forward(put) abstract Producable<T>(NuggetApi<T>) from NuggetApi<T>{
  public function new(self:NuggetApi<T>){
    this = self;
  }
  static public function lift<T>(self:NuggetApi<T>){
    return new Producable(self);
  } 
  static public function unit<T>():Producable<T>{
    return lift(new NuggetCls()); 
  }
} 