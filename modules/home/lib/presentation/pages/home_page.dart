import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:home/presentation/bloc/home_now_playing_movies_bloc.dart';
import 'package:home/presentation/bloc/home_ota_tv_bloc.dart';
import 'package:home/presentation/bloc/home_popular_movies_bloc.dart';
import 'package:home/presentation/bloc/home_popular_tv_bloc.dart';
import 'package:home/presentation/bloc/home_top_rated_movies_bloc.dart';
import 'package:home/presentation/bloc/home_top_rated_tv_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<HomeNowPlayingMoviesBloc>()
        .add(FetchNowPlayingMoviesData()));
    Future.microtask(() =>
        context.read<HomePopularMoviesBloc>().add(FetchPopularMoviesData()));
    Future.microtask(() =>
        context.read<HomeTopRatedMoviesBloc>().add(FetchTopRatedMoviesData()));
    Future.microtask(() => context.read<HomeOTATVBloc>().add(FetchOTATVData()));
    Future.microtask(
        () => context.read<HomePopularTVBloc>().add(FetchPopularTVData()));
    Future.microtask(
        () => context.read<HomeTopRatedTVBloc>().add(FetchTopRatedTVData()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/circle-g.png'),
                  ),
                  accountName: Text('Ditonton'),
                  accountEmail: Text('ditonton@dicoding.com'),
                ),
                ListTile(
                  key: Key('home_tile'),
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  key: Key('watchlist_tile'),
                  leading: Icon(Icons.save_alt),
                  title: Text('Watchlist'),
                  onTap: () {
                    FirebaseAnalyticsUtils().logEvent(eventName: 'watchlist');
                    Navigator.pushNamed(context, WATCHLIST_ROUTE);
                  },
                ),
                ListTile(
                  key: Key('about_tile'),
                  onTap: () {
                    FirebaseAnalyticsUtils().logEvent(eventName: 'about');
                    Navigator.pushNamed(context, ABOUT_ROUTE);
                  },
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('Ditonton'),
            bottom: const TabBar(
              indicatorColor: Colors.yellowAccent,
              tabs: [
                Tab(
                    key: Key('movies_tab'),
                    icon: Icon(Icons.movie),
                    text: "Movies"),
                Tab(key: Key('tv_tab'), icon: Icon(Icons.tv), text: "TV Shows"),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  FirebaseAnalyticsUtils().logEvent(eventName: 'search');
                  Navigator.pushNamed(context, SEARCH_ROUTE);
                },
                icon: Icon(Icons.search),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(children: [_buildMoviesBody(), _buildTVsBody()]),
          ),
        ));
  }

  Widget _buildMoviesBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Now Playing',
            style: kHeading6,
          ),
          BlocBuilder<HomeNowPlayingMoviesBloc, HomeNowPlayingMoviesState>(
              builder: (context, state) {
            if (state is DataNowPlayingMoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataNowPlayingMoviesAvailable) {
              return ItemList(state.nowPlayingMoviesResult,
                  isMovies: true,
                  key: Key('nowpl_movies_lv'),
                  itemKey: 'nowpl_movies_item');
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            key: Key('popular_movies_more'),
            title: 'Popular',
            onTap: () {
              FirebaseAnalyticsUtils().logEvent(eventName: 'popular_movies');
              Navigator.pushNamed(context, POPULAR_MOVIES_ROUTE);
            },
          ),
          BlocBuilder<HomePopularMoviesBloc, HomePopularMoviesState>(
              builder: (context, state) {
            if (state is DataPopularMoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataPopularMoviesAvailable) {
              return ItemList(state.popularMoviesResult,
                  isMovies: true,
                  key: Key('popular_movies_lv'),
                  itemKey: 'popular_movies_item');
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            key: Key('toprate_movies_more'),
            title: 'Top Rated',
            onTap: () {
              FirebaseAnalyticsUtils().logEvent(eventName: 'top_rated_movies');
              Navigator.pushNamed(context, TOP_RATED_MOVIES_ROUTE);
            },
          ),
          BlocBuilder<HomeTopRatedMoviesBloc, HomeTopRatedMoviesState>(
              builder: (context, state) {
            if (state is DataTopRatedMoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataTopRatedMoviesAvailable) {
              return ItemList(state.topRatedMoviesResult,
                  isMovies: true,
                  key: Key('toprate_movies_lv'),
                  itemKey: 'toprate_movies_item');
            } else {
              return Text('Failed');
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTVsBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubHeading(
            key: Key('ota_tv_more'),
            title: 'On The Air',
            onTap: () {
              FirebaseAnalyticsUtils().logEvent(eventName: 'ota_tv');
              Navigator.pushNamed(context, ON_THE_AIR_TV_ROUTE);
            },
          ),
          BlocBuilder<HomeOTATVBloc, HomeOTATVState>(builder: (context, state) {
            if (state is DataOTATVLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataOTATVAvailable) {
              return ItemList(state.otaTVResult,
                  key: Key('ota_tv_lv'), itemKey: 'ota_tv_item');
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            key: Key('popular_tv_more'),
            title: 'Popular',
            onTap: () {
              FirebaseAnalyticsUtils().logEvent(eventName: 'popular_tv');
              Navigator.pushNamed(context, POPULAR_TV_ROUTE);
            },
          ),
          BlocBuilder<HomePopularTVBloc, HomePopularTVState>(
              builder: (context, state) {
            if (state is DataPopularTVLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataPopularTVAvailable) {
              return ItemList(state.popularTVResult,
                  key: Key('popular_tv_lv'), itemKey: 'popular_tv_item');
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            key: Key('toprate_tv_more'),
            title: 'Top Rated',
            onTap: () {
              FirebaseAnalyticsUtils().logEvent(eventName: 'top_rated_tv');
              Navigator.pushNamed(context, TOP_RATED_TV_ROUTE);
            },
          ),
          BlocBuilder<HomeTopRatedTVBloc, HomeTopRatedTVState>(
              builder: (context, state) {
            if (state is DataTopRatedTVLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataTopRatedTVAvailable) {
              return ItemList(state.topRatedTVResult,
                  key: Key('toprate_tv_lv'), itemKey: 'toprate_tv_item');
            } else {
              return Text('Failed');
            }
          }),
        ],
      ),
    );
  }

  Row _buildSubHeading(
      {required String title, required Function() onTap, Key? key}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          key: key,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class ItemList extends StatelessWidget {
  final List<dynamic> items;
  final bool isMovies;
  final Key? key;
  final String? itemKey;

  ItemList(this.items, {this.isMovies = false, this.key, this.itemKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        key: key,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: Key((itemKey ?? 'item') + '_' + index.toString()),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  isMovies ? MOVIE_DETAIL_ROUTE : TV_DETAIL_ROUTE,
                  arguments: item.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: item.posterPath != null
                      ? 'https://image.tmdb.org/t/p/w500${item.posterPath}'
                      : '$NO_IMAGE_URL',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}
