import 'package:core/core.dart';
import 'package:home/presentation/bloc/home_now_playing_movies_bloc.dart';
import 'package:home/presentation/bloc/home_ota_tv_bloc.dart';
import 'package:home/presentation/bloc/home_popular_movies_bloc.dart';
import 'package:home/presentation/bloc/home_popular_tv_bloc.dart';
import 'package:home/presentation/bloc/home_top_rated_movies_bloc.dart';
import 'package:home/presentation/bloc/home_top_rated_tv_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail_recommendations_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail_watchlist_bloc.dart';
import 'package:tv_shows/presentation/bloc/ota_tv_bloc.dart';
import 'package:movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:tv_shows/presentation/bloc/popular_tv_bloc.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/bloc/search_type_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:tv_shows/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:tv_shows/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv_shows/presentation/bloc/tv_detail_recommendations_bloc.dart';
import 'package:tv_shows/presentation/bloc/tv_detail_watchlist_bloc.dart';
import 'package:tv_shows/presentation/bloc/tv_episodes_detail_bloc.dart';
import 'package:tv_shows/presentation/bloc/tv_seasons_detail_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:about/presentation/pages/about_page.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:home/presentation/pages/home_page.dart';
import 'package:tv_shows/presentation/pages/ota_tv_page.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';
import 'package:tv_shows/presentation/pages/popular_tv_page.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';
import 'package:tv_shows/presentation/pages/top_rated_tv_page.dart';
import 'package:tv_shows/presentation/pages/tv_detail_page.dart';
import 'package:tv_shows/presentation/pages/tv_seasons_detail_page.dart';
import 'package:tv_shows/presentation/pages/tv_episodes_detail_page.dart';
import 'package:watchlist/presentation/pages/watchlist_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Connection.initClient();
  di.init();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<HomeTopRatedMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<HomePopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<HomeNowPlayingMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<HomeTopRatedTVBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<HomePopularTVBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<HomeOTATVBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailRecommendationsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTVBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TVDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TVDetailRecommendationsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TVDetailWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTVBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTVBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<OTATVBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TVSeasonsDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TVEpisodesDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTypeBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case POPULAR_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TOP_RATED_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MOVIE_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SEARCH_ROUTE:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WATCHLIST_ROUTE:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case POPULAR_TV_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularTVPage());
            case ON_THE_AIR_TV_ROUTE:
              return CupertinoPageRoute(builder: (_) => OTATVPage());
            case TOP_RATED_TV_ROUTE:
              return CupertinoPageRoute(builder: (_) => TopRatedTVPage());
            case TV_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVDetailPage(id: id),
                settings: settings,
              );
            case TV_SEASONS_DETAIL_ROUTE:
              final arguments = settings.arguments as Map<String, int>;
              return MaterialPageRoute(
                builder: (_) => TVSeasonsDetailPage(
                  id: arguments['id']!,
                  seasonNumber: arguments['seasonNumber']!,
                ),
                settings: settings,
              );
            case TV_EPISODES_DETAIL_ROUTE:
              final arguments = settings.arguments as Map<String, int>;
              return MaterialPageRoute(
                builder: (_) => TVEpisodesDetailPage(
                  id: arguments['id']!,
                  seasonNumber: arguments['seasonNumber']!,
                  epsNumber: arguments['epsNumber']!,
                ),
                settings: settings,
              );
            case SEARCH_ROUTE:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case ABOUT_ROUTE:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
