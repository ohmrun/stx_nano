package stx.core.pack;

enum Failure<T>{
  ERR(spec:FailCode);
  ERR_OF(v:T);
}