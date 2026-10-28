import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:p3011/core/error/exception.dart';
import 'package:p3011/feature/data/models/person_model.dart';
import 'package:meta/meta.dart';

abstract class PersonRemoteDataSource {
  Future<List<PersonModel>> getAllPersons(int page);
  Future<List<PersonModel>> searchPerson(String query);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  late final http.Client client;

  PersonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PersonModel>> getAllPersons(int page) =>
      getPersonFromUrl('https://rickandmortyapi.com/api/character/?page=$page');

  @override
  Future<List<PersonModel>> searchPerson(String query) => getPersonFromUrl(
    'https://rickandmortyapi.com/api/character/?name=$query',
  );

  Future<List<PersonModel>> getPersonFromUrl(String url) async {
    print(url);
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final persons = json.decode(response.body);
      return (persons['results'] as List)
          .map((person) => PersonModel.fromJson(person))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
