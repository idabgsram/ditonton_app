import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_detail_episodes.dart';
import 'package:ditonton/domain/entities/tv_detail_season.dart';
import 'package:ditonton/presentation/pages/tv_seasons_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TVDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-shows/detail';

  final int id;
  TVDetailPage({required this.id});

  @override
  _TVDetailPageState createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TVDetailNotifier>(context, listen: false)
          .fetchTVDetail(widget.id);
      Provider.of<TVDetailNotifier>(context, listen: false)
          .loadTVWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TVDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvState == RequestState.Loaded) {
            final tv = provider.tvData;
            return SafeArea(
              child: DetailContent(
                tv,
                provider.tvRecommendations,
                provider.isAddedToWatchlist,
              ),
            );
          } else {
            return Text(provider.message, key: Key('provider_message'));
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TVDetail tv;
  final List<TV> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tv, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext mainContext) {
    final screenWidth = MediaQuery.of(mainContext).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await Provider.of<TVDetailNotifier>(context,
                                          listen: false)
                                      .addTVWatchlist(tv);
                                } else {
                                  await Provider.of<TVDetailNotifier>(context,
                                          listen: false)
                                      .removeFromTVWatchlist(tv);
                                }

                                final message = Provider.of<TVDetailNotifier>(
                                        context,
                                        listen: false)
                                    .tvWatchlistMessage;

                                if (message ==
                                        TVDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TVDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
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
                                      child: _seasonsItem(mainContext, index,
                                          tv.id, seasonsItem));
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
                            Consumer<TVDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.Loading) {
                                  return Center(
                                    key: Key('recommendations_center'),
                                    child: CircularProgressIndicator(
                                      key: Key('recommendations_loading'),
                                    ),
                                  );
                                } else if (data.recommendationState ==
                                    RequestState.Error) {
                                  return Text(data.message,
                                      key: Key('recommendation_message'));
                                } else if (data.recommendationState ==
                                    RequestState.Loaded) {
                                  return Container(
                                    height: 150,
                                    child: recommendations.length > 0
                                        ? ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final tv = recommendations[index];
                                              return tv.posterPath != null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator
                                                              .pushReplacementNamed(
                                                            context,
                                                            TVDetailPage
                                                                .ROUTE_NAME,
                                                            arguments: tv.id,
                                                          );
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(8),
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
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
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox.shrink();
                                            },
                                            itemCount: recommendations.length,
                                          )
                                        : Text(
                                            'No similar recommendation currently'),
                                  );
                                } else {
                                  return Container();
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
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
            onTap: seasonData.episodeCount < 1
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      TVSeasonsDetailPage.ROUTE_NAME,
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
                      imageUrl: seasonData.posterPath != null
                          ? '$BASE_IMAGE_URL${seasonData.posterPath}'
                          : '$NO_IMAGE_URL',
                      width: 80,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
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
