package stx.nano;

enum CompilerTargetSum{
  Js;
  Lua;
  Swf;
  Neko;
  Php;

  Cpp;
  Cppia;

  Cs;
  Java;

  Python;

  Hl;
  
  Interp;
}

@:using(stx.nano.CompilerTarget.CompilerTargetLift)
abstract CompilerTarget(CompilerTargetSum) from CompilerTargetSum to CompilerTargetSum{
  static public var _(default,never) = CompilerTargetLift;

  public function new(self) this = self;
  @:noUsing static public function lift(self:CompilerTargetSum):CompilerTarget return new CompilerTarget(self);
  

  public function prj():CompilerTargetSum return this;
  private var self(get,never):CompilerTarget;
  private function get_self():CompilerTarget return lift(this);

  @:noUsing static public function fromString(str:String):CompilerTarget{
    return switch(str){
      case "swf"    : Swf;
      case "js"     : Js;
      case "php"    : Php;
      case "neko"   : Neko;
      case "cpp"    : Cpp;
      case "cs"     : Cs;
      case "java"   : Java;
      case "python" : Python;
      case "lua"    : Lua;
      case "hl"     : Hl;
      case "interp" : Interp;
      default       : 
        trace(str);
        throw __.fault().err(E_ResourceNotFound);
    }
  }
}
class CompilerTargetLift{
  static public function list(){
    return new Enum(CompilerTargetSum).constructs();
  }
  static public function toBuildDirective(target:CompilerTarget):Option<String>{
    return switch (target) {
      case Swf            : Some("swf");
      case Js             : Some("js");
      case Php            : Some("php");
      case Neko           : Some("neko");
      case Cpp            : Some("cpp");
      case Cs             : Some("cs");
      case Java           : Some("java");
      case Python         : Some("python");
      case Lua            : Some("lua");
      case Hl             : Some("hl");
      case Interp         : Some("interp");
      default             : None;
    }
  }
  
  static public function canonical(target:CompilerTarget):String{
    return new EnumValue(target.prj()).constructor();
  }
}