package stx.nano;

abstract Digests(Wildcard) from Wildcard{
  static public function e_digest_uuid_reserved(self:Digests,uuid){
    return new stx.nano.digest.term.EDigestUUIDReserved(uuid);
  }
  static public function e_resource_not_found(self:Digests,name){
    return new stx.nano.digest.term.EResourceNotFound(name);
  }
  static public function e_no_field(self:Digests,name){
    return new stx.nano.digest.term.ENoField(name);
  }
  static public function e_undefined(self:Digests){
    return new stx.nano.digest.term.EUndefined();
  }
  static public function e_tink_error(self:Digests,msg,code){
    return new stx.nano.digest.term.ETinkError(msg,code);
  }
  static public function e_unimplemented(self:Digests){
    return new stx.nano.digest.term.EUnimplemented();
  }
  #if js
  static public function e_js_error(self:Digests,error:js.lib.Error){
    return new stx.nano.digest.term.EJsError(error);
  }
  #end 
}