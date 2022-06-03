
using tink.CoreApi;
using stx.Pico;
using stx.Nano;

#if sys
using stx.Sys;
#end


class Main {
	static function main() {
		trace('main');
		var c : Cluster<String> = Cluster.lift(["hello"]);
		switch(c){
			case ["hello"] : trace("hello");
			default : 
		}
		$type(Pico.Option());
	}
	static macro function boot(){
		trace('boot');
		return macro {};
	}
}
