import 'package:ditonton/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/movies/top-rated';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TopRatedMoviesBloc>().add(FetchData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
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
        child: BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
          builder: (context, state) {
            if (state is DataLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataAvailable) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return ItemCard(
                    movie,
                    isMovies: true,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MovieDetailPage.ROUTE_NAME,
                        arguments: movie.id,
                      );
                    },
                    key: Key('item_$index'),
                  );
                },
                itemCount: state.result.length,
              );
            } else if (state is DataError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
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
