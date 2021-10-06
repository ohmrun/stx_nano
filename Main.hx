using stx.Nano;


#if sys
using stx.Sys;
#end

using tink.CoreApi;

class Main {
	static function main() {
		trace('main');
	}
	static macro function boot(){
		trace('boot');
		return macro {};
	}
}
