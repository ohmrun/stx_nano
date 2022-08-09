package ;

using stx.Pico;
using stx.Nano;
using stx.Parse;
using stx.Log;

using eu.ohmrun.Fletcher;

class Doc{
  static public function main(){
    final log = __.log().global;
          log.includes.push('**/*');
          log.level = TRACE;
    trace('a');
    final doc     = __.resource("doc").string();
    final parser  = new stx.parse.term.Json().parser();
    final ctx     = __.ctx(
      doc.reader(),
      (x) -> {
        trace('done');
        trace(x);
      },        
      y -> throw y 
    );
    trace('b');
    ctx.load(parser.toFletcher()).crunch();
    trace('hjere');
  }
}