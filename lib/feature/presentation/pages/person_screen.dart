import 'package:flutter/material.dart';
import 'package:p3011/feature/presentation/widgets/custom_search_delegate.dart';
import 'package:p3011/feature/presentation/widgets/persons_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
      ),
      body: PersonsList(),
    );
  }
}
