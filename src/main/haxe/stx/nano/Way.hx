package stx.nano;

@:forward(length,join,tail,head,concat,is_defined) abstract Way(Cluster<String>) from Cluster<String> to Cluster<String>{
  public function new(self) this = self;
  @:noUsing static public function lift(self:Cluster<String>):Way return new Way(self);
  @:noUsing static public function make(self:Cluster<String>):Way return new Way(self);

  @:op([]) static function array_access(self:Way, idx:Int):String;
  @:noUsing static public function unit():Way{
    return lift(Cluster.unit());
  }
  @:from @:noUsing inline static public function fromArray(self:Array<String>){
    return lift(Cluster.lift(self));
  }
  @:noUsing static public function fromPath(path:haxe.io.Path):Way{
    final dir   = haxe.io.Path.directory(path.toString());
    final ext   = path.ext;
    final file  = path.file;
    final name  = ext == null ? file : '${file}.${ext}'; 
    final sep   = path.backslash ? "\\" : "/";
    final data  = dir.split(sep);
          data.push(name);
    return lift(Cluster.lift(data));
  }
  @:noUsing static public function fromStringDotted(self:String){
    return lift(self.split("."));
  }
  public function prj():Cluster<String> return this;
  private var self(get,never):Way;
  private function get_self():Way return lift(this);

  public function snoc(that:String):Way{
    return lift(this.snoc(that));
  }
  public function concat(that:Array<String>):Way{
    return lift(this.concat(that));
  }
  public function toOsString():String{
    return (Std.downcast(this,Array)).join(__.sep()); 
  }
  public function into(name:String):Ident{
    return Ident.make(name,this);
  }
  @:arrayAccess
  public inline function get(i:Int){
    return this[i];
  }
  @:to public function toArray():Array<String>{
    return Std.downcast(this,Array);
  }
  public function up(){
    return lift(this.rdropn(1));
  }
}