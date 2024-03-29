package stx.nano;

@:using(stx.nano.Report.ReportLift)
abstract Report<E>(ReportSum<E>) from ReportSum<E> to ReportSum<E>{
  static public var _(default,never) = ReportLift;
  public function new(self) this = self;
  @:noUsing static public inline function lift<E>(self:ReportSum<E>):Report<E> return new Report(self);

  @:noUsing static public function make<E>(data:E,?pos:Pos):Report<E>{
    return pure(__.fault(pos).of(data));
  }
  @:noUsing static public function make0<E>(data:Decline<E>,?pos:Pos):Report<E>{
    return pure(__.fault(pos).decline(data));
  }
  @:noUsing static public function unit<E>():Report<E>{
    return lift(Happened);
  }
  @:noUsing static public function conf<E>(?e:Refuse<E>):Report<E>{
    return lift(__.option(e).map(Reported).defv(Happened));
  }
  @:noUsing static public function pure<E>(e:Refuse<E>):Report<E>{
    return lift(Reported(e));
  }
  public function iterator(){
    return option().iterator();
  }
  public function effects(success:Void->Void,failure:Void->Void):Report<E>{
    return _.fold(
      this,
      (e) -> {
        failure();
        return pure(e);
      },
      () -> {
        success();
        return unit();
      }
    );
  }
  public inline function crunch(){
    switch(this){
      case Reported(e)    : throw e;
      default             :
    }
  }
  @:from static public function fromStdOption<E>(opt:haxe.ds.Option<Refuse<E>>):Report<E>{
    return lift(opt.fold(
      Reported,
      () -> Happened
    ));
  }
  @:from static public function fromOption<E>(opt:Option<Refuse<E>>):Report<E>{
    return lift(opt.fold(
      Reported,
      () -> Happened
    ));
  } 
  public function prj():ReportSum<E>{
    return this;
  }
  public function option():Option<Refuse<E>>{
    return _.fold(
      this,
      (err) -> Some(err),
      () -> None
    );
  }
  public function defv(error:Refuse<E>){
    return this.defv(error);
  }
  public function or(that:Void->Report<E>):Report<E>{
    return _.fold(
      this,
      (x) -> Report.pure(x),
      that
    );
  }
  @:note("error in js")
  public function errata<EE>(fn:Refuse<E>->Refuse<EE>):Report<EE>{
    return new Report(
      switch(this){
        case Reported(v) :  Reported(fn(v));
        case Happened    :  Happened;
      }
    );
  }
  public function is_ok(){
    return switch(this){
      case Happened : true;
      default       : false;
    }
  }
  public function promote():Upshot<Nada,E>{
    return _.resolve(this,() -> Nada);
  }
  public function alert():Alert<E>{
    return Alert.make(this);
  }
}
class ReportLift{
  static function lift<T>(self:ReportSum<T>):Report<T>{
    return Report.lift(self);
  }
  static public function resolve<T,E>(self:ReportSum<E>,fn:Void->T):Upshot<T,E>{
    return fold(
      self,
      (x) -> __.reject(x),
      ()  -> __.accept(fn())
    );
  }
  static public function concat<E>(self:Report<E>,that:Report<E>):Report<E>{
    return switch([self,that]){
      case [Reported(l),Happened]     : Reported(l);
      case [Happened,Reported(r)]     : Reported(r); 
      case [Reported(l),Reported(r)]  : Reported(l.concat(r));
      default                         : Happened;
    }
  }
  static inline public function fold<T,Z>(self:ReportSum<T>,val:Refuse<T>->Z,nil:Void->Z):Z{
    return switch(self){
      case Reported(v)  : val(v);
      case Happened     : nil();
      case null         : nil();
    }
  }
  static public function def<T>(self:ReportSum<T>,fn:Void->Refuse<T>):Refuse<T>{
    return fold(
      self,
      (x) -> x,
      fn
    );
  }
  static public inline function defv<T>(self:ReportSum<T>,v:Refuse<T>):Refuse<T>{
    return def(
      self,
      () -> v
    );
  }
  static public function is_defined<T>(self:ReportSum<T>){
    return fold(
      self,
      (_) -> true,
      () -> false
    );
  }
  static public function ignore<T>(self:ReportSum<T>,?fn:Decline<T>->Bool){
    __.option(fn).def(() -> fn = (x) -> true);
    return fold(
      self,
      (err:Refuse<T>) -> err.data.fold(
        (failure:Decline<T>) -> fn(failure).if_else(
          ()  -> __.report(),
          ()  -> err.report()
        ),
        () -> __.report() 
      ),
      () -> __.report()
    );
  }
  //TODO naming issue here
  static public function so<T>(self:ReportSum<T>,fn:Void->Report<T>):Report<T>{
    return fold(
      self,
      e   -> e.report(),
      ()  -> fn()
    );
  }
  @:deprecated
  static public function and<T>(self:ReportSum<T>,fn:Void->Report<T>):Report<T>{
    return fold(
      self,
      e   -> e.report(),
      ()  -> fn()
    );
  }
  static public function usher<T,Z>(self:ReportSum<T>,fn:Option<Decline<T>>->Z):Z{
    return switch(self){
      case Reported(refuse)     : refuse.usher(fn);
      default                   : fn(None);
    }
  }
  static public function crack<T>(self:ReportSum<T>):Void{
    fold(
      self,
      e   -> e.crack(),
      ()  -> {} 
    );
  }
}