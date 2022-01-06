package stx.nano;

class Digest extends Clazz{
  static public var register(get,null) : haxe.ds.StringMap<Digest>;
  static function get_register(){
    return register == null ? register = new haxe.ds.StringMap() : register;
  } 
  final uuid    : String;
  final detail  : String;
  final code    : Int;

  public function new(uuid,detail,code=-1){
    super();
    this.uuid   = uuid;
    this.detail = detail;
    this.code   = code;
    
    if(register.exists(uuid)){
      final val = register.get(uuid);
      throw 'Digest identifier $uuid already registered for $val';
    }else{
      register.set(uuid,this);
    }
  }
  public function toString(){
    return 'DIGEST($code,"$uuid","$detail")';
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
  static public function e_undefined(self:Digests){
    return new stx.nano.digest.term.EUndefined();
  }
  static public function e_tink_error(self:Digests,msg,code){
    return new stx.nano.digest.term.ETinkError(msg,code);
  }
}