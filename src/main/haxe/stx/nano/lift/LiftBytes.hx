package stx.nano.lift;

class LiftBytes{
  static public function get(self:haxe.io.Bytes,pos:Int,quantity:ByteSize):Sprig{
    return switch(quantity){
      case I8      : 
        Byteal(NInt(self.get(pos)));
      case I16BE   : 
        final a = self.get(pos);
        final b = self.get(pos+1);
        final r = Bytes.alloc(4);
              r.set(0,b);
              r.set(1,a);
              r.set(2,0);
              r.set(3,0);
        Byteal(NInt(r.getInt32(0)));
      case I16LE   :
        final a = self.get(pos);
        final b = self.get(pos+1);
        final r = Bytes.alloc(4);
              r.set(0,0);
              r.set(1,0);
              r.set(2,a);
              r.set(3,b);
        Byteal(NInt(r.getInt32(0)));
      case UI16BE  :
        final a = self.get(pos);
        final b = self.get(pos+1);
        final r = Bytes.alloc(4);
              r.set(0,b);
              r.set(1,a);
        Byteal(NInt(r.getUInt16(0)));  
      case UI16LE  :
        Byteal(NInt(self.getUInt16(0)));
      case I24BE   :
        final a = self.get(pos);
        final b = self.get(pos+1);
        final c = self.get(pos+2);
        final r = Bytes.alloc(4);
              r.set(0,c);
              r.set(1,b);
              r.set(2,a);
              r.set(3,0);
        Byteal(NInt(r.getInt32(0)));
      case I24LE   :
        final a = self.get(pos);
        final b = self.get(pos+1);
        final c = self.get(pos+2);
        final r = Bytes.alloc(4);
              r.set(0,0);
              r.set(1,a);
              r.set(2,b);
              r.set(3,c);
        Byteal(NInt(r.getInt32(0)));
      case UI24BE  :
        final a = self.get(pos);
        final b = self.get(pos+1);
        final c = self.get(pos+2);
        final r = Bytes.alloc(4);
              r.set(0,c);
              r.set(1,b);
              r.set(2,a);
              r.set(3,0);
        Byteal(NInt(r.getInt32(0)));
      case UI24LE  :
        final a = self.get(pos);
        final b = self.get(pos+1);
        final c = self.get(pos+2);
        final r = Bytes.alloc(4);
              r.set(0,0);
              r.set(1,a);
              r.set(2,b);
              r.set(3,c);
        Byteal(NInt(r.getInt32(0)));
      case I32BE   :
        final a = self.get(pos);
        final b = self.get(pos+1);
        final c = self.get(pos+2);
        final d = self.get(pos+3);
        final r = Bytes.alloc(4);
              r.set(0,d);
              r.set(1,c);
              r.set(2,b);
              r.set(3,a);
        Byteal(NInt(r.getInt32(0)));
      case I32LE   : 
        Byteal(NInt(self.getInt32(0)));
      case FBE     :
        final a = self.get(pos);
        final b = self.get(pos+1);
        final c = self.get(pos+2);
        final d = self.get(pos+3);
        final r = Bytes.alloc(4);
              r.set(0,d);
              r.set(1,c);
              r.set(2,b);
              r.set(3,a);
        Byteal(NFloat(r.getFloat(0)));
      case FLE     :
        Byteal(NFloat(self.getFloat(0)));
      case DBE     :
        final a = self.get(pos);
        final b = self.get(pos+1);
        final c = self.get(pos+2);
        final d = self.get(pos+3);
        final e = self.get(pos+4);
        final f = self.get(pos+5);
        final g = self.get(pos+6);
        final h = self.get(pos+7);

        final r = Bytes.alloc(8);
              r.set(0,h);
              r.set(1,g);
              r.set(2,f);
              r.set(3,e);
              r.set(0,d);
              r.set(1,c);
              r.set(2,b);
              r.set(3,a);
        Byteal(NFloat(r.getDouble(0)));
      case DLE     :
        Byteal(NFloat(self.getDouble(0)));
      case LINE    : 
        Textal(self.toString());
    }
  }
}