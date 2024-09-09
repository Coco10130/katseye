import 'dart:async';

import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/dashboard/repo/dashboard_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepo;
  DashboardBloc(this._dashboardRepo) : super(DashboardInitial()) {
    on<FetchProductsInitialEvent>(fetchProductsInitialEvent);
  }

  FutureOr<void> fetchProductsInitialEvent(
      FetchProductsInitialEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(DashboardLoadingState());
      final response = await _dashboardRepo.fetchProducts();

      emit(DashboardInitialFetchState(products: response));
    } catch (e) {
      emit(DashboardFetchFailedState(errorMessage: e.toString()));
    }
  }
}
