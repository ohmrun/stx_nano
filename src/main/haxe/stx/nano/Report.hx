
package stx.nano;


@:forward(is_defined,fold)abstract Report<E>(Option<Err<E>>) from Option<Err<E>> to Option<Err<E>>{

  public function new(self) this = self;
  
  @:noUsing static public inline function lift<E>(self:Option<Err<E>>):Report<E> return new Report(self);

  @:noUsing static public function make<E>(data:E,?pos:Pos):Report<E>{
    return pure(__.fault(pos).of(data));
  }
  @:noUsing static public function unit<E>():Report<E>{
    return new Report(None);
  }
  @:noUsing static public function conf<E>(?e:Err<E>):Report<E>{
    return new Report(__.option(e));
  }
  @:noUsing static public function pure<E>(e:Err<E>):Report<E>{
    return new Report(Some(e));
  }
  public function effects(success:Void->Void,failure:Void->Void):Report<E>{
    return this.fold(
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
      case Some(e)    : throw e;
      default         :
    }
  }
  @:from static public function fromStdOption<E>(opt:haxe.ds.Option<Err<E>>):Report<E>{
    var opt : Option<Err<E>> = opt;
    return new Report(opt);
  }
  public function prj():Option<Err<E>>{
    return this;
  }
  public function value():Option<E>{
    return this.fold(
      (err) -> err.value(),
      () -> None
    );
  }
  public function defv(error:Err<E>){
    return this.defv(error);
  }
  public function merge(that:Report<E>):Report<E>{
    return this.merge(that.prj(),
      (lhs,rhs) ->  lhs.next(rhs)
    );
  }
  public function or(that:Void->Report<E>):Report<E>{
    return this.fold(
      (x) -> Report.pure(x),
      that
    );
  }
  @:note("error in js")
  public function errata<EE>(fn:Err<E>->Err<EE>):Report<EE>{
    return new Report(
      switch(this){
        case Some(v) : fn(v);
        case None   :  None;
      }
    );
  }
  public function ok(){
    return switch(this){
      case None : true;
      default   : false;
    }
  }
  public function populate<T>(fn:Void->T):Res<T,E>{
    return this.fold(
      __.reject,
      () -> __.accept(fn())
    );
  }
  public function promote():Res<Noise,E>{
    return populate(() -> Noise);
  }
}