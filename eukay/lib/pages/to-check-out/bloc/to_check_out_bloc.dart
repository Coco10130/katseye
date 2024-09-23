import 'package:eukay/pages/to-check-out/repo/to_check_out_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'to_check_out_event.dart';
part 'to_check_out_state.dart';

class ToCheckOutBloc extends Bloc<ToCheckOutEvent, ToCheckOutState> {
  final ToCheckOutRepository _toCheckOutRepository;
  ToCheckOutBloc(this._toCheckOutRepository) : super(ToCheckOutInitial()) {
    on<ToCheckOutEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
