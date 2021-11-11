package stx.nano.error.term;

class DefectMap<E,EE> implements DefectApi<EE>{
  final error : Defect<E>;
  public function new(delegate:Error<E>,map:E->EE){
    super();
    this.delegate = delegate;
    this.map      = map;
  }
  final map : E -> EE;
}