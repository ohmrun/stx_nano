package stx.nano;

@:using(stx.nano.Report.ReportLift)
enum ReportSum<T>{
  Reported(v:Err<T>);
  Happened;
}