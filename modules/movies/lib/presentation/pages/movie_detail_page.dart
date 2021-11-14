import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail_recommendations_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail_watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatefulWidget {

  final int id;
  final BaseCacheManager? cacheManager;
  MovieDetailPage({required this.id, this.cacheManager});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(FetchDetailData(widget.id));
      context
          .read<MovieDetailRecommendationsBloc>()
          .add(FetchRecommendationsData(widget.id));
      context
          .read<MovieDetailWatchlistBloc>()
          .add(LoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataAvailable) {
            return SafeArea(
              child: DetailContent(state.result,
                  cacheManager: widget.cacheManager),
            );
          } else if (state is DataError) {
            return Text(state.message, key: Key('provider_message'));
          } else {
            return Text('Empty');
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final BaseCacheManager? cacheManager;

  DetailContent(this.movie, {this.cacheManager});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          key: Key('cached_image_poster'),
          cacheManager: cacheManager,
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) =>
              Icon(Icons.error, key: Key('cached_image_poster_error')),
        ),
        BlocListener<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
            listener: (context, state) {
              if (state is StatusReceived &&
                  state.message ==
                      MovieDetailWatchlistBloc.watchlistAddSuccessMessage) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is StatusReceived &&
                  state.message ==
                      MovieDetailWatchlistBloc.watchlistRemoveSuccessMessage) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is StatusError) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(state.message),
                    );
                  },
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(top: 48 + 8),
              child: DraggableScrollableSheet(
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: kRichBlack,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      right: 16,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: kHeading5,
                                ),
                                BlocBuilder<MovieDetailWatchlistBloc,
                                        MovieDetailWatchlistState>(
                                    buildWhen: (prev, cur) {
                                  if (cur is StatusError) {
                                    return false;
                                  }
                                  return true;
                                }, builder: (context, state) {
                                  if (state is StatusReceived) {
                                    return ElevatedButton(
                                      key: Key('watchlist_btn'),
                                      onPressed: () async {
                                        if (!state.status) {
                                          context
                                              .read<MovieDetailWatchlistBloc>()
                                              .add(AddWatchlist(movie));
                                        } else {
                                          context
                                              .read<MovieDetailWatchlistBloc>()
                                              .add(RemoveFromWatchlist(movie));
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (state.status)
                                              ? Icon(Icons.check)
                                              : Icon(Icons.add),
                                          Text('Watchlist'),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }),
                                Text(
                                  _showGenres(movie.genres),
                                ),
                                Text(
                                  _showDuration(movie.runtime),
                                ),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: movie.voteAverage / 2,
                                      itemCount: 5,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                      ),
                                      itemSize: 24,
                                    ),
                                    Text('${movie.voteAverage}')
                                  ],
                                ),
                                SizedBox(height: 8),
                                Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.grey.withOpacity(.2)),
                                SizedBox(height: 8),
                                Text(
                                  'Overview',
                                  style: kHeading6,
                                ),
                                Text(
                                  movie.overview.length < 3
                                      ? "-"
                                      : movie.overview,
                                ),
                                SizedBox(height: 8),
                                Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.grey.withOpacity(.2)),
                                SizedBox(height: 8),
                                Text(
                                  'Recommendations',
                                  style: kHeading6,
                                ),
                                BlocBuilder<MovieDetailRecommendationsBloc,
                                    MovieDetailRecommendationsState>(
                                  builder: (context, state) {
                                    if (state is DataRecommendationsLoading) {
                                      return Center(
                                        key: Key('recommendations_center'),
                                        child: CircularProgressIndicator(
                                          key: Key('recommendations_loading'),
                                        ),
                                      );
                                    } else if (state
                                        is DataRecommendationsError) {
                                      return Text(
                                          state.movieRecommendationsMessage,
                                          key: Key('recommendation_message'));
                                    } else if (state
                                        is DataRecommendationsAvailable) {
                                      return Container(
                                        height: 150,
                                        child: state.movieRecommendations
                                                    .length >
                                                0
                                            ? ListView.builder(
                                                key: Key('recommendations_lv'),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  final movie = state
                                                          .movieRecommendations[
                                                      index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: InkWell(
                                                      key: Key(
                                                          'recom_item_$index'),
                                                      onTap: () {
                                                        Navigator
                                                            .pushReplacementNamed(
                                                          context,
                                                          MOVIE_DETAIL_ROUTE,
                                                          arguments: movie.id,
                                                        );
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(8),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          key: Key(
                                                              'cached_image_recom_$index'),
                                                          cacheManager:
                                                              cacheManager,
                                                          imageUrl:
                                                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                          placeholder:
                                                              (context, url) =>
                                                                  Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(
                                                            Icons.error,
                                                            key: Key(
                                                                'cached_image_recom_error_$index'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: state
                                                    .movieRecommendations
                                                    .length,
                                              )
                                            : Text(
                                                'No similar recommendation currently'),
                                      );
                                    } else {
                                      return Container(key: Key('empty_recom'));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            color: Colors.white,
                            height: 4,
                            width: 48,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                // initialChildSize: 0.5,
                minChildSize: 0.25,
                // maxChildSize: 1.0,
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              key: Key('back_button'),
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
