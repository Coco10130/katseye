part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardInitialFetchState extends DashboardState {
  final List<ProductModel> products;

  DashboardInitialFetchState({required this.products});
}

final class DashboardFetchFailedState extends DashboardState {
  final String errorMessage;

  DashboardFetchFailedState({required this.errorMessage});
}

final class DashboardLoadingState extends DashboardState {}
