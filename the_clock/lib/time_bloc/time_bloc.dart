import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class TimeBloc extends Bloc<TimeEvent, TimeState> {
  @override
  TimeState get initialState => ActualTimeState(DateTime.now());

  @override
  Stream<TimeState> mapEventToState(
    TimeEvent event,
  ) async* {
    if (event is UpdateTimeEvent) {
      yield ActualTimeState(DateTime.now());
    }
  }
}
