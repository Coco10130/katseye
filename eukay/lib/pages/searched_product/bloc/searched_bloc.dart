import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'searched_event.dart';
part 'searched_state.dart';

class SearchedBloc extends Bloc<SearchedEvent, SearchedState> {
  SearchedBloc() : super(SearchedInitial()) {
    on<SearchedEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
