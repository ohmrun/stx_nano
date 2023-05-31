package stx.nano;

using stx.Nano;

#if stx_test
  using stx.Pico;
  using stx.Nano;
  using stx.Log;
  using stx.Test;
  using stx.Fail;

  class Test{
    static public function main(){
      __.log().info("test");
      __.test().run([
        new EquityTest(),
      ],[]);
    }
  }
  class EquityTest extends TestCase{
    public function test(){
      try{
        var a = Equity.make(null,null,Refuse.make(Some(EXTERNAL(1)),None,None));  
        var b = a.errate(x -> x+1);
        trace("h");
        trace(b.error);
        trace("hdd");
      }catch(e:Dynamic){
        trace(e);
      }
      
    }
  }
#end