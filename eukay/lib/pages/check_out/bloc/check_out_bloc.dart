import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'check_out_event.dart';
part 'check_out_state.dart';

class CheckOutBloc extends Bloc<CheckOutEvent, CheckOutState> {
  CheckOutBloc() : super(CheckOutInitial()) {
    on<CheckOutEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
