package stx.nano;


@:using(stx.nano.Report.ReportLift)
abstract Report<E>(ReportSum<E>) from ReportSum<E> to ReportSum<E>{
  static public var _(default,never) = ReportLift;
  public function new(self) this = self;
  @:noUsing static public inline function lift<E>(self:ReportSum<E>):Report<E> return new Report(self);

  @:noUsing static public function make<E>(data:E,?pos:Pos):Report<E>{
    return pure(__.fault(pos).of(data));
  }
  @:noUsing static public function make0<E>(data:Failure<E>,?pos:Pos):Report<E>{
    return pure(__.fault(pos).failure(data));
  }
  @:noUsing static public function unit<E>():Report<E>{
    return lift(Happened);
  }
  @:noUsing static public function conf<E>(?e:Err<E>):Report<E>{
    return lift(__.option(e).map(Reported).defv(Happened));
  }
  @:noUsing static public function pure<E>(e:Err<E>):Report<E>{
    return lift(Reported(e));
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
  @:from static public function fromStdOption<E>(opt:haxe.ds.Option<Err<E>>):Report<E>{
    return lift(opt.fold(
      Reported,
      () -> Happened
    ));
  }
  @:from static public function fromOption<E>(opt:Option<Err<E>>):Report<E>{
    return lift(opt.fold(
      Reported,
      () -> Happened
    ));
  } 
  public function prj():ReportSum<E>{
    return this;
  }
  public function value():Option<Err<E>>{
    return _.fold(
      this,
      (err) -> Some(err),
      () -> None
    );
  }
  public function defv(error:Err<E>){
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
  public function errata<EE>(fn:Err<E>->Err<EE>):Report<EE>{
    return new Report(
      switch(this){
        case Reported(v) :  Reported(fn(v));
        case Happened    :  Happened;
      }
    );
  }
  public function ok(){
    return switch(this){
      case Happened : true;
      default       : false;
    }
  }
  public function promote():Res<Noise,E>{
    return _.resolve(this,() -> Noise);
  }
  public function alert():Alert<E>{
    return Alert.make(this);
  }
}
class ReportLift{
  static function lift<T>(self:ReportSum<T>):Report<T>{
    return Report.lift(self);
  }
  static public function resolve<T,E>(self:ReportSum<E>,fn:Void->T):Res<T,E>{
    return fold(
      self,
      __.reject,
      () -> __.accept(fn())
    );
  }
  static public function merge<E>(self:Report<E>,that:Report<E>):Report<E>{
    return switch([self,that]){
      case [Reported(l),Happened]     : Reported(l);
      case [Happened,Reported(r)]     : Reported(r); 
      case [Reported(l),Reported(r)]  : Reported(l.merge(r));
      default                         : Happened;
    }
  }
  static public function fold<T,Z>(self:ReportSum<T>,val:Err<T>->Z,nil:Void->Z):Z{
    return switch(self){
      case Reported(v)  : val(v);
      case Happened     : nil();
      case null         : nil();
    }
  }
  static public function def<T>(self:ReportSum<T>,fn:Void->Err<T>):Err<T>{
    return fold(
      self,
      (x) -> x,
      fn
    );
  }
  static public inline function defv<T>(self:ReportSum<T>,v:Err<T>):Err<T>{
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
  static public function ignore<T>(self:ReportSum<T>,?fn:Failure<T>->Bool){
    __.option(fn).def(() -> fn = (x) -> true);
    return fold(
      self,
      (err:Err<T>) -> err.data.fold(
        (failure:Failure<T>) -> fn(failure).if_else(
          ()  -> __.report(),
          ()  -> err.report()
        ),
        () -> __.report() 
      ),
      () -> __.report()
    );
  }
  //TODO naming issue here
  static public function and<T>(self:ReportSum<T>,fn:Void->Report<T>):Report<T>{
    return fold(
      self,
      e   -> e.report(),
      ()  -> fn()
    );
  }
}