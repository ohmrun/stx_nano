package;

/**
 * `STX` is a global hook for stx libraries used to provide convenient constructors via static extensions.
 * @see https://haxe.org/manual/lf-static-extension.html
 */
enum abstract STX<T>(stx.nano.Wildcard){
  var STX = stx.nano.Wildcard.__;
}
