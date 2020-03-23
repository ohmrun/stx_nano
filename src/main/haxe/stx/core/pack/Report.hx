package stx.core.pack;


@:forward(is_defined,fold)abstract Report<E>(Option<Err<E>>) from Option<Err<E>> to Option<Err<E>>{
  static public var inj(default,null) = new Constructor();

  public function new(self) this = self;
  
  static public function lift<E>(self) return new Report(self);

  static public function unit<E>():Report<E>{
    return new Report(None);
  }
  static public function conf<E>(?e:Err<E>):Report<E>{
    return new Report(__.option(e));
  }
  static public function pure<E>(e:Err<E>):Report<E>{
    return new Report(Some(e));
  }
  public inline function crunch(){
    switch(this){
      case Some(e)    : throw e;
      default         :
    }
  }
  @:from static public function fromStdOption<E>(opt:Option<Err<E>>):Report<E>{
    var opt : Option<Err<E>> = opt;
    return new Report(opt);
  }
  public function prj():Option<Err<E>>{
    return this;
  }
  public function defv<E>(error:Err<E>){
    return this.defv(error);
  }
  public function merge(that:Report<E>):Report<E>{
    return this.merge(that.prj(),
      (lhs,rhs) ->  lhs.next(rhs)
    );
  }
  public inline function errata<EE>(fn:Err<E>->Err<EE>):Report<EE> return inj._.errata(fn,this);

  public function ok(){
    return switch(this){
      case None : true;
      default   : false;
    }
  }
}
private class Constructor{
  public var _ = new Destructure();
  public function new(){}
}
private class Destructure{
  public function new(){}
  public function errata<E,EE>(fn:Err<E>->Err<EE>,self:Report<E>):Report<EE>{
    return new Report(Option._.map(self.prj(),fn));
  }
  public function prj<E>(self:Report<E>):Option<Err<E>>{
    return self.prj();
  }
}