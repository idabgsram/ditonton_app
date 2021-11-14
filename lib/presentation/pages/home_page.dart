import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/home_now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/home_ota_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/home_popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/home_popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/home_top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/home_top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/ota_tv_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
                    Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
                  },
                ),
                ListTile(
                  key: Key('about_tile'),
                  onTap: () {
                    Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
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
                  Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
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
            onTap: () =>
                Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
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
            onTap: () =>
                Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
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
            onTap: () => Navigator.pushNamed(context, OTATVPage.ROUTE_NAME),
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
            onTap: () => Navigator.pushNamed(context, PopularTVPage.ROUTE_NAME),
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
            onTap: () =>
                Navigator.pushNamed(context, TopRatedTVPage.ROUTE_NAME),
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
                  isMovies
                      ? MovieDetailPage.ROUTE_NAME
                      : TVDetailPage.ROUTE_NAME,
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
