package stx.nano;

/**
  Represents information about an error. `uuid` is intended to be unique, but this iss currently not enforced.
**/
class Digest extends Clazz{
  static public var register(get,null) : haxe.ds.StringMap<Digest>;
  static function get_register(){
    return register == null ? register = new haxe.ds.StringMap() : register;
  } 
  public final uuid    : String;
  public final detail  : String;
  public final code    : Int;

  public function new(uuid,detail,code=-1){
    super();
    this.uuid   = uuid;
    this.detail = detail;
    this.code   = code;
    
    if(register.exists(uuid)){
      final val = register.get(uuid);
      if(Type.getClass(val) != Type.getClass(this)){
        throw 'Digest identifier $uuid on ${this.identifier()} already registered for $val';
      }
    }else{
      register.set(uuid,this);
    }
  }
  public function toString(){
    return '($code,"$uuid","$detail")';
  }
  public function asDigest():Digest{
    return this;
  }
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