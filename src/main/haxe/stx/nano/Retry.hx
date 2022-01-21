package stx.nano;

class Retry{
  public final attempts : Int;
  public final duration : Float;

  public function new(attempts,duration){
    this.attempts = attempts;
    this.duration = duration;
  }
  public function copy(?attempts,?duration){
    return new Retry(
      __.option(attempts).defv(this.attempts),
      __.option(duration).defv(this.duration)
    );
  }
}