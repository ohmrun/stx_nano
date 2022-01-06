package stx.nano.digest.term;

class EResourceNotFound extends Digest{
  public function new(resource_name){
    super("01FRQ55MMVX2D7JEHJ6CE4X1NY",'Resource $resource_name not found.');
  }
}