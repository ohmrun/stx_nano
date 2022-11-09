package stx.nano;

//Todo Jvm
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
      case "cppia"  : Cppia;
      case "cs"     : Cs;
      case "java"   : Java;
      case "python" : Python;
      case "lua"    : Lua;
      case "hl"     : Hl;
      case "interp" : Interp;
      default       : 
        trace(str);
        throw __.fault().explain(_ -> _.e_undefined());
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
      case Cppia          : Some("cppia");
      case Cs             : Some("cs");
      case Java           : Some("java");
      case Python         : Some("python");
      case Lua            : Some("lua");
      case Hl             : Some("hl");
      case Interp         : Some("interp");
      default             : None;
    }
  }
  static public function uses_directory(self:CompilerTarget):Bool{
    return switch(self){
      case Swf | Js | Neko | Cppia | Python | Lua | Hl  | Interp  : false;
      case Php | Cpp | Cs | Java                                  : true;
    }
  }
  static public function uses_file(self:CompilerTarget):Bool{
    return switch(self){
      case Swf | Js | Neko | Cppia | Python | Lua | Hl            : true;
      case Php | Cpp | Cs | Java | Interp                         : false;
    }
  }
  static public function threaded(self:CompilerTarget):Bool{
    return switch(self){
      case Lua | Cpp | Java | Neko |Interp | Cs | Hl | Python : true;
      default : false;
    }
  }
  static public function extension(self:CompilerTarget):Option<String>{
    return switch(self){
      case Js     : Some("js");
      case Lua    : Some("lua");
      case Swf    : Some("swf");
      case Neko   : Some("n");
      case Php    : Some("php");

      case Cpp    : None;
      case Cppia  : Some("cppia");

      case Cs     : None;
      case Java   : None;

      case Python : Some("py");

      case Hl     : Some("hl");
      
      case Interp : None;
    }
  }
  static public function canonical(target:CompilerTarget):String{
    return new EnumValue(target.prj()).ctr();
  }
}