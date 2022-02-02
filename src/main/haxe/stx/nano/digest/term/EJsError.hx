package stx.nano.digest.term;

#if js
  class EJsError extends Digest{
    public function new(error:js.lib.Error){
      super(error.name,error.message);
    }
  }
#end