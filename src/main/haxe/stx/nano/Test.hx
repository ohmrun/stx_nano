package stx.nano;

using stx.Nano;

#if stx_test
  using stx.Log;
  using stx.Test;

  class Test{
    static public function main(){
      __.log().info("test");
      __.test([],[]);
    }
  }
#end