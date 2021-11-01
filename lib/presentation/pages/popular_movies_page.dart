import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/movies/popular';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PopularMoviesBloc>().add(FetchData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
        leading: IconButton(
          key: Key('back_button'),
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
          builder: (context, state) {
            if (state is DataLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataAvailable) {
              return ListView.builder(
                key: Key('popular_movies_lv'),
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return ItemCard(
                    movie,
                    isMovies: true,
                  );
                },
                itemCount: state.result.length,
              );
            } else if (state is DataError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }else{
              return Center(
                key: Key('empty_image'),
                child: Text('Empty'),
              );
            }
          },
        ),
      ),
    );
  }
}
