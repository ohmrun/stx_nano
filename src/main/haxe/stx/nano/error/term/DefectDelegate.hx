package stx.nano.error.term;

class DefectDelegate<E> implements DefectApi<E>{
  final delegate : Defect<E> 
  public function new(delegate){
    this.delegate;
  }
  public var error(get,null) : Iter<E>;
  
  public function get_error():Iter<E>{
    return delegate.error;
  }
}