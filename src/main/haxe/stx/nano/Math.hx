package stx.nano;

class Math {	
	static var PRIMES : Array<Int> = [1, 3, 7, 13, 31, 61, 127, 251, 509, 1021, 2039, 4093, 8191, 16381, 32749, 65521, 131071, 262139, 524287, 1048573, 2097143, 4194301, 8388593, 16777213, 33554393, 67108859, 134217689, 268435399, 536870909, 1073741789, 2147483647];
	/**
		Produces either a zero or a one randomly, influenced by `weight`
	**/
	static public inline function rndOne(?weight : Float = 0.5 ):Int {
		return Std.int ( ( Math.random() - weight )  );
	}
	/**
		Produces the radians of a given angle in degrees.
	**/
	static public inline function radians(v:Float) {
		return v * ( StdMath.PI / 180 );
	}
	/**
		Produces the degrees of a given angle in radians.
	**/
	static public inline function degrees(v:Float) {
		return v * ( 180 / StdMath.PI ) ;
	}
	@:noUsing static public inline function random(max = 1,min = 0){
		return StdMath.random() * (max - min) + min;
	}
	@:noUsing static inline public function isNaN(fl:Float):Bool{
		return StdMath.isNaN(fl);
	}
}