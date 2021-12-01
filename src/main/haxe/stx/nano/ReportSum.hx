package stx.nano;

@:using(stx.nano.Report.ReportLift)
enum ReportSum<T>{
  Reported(v:Error<T>);
  Happened;
}