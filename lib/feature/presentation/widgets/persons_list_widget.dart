import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p3011/feature/domain/entities/person_entity.dart';
import 'package:p3011/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:p3011/feature/presentation/bloc/person_list_cubit/person_list_state.dart';
import 'package:p3011/feature/presentation/widgets/person_card_widget.dart';

class PersonsList extends StatefulWidget {
  const PersonsList({super.key});

  @override
  State<PersonsList> createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          //BlocProvider.of<PersonListCubit>(context).loadPerson();
          context.read<PersonListCubit>().loadPerson();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonListCubit, PersonState>(
      builder: (context, state) {
        List<PersonEntity> persons = [];
        bool isLoading = false;

        if (state is PersonLoading && state.isFirstFetch) {
          return _loadingIndicator();
        } else if (state is PersonLoading) {
          persons = state.oldPersonsList;
          isLoading = true;
        } else if (state is PersonLoaded) {
          persons = state.personsList;
        } else if (state is PersonError) {
          return Text(
            state.message,
            style: TextStyle(color: Colors.white, fontSize: 25),
          );
        }
        return ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index < persons.length) {
              return PersonCard(person: persons[index], key: null);
            } else {
              Timer(Duration(milliseconds: 30), () {
                if (!mounted || !scrollController.hasClients) return;
                scrollController.jumpTo(
                  scrollController.position.maxScrollExtent,
                );
              });
              return _loadingIndicator();
            }
          },
          separatorBuilder: (context, index) {
            return Divider(color: Colors.grey[400]);
          },
          itemCount: persons.length + (isLoading ? 1 : 0),
        );
      },
    );
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
