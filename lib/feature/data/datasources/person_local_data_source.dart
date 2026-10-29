import 'dart:convert';

import 'package:p3011/core/error/exception.dart';
import 'package:p3011/feature/data/models/person_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonLocalDataSource {
  Future<List<PersonModel>> getLastPersonsFromCache();
  Future<void> personsToCache(List<PersonModel> persons);
}

const cachedPersonsList = 'CACHED_PERSONS_LIST';

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() async {
    final jsonPersonsList = sharedPreferences.getStringList(cachedPersonsList);
    if (jsonPersonsList != null && jsonPersonsList.isNotEmpty) {
      return Future.value(
        jsonPersonsList
            .map((person) => PersonModel.fromJson(json.decode(person)))
            .toList(),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) async {
    final List<String> jsonPersonsList = persons
        .map((person) => json.encode(person.toJson()))
        .toList();

    await sharedPreferences.setStringList(cachedPersonsList, jsonPersonsList);
  }
}
