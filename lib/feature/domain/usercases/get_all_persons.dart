import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:p3011/core/error/failure.dart';
import 'package:p3011/core/usercases/usecase.dart';
import 'package:p3011/feature/data/repositories/person_repository.dart';
import 'package:p3011/feature/domain/entities/person_entity.dart';
import 'package:meta/meta.dart';

class GetAllPersons extends UseCase<List<PersonEntity>, PagePersonParams> {
  final PersonRepository personRepository;

  GetAllPersons(this.personRepository);

  Future<Either<Failure, List<PersonEntity>>> call(
    PagePersonParams params,
  ) async {
    return await personRepository.getAllPersons(params.page);
  }
}

class PagePersonParams extends Equatable {
  final int page;

  PagePersonParams({required this.page});
  @override
  List<Object?> get props => [];
}
