import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:p3011/core/error/failure.dart';
import 'package:p3011/feature/domain/usercases/search_person.dart';
import 'package:p3011/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:p3011/feature/presentation/bloc/search_bloc/search_state.dart';

const serverFailureMessage = 'Server Failure';
const cachedFailureMessage = 'Cache Failure';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmpty()) {
    on<SearchPersons>(_onSearchPersons);
  }

  Future<void> _onSearchPersons(
    SearchPersons event,
    Emitter<PersonSearchState> emit,
  ) async {
    emit(PersonSearchLoading());
    final result = await searchPerson(
      SearchPersonParams(query: event.personQuery),
    );
    emit(
      result.fold(
        (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
        (persons) => PersonSearchLoaded(persons: persons),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure():
        return serverFailureMessage;
      case CacheFailure():
        return cachedFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
