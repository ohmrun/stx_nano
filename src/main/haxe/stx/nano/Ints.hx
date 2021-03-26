package stx.nano;

class Ints {
	//static public inline var MAX 	: Int = StdInt
	static public inline var ZERO : Int = 0;
	static public inline var ONE  : Int = 1;
	/**
		Produces whichever is the greater.
	**/
	static public inline function max(v1: Int, v2: Int): Int { return if (v2 > v1) v2; else v1; }
	/**
		Produces whichever is the lesser.
	**/
  static public function min(v1: Int, v2: Int): Int { return if (v2 < v1) v2; else v1; }
	/**
		Produces a Bool if 'v' == 0;
	**/
  static public function toBool(v: Int): Bool { return if (v == 0) false else true; }
	/**
		Coerces an Int to a Float.
	**/
  static public function toFloat(v: Int): Float { return v; }
    
	/**
		Produces -1 if `v1` is smaller, 1 if `v1` is greater, or 0 if `v1 == v2`
	**/
  static public function compare(v1: Int, v2: Int) : Int {
    return if (v1 < v2) -1 else if (v1 > v2) 1 else 0;
  }
	/**
		Produces true if `v1` == `v2`
	**/
  static public function equals(v1: Int, v2: Int) : Bool {
    return v1 == v2;
  }
	/**
		Produces true if `n` is odd, false otherwise.
	**/
	static public inline function isOdd(n:Int) {
		return n%2 == 0 ? false : true;
	}
	/**
		Produces true if `n` is even, false otherwise.
	**/
	static public inline function isEven(n:Int){
		return (isOdd(n) == false);
	}
	/**
		Produces true if `n` is an integer, false otherwise.
	**/
	static public inline function isInteger(n:Float){
		return (n%1 == 0);
	}
	/**
		Produces true if `n` is a natural number, false otherwise.
	**/
	static public inline function isNatural(n:Int){
		return ((n > 0) && (n%1 == 0));
	}
	/**
		Produces true if `n` is a prime number, false otherwise.
	**/
	static public inline function isPrime(n:Int){
		if (n == 1) return false;
		if (n == 2) return false;
		if (n%2== 0) return false;
		var itr = new IntIterator(3,StdMath.ceil(StdMath.sqrt(n))+1);
		for (i in itr){
			if (n % 1 == 0){
				return false;
			}
			i++;
		}
		return true;
	}
	/**
		Produces the factorial of `n`.
	**/
	static public function factorial(n:Int){
		if (!isNatural(n)){
			throw "function factorial requires natural number as input";
		}
		if (n == 0){
			return 1;
		}
		var i = n-1;
		while(i>0){
			n = n*i;
			i--;
		}
		return n;
	}
	/**
		Produces the values that n can divide into
	**/
	static public inline function divisors(n:Int){
		var r = new Array<Int>();
		var iter = new IntIterator(1,StdMath.ceil((n/2)+1));
		for (i in iter){
			if (n % i == 0){
				r.push(i);
			}
		}
		if (n!=0){r.push(n);}
		return r;
	}
	/**
		Produces a value between `min` and `max`
	**/
	static public inline function clamp(n:Int, min : Int , max : Int  ) {
		if (n > max) {
			n = max;
		}else if ( n < min) {
			n = min;
		}
		return n;
	}
	/**
		Produces half of `n`.
	**/
	static public inline function half(n:Int) {
		return n / 2;
	}
	/**
		Produces the sum of the elements in `xs`.
	**/
	static public inline function sum(xs:Iterable<Int>):Int {
		var o = 0;
		for ( val in xs ) {
			o += val;
		}
		return o;
	}
	/**
		Add two Ints.
	**/
	static public inline function add(a:Int,b:Int):Int{
		return a + b;
	}
	/**
		Subtracts `b` from `a`.
	**/
	static public inline function sub(a:Int,b:Int):Int{
		return a - b;
	}
	/**
		Divides `a` by `b`.
	**/
	static public inline function div(a:Int,b:Int):Float{
		return a / b;
	}
	/**
		Multiplies `a` by `b`
	**/
	static public inline function mul(a:Int,b:Int):Int{
		return a * b;
	}
	/**
		Mod `a` by `b`
	**/
	static public inline function mod(a:Int,b:Int):Int{
		return a % b;
	}
	static public inline function inv(n:Int):Int{
		return -n;
	}
	static public inline function and(a : Int, b : Int) : Int{
		return a & b;
	}
	/**
		Returns true if `a == b`
	**/
	static public inline function eq(a:Int, b:Int) : Bool{
		return (a == b);
	}
	/**
		Returns true if `a > b`
	**/
	static public inline function gt(a:Int, b:Int){
		return (a > b);
	}
	/**
		Returns true if `a >= b`
	**/
	static public inline function gteq(a:Int, b:Int){
		return (a >= b);
	}
	/**
		Returns true if `a < b`
	**/
	static public inline function lt(a:Int, b:Int) : Bool{
		return (a < b);
	}
	/**
		Returns true if `a <= b`
	**/
	static public inline function lteq(a:Int, b:Int){
		return (a <= b);
	}
	/**
		Returns `v >>> bits` (unsigned shift)
	**/
	static public inline function ushr(v : Int, bits:Int) : Int{
		return v >>> bits;
	}
	@doc("Returns `a ^ b`")
	static public inline function xor(a : Int, b : Int) : Int{
		return a ^ b;
	}
	/**
		Returns `v << bits`
	**/
	public static inline function shl(v : Int, bits:Int) : Int{
		return v << bits;
	}
	/**
		Returns `v >> bits` (signed shift)
	**/
	public static inline function shr(v : Int, bits:Int) : Int{
		return v >> bits;
	}
	static public inline function abs(v : Int) : Int{
		return Std.int(StdMath.abs(v));
	}
	static public inline function toString(a:Int):String{
		return '$a';
	}
	static public function is_between(n:Int,l:Int,h:Int){
		return n > l && n < h;
	}
	static public function is_of_range(n:Int,l:Int,h:Int){
		return n >= l && n <= h;
	}
}