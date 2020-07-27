package stx.nano;
  
/**
  abstract of `Pos`, the parser will not inject this type if you use it so: `?pos:Position`, use `Pos` and then lift it in the function.
**/
@:using(stx.nano.Position.PositionLift)
@:forward abstract Position(Pos) from Pos to Pos{
  static public var ZERO(default,never) : Pos = make(null,null,null,null);
  static public var _(default,never) = PositionLift;

  
  public function new(self:Pos) this = self;
  static public inline function lift(pos:Pos):Position return fromPos(pos);
  

  static public function make(fileName:String,className:String,methodName:String,lineNumber:Null<Int>,?customParams:Array<Dynamic>):Pos{ 
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
  
  @:from static public function fromPos(pos:Pos):Position{
    return new Position(pos);
  }
  #if (!macro)
    public function toString():String{
      return _.toStringClassMethodLine(this);
    }
  #else
    public function toString() {
      return Std.string(this);
    }
  #end

  static public function here(?pos:Pos) {
    return pos;
  } 
}
class PositionLift {
  static public function toString(pos:Pos){
    if (pos == null) return ':pos ()';
    #if !macro
      var f   = pos.fileName;
      var cls = pos.className;
      var fn  = pos.methodName;
      var ln  = pos.lineNumber;
      return ':pos (object :file_name $fn :class_name $cls :method_name $fn  :line_number $ln)';
    #else
      return '<unknown>';
    #end
  }
  static public function clone(p:Pos){
    return 
      #if !macro 
        Position.make(p.fileName,p.className,p.methodName,p.lineNumber,p.customParams);
      #else
        p;
      #end
  }
  static public function withFragmentName(pos:Pos):String{
    #if !macro
      var f   = pos.fileName;
      var cls = pos.className;
      var fn  = pos.methodName;
      var ln  = pos.lineNumber;

      return '${cls}.${fn}';
    #else
      return '<unknown>';
    #end
  }
  static public function toStringClassMethodLine(pos:Pos){
    #if !macro
      var f   = pos.fileName;
      var cls = pos.className;
      var fn  = pos.methodName;
      var ln  = pos.lineNumber;

      var class_method = withFragmentName(pos);
      return '($class_method@${pos.lineNumber})';
    #else
      return '<unknown>';
    #end
  }
  static public function withCustomParams(p:Pos,v:Dynamic):Pos{
    p = clone(p);
    #if !macro
      if(p.customParams == null){
        p.customParams = [];
      };
      p.customParams.push(v);
    #end
    return p;
  }
}