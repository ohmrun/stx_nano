package stx.nano.error.term;

class DefectError<E> extends Error<E> implements DefectApi<E>{
  public var error(get,null) : Iter<E>;
  public function get_error():Iter<E>{
    return this.error;
  }
  
  public function new(error:Iter<E>){
    super();
    this.error = error;
  }
  public function get_pos(): Option<Pos>{
    return None;
  }
  public function get_val() : Option<E>{
    return this.error.head();
  }
  public function get_lst() : Option<Error<E>>{
    return Some(new DefectError(error.tail()).toError());
  }
  public function concat(that:Error<E>){
    return switch(that.pos){
      case Some(e) : new stx.pico.error.term.ErrorConcat(that,this);
      case None    : new DefectError(
        that.val.map(
          (x:E) -> 
            that.rest()
                .map_filter((y:Error<E>) -> y.val)
                .snoc(x))
                .map(this.error.concat).defv(this.error)
      ).toError();
    }
  }
  public function copy(){
    return new DefectError(this.error).toError();
  }
  public function toDefect():Defect<E>{
    return this;
  }
}