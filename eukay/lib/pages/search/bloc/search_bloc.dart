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
    on<AddToCartEvent>(addToCartEvent);
  }

  FutureOr<void> fetchSearchedProductEvent(
      FetchSearchedProductEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());
    try {
      final response =
          await _searchRepository.fetchSearchedProduct(event.searchPrompt);

      if (response.isEmpty) {
        return emit(
            SearchProductSuccessEmptyState(message: "No product found"));
      }

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

  FutureOr<void> addToCartEvent(
      AddToCartEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());
    try {
      final response = await _searchRepository.addToCart(
          event.token, event.productId, event.size);

      if (response.isNotEmpty) {
        emit(AddToCartSuccessState(
            successMessage: "Product Added Successfully!", token: response));
      } else {
        emit(AddToCartFailedState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(AddToCartFailedState(errorMessage: e.toString()));
    }
  }
}
