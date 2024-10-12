import 'dart:async';

import 'package:eukay/pages/check_out/mappers/order_model.dart';
import 'package:eukay/pages/check_out/repo/check_out_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'check_out_event.dart';
part 'check_out_state.dart';

class CheckOutBloc extends Bloc<CheckOutEvent, CheckOutState> {
  final CheckOutRepository _checkOutRepository;
  CheckOutBloc(this._checkOutRepository) : super(CheckOutInitial()) {
    on<FetchOrderSummaryEvent>(fetchOrderSummaryEvent);
    on<CheckOutOrdersEvent>(checkOutOrdersEvent);
  }

  FutureOr<void> fetchOrderSummaryEvent(
      FetchOrderSummaryEvent event, Emitter<CheckOutState> emit) async {
    emit(CheckOutLoadingState());
    try {
      final response = await _checkOutRepository.fetchOrders(event.token);

      emit(FetchCheckOutSuccessState(products: response));
    } catch (e) {
      emit(FetchCheckOutFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> checkOutOrdersEvent(
      CheckOutOrdersEvent event, Emitter<CheckOutState> emit) async {
    emit(CheckOutLoadingState());
    try {
      final response = await _checkOutRepository.checkOutOrders(event.token);

      if (response.isNotEmpty) {
        emit(CheckOutSuccessState(
            newToken: response,
            successMessage: "Order Checked out successfully"));
      } else {
        print(response);
      }
    } catch (e) {
      emit(CheckOutFailedState(errorMessage: e.toString()));
    }
  }
}
