using stx.Nano;
using tink.CoreApi;

class Main {
	static function main() {
		trace('main');
		var a = Stream.fromArray([1,2,3,4]);
		var b = Stream.fromFuture(Future.delay(200,5));
		var c = a.seq(b);
				c.handle(
					(x) -> trace(x)
				);
	}
	static macro function boot(){
		trace('boot');
		return macro {};
	}
}
