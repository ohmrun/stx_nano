package stx.nano;
  
/**
  abstract of `Pos`, the parser will not inject this type if you use it so: `?pos:Position`, use `Pos` and then lift it in the function.
**/
@:using(stx.nano.Position.PositionLift)
@:forward abstract Position(Pos) from Pos to Pos{
  static public var ZERO(default,never) : Pos = make(null,null,null,null);
  static public var _(default,never) = PositionLift;

  
  public function new(self:Pos) this = self;
  @:noUsing static public inline function lift(pos:Pos):Position return fromPos(pos);
  

  @:noUsing static public function make(fileName:String,className:String,methodName:String,lineNumber:Null<Int>,?customParams:Array<Dynamic>):Pos{ 
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
  public var fileName(get,never) : String;
  public function get_fileName(){
    return #if macro '<macro>' #else this.fileName #end;
  }
  public var className(get,never) : String;
  public function get_className(){
    return #if macro '<macro>' #else this.className #end;
  }
  public var methodName(get,never) : String;
  public function get_methodName(){
    return #if macro '<macro>' #else this.methodName #end;
  }
  public var lineNummber(get,never) : Int;
  public function get_lineNummber(){
    return #if macro -1 #else this.lineNumber #end;
  }
  public var customParams(get,never) : Array<Dynamic>;
  public function get_customParams(){
    return #if macro [] #else this.customParams #end;
  }
  public function toIdentDef():IdentDef{
    return (this:Pos).toIdentifier().toIdentDef();
  }
  public function toPos():Pos{
    return this;
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
      return '$pos';
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
  static public function to_vscode_clickable_link(pos:Pos){
    #if !macro
      var f   = pos.fileName;
      var cls = pos.className;
      var fn  = pos.methodName;
      var ln  = pos.lineNumber;

      var class_method = withFragmentName(pos);
      return '$f:$ln';
    #else
      return '<unknown>';
    #end
  }
  static public function toString_name_method_line(pos:Pos){
    #if !macro
      var name    = pos.lift().toIdentifier().name;
      var method  = pos.methodName;
      var line     = pos.lineNumber;
      return '$name.$method@$line';
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
  @:deprecated
  static public function identifier(self:Pos):Identifier{
    var valid   = self.toPosition().fileName.split(".").get(0).split(__.sep()).join(".");
    return new Identifier(valid);
  }
  static public inline function toIdentfier(pos:Pos):Identifier{
    return identifier(pos);
  }
}