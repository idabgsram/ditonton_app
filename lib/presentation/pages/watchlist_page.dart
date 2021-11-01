import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
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
            child: CircularProgressIndicator(),
          );
        } else if (state is DataAvailable) {
          return ListView.builder(
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
      key: Key('consumer_tv'),
      builder: (context, state) {
        if (state is DataTVLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DataTVAvailable) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final tv = state.tvResult[index];
              return ItemCard(tv);
            },
            itemCount: state.tvResult.length,
          );
        } else if (state is DataTVError) {
          return Center(
            key: Key('error_message'),
            child: Text(state.tvMessage),
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
