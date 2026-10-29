import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:p3011/core/error/failure.dart';
import 'package:p3011/feature/domain/entities/person_entity.dart';
import 'package:p3011/feature/domain/usercases/get_all_persons.dart';
import 'package:p3011/feature/presentation/bloc/person_list_cubit/person_list_state.dart';

const serverFailureMessage = 'Server Failure';
const cachedFailureMessage = 'Cache Failure';

class PersonListCubit extends Cubit<PersonState> {
  final GetAllPersons getAllPersons;

  PersonListCubit({required this.getAllPersons}) : super(PersonEmpty());

  int page = 1;

  void loadPerson() async {
    if (state is PersonLoading) return;

    final currentState = state;

    var oldPerson = <PersonEntity>[];
    if (currentState is PersonLoaded) {
      oldPerson = currentState.personsList;
    }

    emit(PersonLoading(oldPerson, isFirstFetch: page == 1));

    final failureOrPerson = await getAllPersons(PagePersonParams(page: page));

    failureOrPerson.fold(
      (error) => emit(PersonError(message: _mapFailureToMessage(error))),
      (character) {
        page++;
        final persons = (state as PersonLoading).oldPersonsList;
        persons.addAll(character);
        emit(PersonLoaded(persons));
      },
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
