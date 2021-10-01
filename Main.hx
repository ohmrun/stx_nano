using stx.Nano;


using stx.Sys;

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
