package stx.nano;

@:using(stx.nano.Report.ReportLift)
enum ReportSum<T>{
  Reported(v:Exception<T>);
  Happened;
}