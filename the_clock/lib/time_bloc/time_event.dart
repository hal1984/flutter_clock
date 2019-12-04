import 'package:equatable/equatable.dart';

abstract class TimeEvent extends Equatable {
  const TimeEvent();
}

class UpdateTimeEvent extends TimeEvent {
  @override
  List<Object> get props => [];
}
