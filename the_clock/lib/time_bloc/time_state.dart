import 'package:equatable/equatable.dart';

abstract class TimeState extends Equatable {
  final DateTime _time;

  int get hour => _time.hour;
  int get minute => _time.minute;
  int get second => _time.second;
  int get millisecond => _time.millisecond;

  const TimeState(this._time);

  @override
  List<Object> get props => [hour, minute, second, millisecond];
}

class ActualTimeState extends TimeState {
  ActualTimeState(DateTime time) : super(time);
}
