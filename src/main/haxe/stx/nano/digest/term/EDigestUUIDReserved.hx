package stx.nano.digest.term;

class EDigestUUIDReserved extends Digest{
  public function new(uuid){
    super("01FRQ557XM5KFRCSZ2Q0FFY069",'Uuid "$uuid" already registered.');
  }
}