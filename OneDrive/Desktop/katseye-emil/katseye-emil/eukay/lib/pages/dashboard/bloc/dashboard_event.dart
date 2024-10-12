part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

final class FetchProductsInitialEvent extends DashboardEvent {}
