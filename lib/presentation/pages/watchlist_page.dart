import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchlistMoviesBloc>().add(GetWatchlistMoviesData()));
    Future.microtask(
        () => context.read<WatchlistTVBloc>().add(GetWatchlistTVData()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistMoviesBloc>().add(GetWatchlistMoviesData());
    context.read<WatchlistTVBloc>().add(GetWatchlistTVData());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Watchlist'),
            leading: IconButton(
              key: Key('back_button'),
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: const TabBar(
              indicatorColor: Colors.yellowAccent,
              tabs: [
                Tab(icon: Icon(Icons.movie), text: "Movies"),
                Tab(icon: Icon(Icons.tv), text: "TV Shows"),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(children: [_buildMoviesBody(), _buildTVsBody()]),
          ),
        ));
  }

  Widget _buildMoviesBody() {
    return BlocBuilder<WatchlistMoviesBloc, WatchlistMoviesState>(
      key: Key('bloc_movies'),
      builder: (context, state) {
        if (state is DataLoading) {
          return Center(
            key: Key('loading_indicator'),
            child: CircularProgressIndicator(),
          );
        } else if (state is DataAvailable) {
          return state.result.length < 1
              ? Center(
                  key: Key('empty_list'),
                  child: Text(
                    'Masih kosong nih..',
                    style: kHeading6,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
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
    );
  }

  Widget _buildTVsBody() {
    return BlocBuilder<WatchlistTVBloc, WatchlistTVState>(
      key: Key('bloc_tv'),
      builder: (context, state) {
        if (state is DataTVLoading) {
          return Center(
            key: Key('loading_tv_indicator'),
            child: CircularProgressIndicator(),
          );
        } else if (state is DataTVAvailable) {
          return state.tvResult.length < 1
              ? Center(
                  key: Key('empty_tv_list'),
                  child: Text(
                    'Masih kosong nih..',
                    style: kHeading6,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final tv = state.tvResult[index];
                    return ItemCard(
                      tv,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          TVDetailPage.ROUTE_NAME,
                          arguments: tv.id,
                        );
                      },
                      key: Key('item_tv_$index'),
                    );
                  },
                  itemCount: state.tvResult.length,
                );
        } else if (state is DataTVError) {
          return Center(
            key: Key('error_tv_message'),
            child: Text(state.tvMessage),
          );
        } else {
          return Center(
            key: Key('empty_tv_image'),
            child: Text('Empty'),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
