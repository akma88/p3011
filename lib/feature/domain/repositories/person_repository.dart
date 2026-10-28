import 'package:dartz/dartz.dart';
import 'package:p3011/core/error/failure.dart';
import 'package:p3011/feature/domain/entities/person_entity.dart';

abstract class PersonRepository {
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page);
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query);
}
