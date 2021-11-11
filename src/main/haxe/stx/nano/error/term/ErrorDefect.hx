package stx.nano.error.term;


class ErrorDefect<E> implements DefectApi<E>{
  final delegate  : Error<E>
  public var error(get,null) : Iter<E>;
  public function get_error(): Iter<E>{
    return this.delegate.concat(this.delegate.rest).map_filter(e -> e.val);
  }
  public function new(delegate){
    this.delegate = delegate;
  }
}