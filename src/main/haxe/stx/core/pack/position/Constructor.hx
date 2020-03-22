package stx.core.pack.position;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();

  public function make(fileName:String,className:String,methodName:String,lineNumber:Null<Int>,?customParams:Array<Dynamic>):Pos{ 
    return
      #if macro
        (null:haxe.macro.Expr.Position);
      #else
        {
          fileName   : fileName,
          className  : className,
          methodName : methodName,
          lineNumber : lineNumber,
          customParams : customParams
        };
      #end
  }
}