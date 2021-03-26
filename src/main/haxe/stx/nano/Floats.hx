package stx.nano;

class Floats {
	//static public inline function pow(n0:)
	/**
		Produces the difference between `n1` and `n0`.
	**/
	static public inline function delta(n0:Float,n1:Float){
		return n1 - n0;
	}
	/**
		Produces `v` mapped between `n0` and `n1` and scaled to a value between 0 and 1.
	**/
	static public inline function normalize(v:Float,n0:Float,n1:Float){
		return (v - n0) / delta(n0, n1);
	}
	/**
		Produces a value between `n0` and `n1` where `v` specifies the distance between the two with a number between 0 and 1.
	**/
	static public inline function interpolate(v:Float,n0:Float,n1:Float){
		return n0 + ( delta(n0, n1) ) * v;
	}
	/**
		Take a value `v` as a value on the number line `min0` to `min1` and produce a value on the number line `min1` to `max1`
	**/
	static public inline function map(v:Float,min0:Float,max0:Float,min1:Float,max1:Float){
		return interpolate(normalize(v, min0, max0), min1, max1);
	}
	/**
		Round `n` to `c` decimal places.
	*
	*/
	static public inline function round(n:Float,c:Int = 1):Int{
		var r = StdMath.pow(10, c);
		return (StdMath.round(n * r) / r).int();
	}
	/**
		Ceiling `n` to `c` decimal places.
	**/
	static public inline function ceil(n:Float,c:Int = 1):Int{
		var r = StdMath.pow(10, c);
		return (StdMath.ceil(n * r) / r).int();
	}
	/**
		Floor `n` to `c` decimal places.
	**/
	static public inline function floor(n:Float,c:Int = 1):Int{
		var r = StdMath.pow(10, c);
		return (StdMath.floor(n * r) / r).int();
	}
	@doc(
		"Produce a number based on `n` that is `min` if less than `min`, 
		`max` if `n` is greater than `max` and is left untouched if
		between the two."
	)  
	static public inline function clamp(n:Float, min : Float , max : Float) {
		if (n > max) { n = max; }else if (n < min) { n = min; }
		return n;
	}
	
	/**
		Produce -1 if `n` is less than 0, 1 if `n` is greater, and 0 if input is 0.
	**/
	static public inline function sgn(n:Float) {
		return (n == 0 ? 0 : StdMath.abs(n) / n);
	}

	/**
		Produce the larger of `v1` and `v2`.
	**/
  static public function max(v1: Float, v2: Float): Float { return if (v2 > v1) v2; else v1; }

  /**
		Produce the smaller of `v1` and `v2`.
	**/
  static public function min(v1: Float, v2: Float): Float { return if (v2 < v1) v2; else v1; }

  /**
		Alias for Std.int
	**/
  static public function int(v: Float): Int { return Std.int(v); } 

  /**
		Produce 1 if `v1` is greater, -1 if `v2` is greater and 0 if `v1` and `v2` are equal.
	**/
  static public function compare(v1: Float, v2: Float) {   
    return if (v1 < v2) -1 else if (v1 > v2) 1 else 0;
  }
  /**
		Produce `true`if `v1` and `v2` are eaual, `false` otherwise.
	**/
  static public function equals(v1: Float, v2: Float) {
    return v1 == v2;
  }
  /**
		Produce String of Float.
	**/
  static public function toString(v: Float): String {
    return "" + v;
  }
  /**
		Produce Int of Float.
	**/
  static public function toInt(v: Float): Int {
    return Std.int(v);
  }
  /**
		Add two Floats.
	**/
  static public inline function add(a:Float,b:Float):Float{
		return a + b;
	}
	/**
		Subtract `b` from `a`.
	**/
	static public inline function sub(a:Float,b:Float):Float{
		return a - b;
	}
	/**
		Divide `a` by `b`.
	**/
	static public inline function div(a:Float,b:Float):Float{
		return a / b;
	}
	/**
		Multiply `a` by `b`.
	**/
	static public inline function mul(a:Float,b:Float):Float{
		return a * b;
	}
	/**
		Mod `a` by `b`.
	**/
	static public inline function mod(a:Float,b:Float):Float{
		return a % b;
	}
}