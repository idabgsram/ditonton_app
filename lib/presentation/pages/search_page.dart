import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/search_bloc.dart';
import 'package:ditonton/presentation/bloc/search_type_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchBloc>().add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            BlocBuilder<SearchTypeBloc, SearchTypeState>(
                builder: (context, state) {
              return DropdownButton<String>(
                value: state.type,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.white),
                underline: Container(
                  height: 2,
                  color: Colors.yellowAccent,
                ),
                onChanged: (String? newValue) {
                  context
                      .read<SearchTypeBloc>()
                      .add(SetSearchType(newValue ?? 'Movies'));
                  context
                      .read<SearchBloc>()
                      .add(OnRefreshChanged(newValue ?? 'Movies'));
                },
                items: <String>['Movies', 'TV Shows']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              );
            }),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchTypeBloc, SearchTypeState>(
                builder: (context, searchType) =>
                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is SearchHasData) {
                          final result = state.result;
                          return Expanded(
                            child: result.length < 1
                                ? Center(
                                    child: Text(
                                      'Nggak ketemu nih,\ncoba yang lain?',
                                      style: kHeading6,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemBuilder: (context, index) {
                                      final item = result[index];
                                      return ItemCard(
                                        item,
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            searchType.type == 'Movies'
                                                ? MovieDetailPage.ROUTE_NAME
                                                : TVDetailPage.ROUTE_NAME,
                                            arguments: item.id,
                                          );
                                        },
                                        isMovies: searchType.type ==
                                            'Movies', //data.isMovies,
                                      );
                                    },
                                    itemCount: result.length,
                                  ),
                          );
                        } else if (state is SearchError) {
                          return Expanded(
                            child: Center(
                              child: Text(state.message),
                            ),
                          );
                        } else {
                          return Expanded(
                            child: Center(
                              child: Text(
                                'Mau cari apa nih?',
                                textAlign: TextAlign.center,
                                style: kHeading6,
                              ),
                            ),
                          );
                        }
                      },
                    )),
          ],
        ),
      ),
    );
  }
}
