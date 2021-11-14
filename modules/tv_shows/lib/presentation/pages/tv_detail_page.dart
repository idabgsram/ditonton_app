import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:tv_shows/domain/entities/tv_detail.dart';
import 'package:tv_shows/domain/entities/tv_detail_episodes.dart';
import 'package:tv_shows/domain/entities/tv_detail_season.dart';
import 'package:tv_shows/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv_shows/presentation/bloc/tv_detail_recommendations_bloc.dart';
import 'package:tv_shows/presentation/bloc/tv_detail_watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVDetailPage extends StatefulWidget {
  final int id;
  final BaseCacheManager? cacheManager;
  TVDetailPage({required this.id, this.cacheManager});

  @override
  _TVDetailPageState createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TVDetailBloc>().add(FetchDetailData(widget.id));
      context
          .read<TVDetailRecommendationsBloc>()
          .add(FetchRecommendationsData(widget.id));
      context.read<TVDetailWatchlistBloc>().add(LoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVDetailBloc, TVDetailState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataAvailable) {
            return SafeArea(
                child: DetailContent(state.result,
                    cacheManager: widget.cacheManager));
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
  final TVDetail tv;
  final BaseCacheManager? cacheManager;

  DetailContent(this.tv, {this.cacheManager});

  @override
  Widget build(BuildContext mainContext) {
    final screenWidth = MediaQuery.of(mainContext).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          key: Key('cached_image_poster'),
          cacheManager: cacheManager,
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) =>
              Icon(Icons.error, key: Key('cached_image_poster_error')),
        ),
        BlocListener<TVDetailWatchlistBloc, TVDetailWatchlistState>(
            listener: (context, state) {
              if (state is StatusReceived &&
                  state.message ==
                      TVDetailWatchlistBloc.watchlistAddSuccessMessage) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is StatusReceived &&
                  state.message ==
                      TVDetailWatchlistBloc.watchlistRemoveSuccessMessage) {
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
                                  tv.name,
                                  style: kHeading5,
                                ),
                                if (tv.inProduction)
                                  Text(
                                    "Ongoing",
                                  ),
                                BlocBuilder<TVDetailWatchlistBloc,
                                        TVDetailWatchlistState>(
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
                                              .read<TVDetailWatchlistBloc>()
                                              .add(AddWatchlist(tv));
                                        } else {
                                          context
                                              .read<TVDetailWatchlistBloc>()
                                              .add(RemoveFromWatchlist(tv));
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
                                  _showGenres(tv.genres),
                                ),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: tv.voteAverage / 2,
                                      itemCount: 5,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                      ),
                                      itemSize: 24,
                                    ),
                                    Text('${tv.voteAverage}')
                                  ],
                                ),
                                if (tv.firstAirDate != null)
                                  Text('Aired on ${tv.firstAirDate}'),
                                if (tv.episodeRunTime.length > 0)
                                  Text(
                                    _showDuration(tv.episodeRunTime),
                                  ),
                                Text('Total Episodes : ${tv.numberOfEpisodes}'),
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
                                  tv.overview.length < 3 ? "-" : tv.overview,
                                ),
                                if (tv.lastEpisodeToAir != null)
                                  Column(children: [
                                    SizedBox(height: 8),
                                    Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: Colors.grey.withOpacity(.2)),
                                    SizedBox(height: 8),
                                  ]),
                                if (tv.lastEpisodeToAir != null)
                                  Text(
                                    'Last Episodes${tv.lastEpisodeToAir != null ? ' (Episode ${tv.lastEpisodeToAir!.episodeNumber!})' : ''}',
                                    style: kHeading6,
                                  ),
                                if (tv.lastEpisodeToAir != null &&
                                    (tv.lastEpisodeToAir!.name != null &&
                                            tv.lastEpisodeToAir!.name
                                                    .toString()
                                                    .length >
                                                1 ||
                                        tv.lastEpisodeToAir!.overview != null &&
                                            tv.lastEpisodeToAir!.overview
                                                    .toString()
                                                    .length >
                                                1))
                                  _episodesItem(tv.lastEpisodeToAir!),
                                if (tv.nextEpisodeToAir != null &&
                                    (tv.lastEpisodeToAir!.name != null &&
                                            tv.lastEpisodeToAir!.name
                                                    .toString()
                                                    .length >
                                                1 ||
                                        tv.lastEpisodeToAir!.overview != null &&
                                            tv.lastEpisodeToAir!.overview
                                                    .toString()
                                                    .length >
                                                1))
                                  SizedBox(height: 16),
                                if (tv.nextEpisodeToAir != null &&
                                    (tv.nextEpisodeToAir!.name != null &&
                                            tv.nextEpisodeToAir!.name
                                                    .toString()
                                                    .length >
                                                1 ||
                                        tv.nextEpisodeToAir!.overview != null &&
                                            tv.nextEpisodeToAir!.overview
                                                    .toString()
                                                    .length >
                                                1))
                                  Text(
                                    'Next Episodes',
                                    style: kHeading6,
                                  ),
                                if (tv.nextEpisodeToAir != null &&
                                    (tv.nextEpisodeToAir!.name != null &&
                                            tv.nextEpisodeToAir!.name
                                                    .toString()
                                                    .length >
                                                1 ||
                                        tv.nextEpisodeToAir!.overview != null &&
                                            tv.nextEpisodeToAir!.overview
                                                    .toString()
                                                    .length >
                                                1))
                                  _episodesItem(tv.nextEpisodeToAir!),
                                SizedBox(height: 8),
                                Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.grey.withOpacity(.2)),
                                SizedBox(height: 8),
                                Text(
                                  'Seasons',
                                  style: kHeading6,
                                ),
                                Container(
                                  height: 130,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, index) {
                                      final seasonsItem = tv.seasons[index];
                                      return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: _seasonsItem(mainContext,
                                              index, tv.id, seasonsItem));
                                    },
                                    itemCount: tv.seasons.length,
                                  ),
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
                                BlocBuilder<TVDetailRecommendationsBloc,
                                    TVDetailRecommendationsState>(
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
                                          state.tvRecommendationsMessage,
                                          key: Key('recommendation_message'));
                                    } else if (state
                                        is DataRecommendationsAvailable) {
                                      return Container(
                                        height: 150,
                                        child: state.tvRecommendations.length >
                                                0
                                            ? ListView.builder(
                                                key: Key('recommendations_lv'),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  final tv = state
                                                      .tvRecommendations[index];
                                                  return tv.posterPath != null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: InkWell(
                                                            key: Key(
                                                                'recom_item_$index'),
                                                            onTap: () {
                                                              Navigator
                                                                  .pushReplacementNamed(
                                                                context,
                                                                TV_DETAIL_ROUTE,
                                                                arguments:
                                                                    tv.id,
                                                              );
                                                            },
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    8),
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                key: Key(
                                                                    'cached_image_recom_$index'),
                                                                cacheManager:
                                                                    cacheManager,
                                                                imageUrl:
                                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                                placeholder:
                                                                    (context,
                                                                            url) =>
                                                                        Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                                errorWidget:
                                                                    (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(
                                                                  Icons.error,
                                                                  key: Key(
                                                                      'cached_image_recom_error_$index'),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox.shrink();
                                                },
                                                itemCount: state
                                                    .tvRecommendations.length,
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
                Navigator.pop(mainContext);
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

  String _showDuration(List<int> runtime) {
    if (runtime.length > 1) {
      return "Around ${runtime.last < runtime.first ? runtime.last : runtime.first} - ${runtime.last < runtime.first ? runtime.first : runtime.last} minutes per episode(s)";
    } else {
      return "Around ${runtime.first} minutes per episode(s)";
    }
  }

  Widget _episodesItem(TVDetailEpisodes episodes) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (episodes.name != null && episodes.name!.length > 1)
            Text(
              episodes.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: kHeading6,
            ),
          if (episodes.overview != null && episodes.overview!.length > 1)
            Text(
              episodes.overview!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _seasonsItem(
      BuildContext context, int index, int tvId, TVDetailSeason seasonData) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
            key: Key('seasons_item_$index'),
            onTap: seasonData.episodeCount < 1
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      TV_SEASONS_DETAIL_ROUTE,
                      arguments: {
                        'id': tvId,
                        'seasonNumber': seasonData.seasonNumber
                      },
                    );
                  },
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Card(
                  color: Colors.white.withOpacity(.1),
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 16 + 80 + 16,
                      bottom: 8,
                      right: 13,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seasonData.name ?? "Seasons $index",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kHeading6,
                        ),
                        Text(
                          seasonData.episodeCount < 1
                              ? 'TBA'
                              : '${seasonData.episodeCount} episode(s)${seasonData.airDate != null ? '\n\nAired on ${seasonData.airDate}' : ''}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    bottom: 16,
                  ),
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      key: Key('cached_image_seasons_item_$index'),
                      cacheManager: cacheManager,
                      imageUrl: seasonData.posterPath != null
                          ? '$BASE_IMAGE_URL${seasonData.posterPath}'
                          : '$NO_IMAGE_URL',
                      width: 80,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                          key: Key('cached_image_seasons_error_$index'),
                          height: 120,
                          color: Colors.black38,
                          child: Icon(Icons.error)),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ],
            )));
  }
}
