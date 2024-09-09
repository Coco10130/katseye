import 'dart:async';
import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/search/repo/search_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  SearchBloc(this._searchRepository) : super(SearchInitial()) {
    on<FetchSearchedProductEvent>(fetchSearchedProductEvent);
    on<FetchViewProductEvent>(fetchViewProductEvent);
  }

  FutureOr<void> fetchSearchedProductEvent(
      FetchSearchedProductEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());
    try {
      final response =
          await _searchRepository.fetchSearchedProduct(event.searchPrompt);

      emit(SearchProductSuccessState(products: response));
    } catch (e) {
      emit(SearchProductFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchViewProductEvent(
      FetchViewProductEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());
    try {
      final response =
          await _searchRepository.fetchViewProduct(event.productId);

      emit(ViewProductSuccessState(product: response));
    } catch (e) {
      emit(ViewProductFailedState(errorMessage: e.toString()));
    }
  }
}
