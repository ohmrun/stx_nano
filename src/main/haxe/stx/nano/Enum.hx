package stx.nano;

abstract Enum<T>(std.Enum<T>) from std.Enum<T>{
  
  public function new(self) this = self;

  public function constructs(){
    return Type.getEnumConstructs(this);
  }
  public function name(){
    return Type.getEnumName(this);
  }
  public function construct(cons:Either<Int,String>,args:Array<Dynamic>):Option<T>{
    return switch(cons){
      case Left(i)  : std.Type.createEnumIndex(this,i,args);
      case Right(s) : std.Type.createEnum(this,s,args);
    }
  }
}