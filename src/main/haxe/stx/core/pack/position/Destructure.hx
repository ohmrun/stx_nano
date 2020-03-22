package stx.core.pack.position;

class Destructure extends Clazz{
  public function toString(pos:Pos){
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
  public function clone(p:Pos){
    return 
      #if macro 
        p;
      #else
        Position.make(p.fileName,p.className,p.methodName,p.lineNumber,p.customParams);
      #end
  }
  public function withFragmentName(pos:Pos):String{
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
  public function toStringClassMethodLine(pos:Pos){
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
  public function withCustomParams(v:Dynamic,p:Pos):Pos{
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