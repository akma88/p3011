import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:p3011/core/error/failure.dart';
import 'package:p3011/core/usercases/usecase.dart';
import 'package:p3011/feature/domain/repositories/person_repository.dart';
import 'package:p3011/feature/domain/entities/person_entity.dart';
import 'package:meta/meta.dart';

class SearchPerson extends UseCase<List<PersonEntity>, SearchPersonParams> {
  final PersonRepository personRepository;

  SearchPerson(this.personRepository);

  Future<Either<Failure, List<PersonEntity>>> call(
    SearchPersonParams params,
  ) async {
    return await personRepository.searchPerson(params.query);
  }
}

class SearchPersonParams extends Equatable {
  final String query;

  SearchPersonParams({required this.query});

  @override
  List<Object?> get props => [query];
}
