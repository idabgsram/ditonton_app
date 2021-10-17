import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TVSeasonsDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv-seasons';

  final int id;
  TVSeasonsDetailPage({required this.id});

  @override
  _TVSeasonsDetailPageState createState() => _TVSeasonsDetailPageState();
}

class _TVSeasonsDetailPageState extends State<TVSeasonsDetailPage> {
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
            return Text(provider.message);
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                            Text(
                              _showDuration(tv.episodeRunTime),
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
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            if (tv.lastEpisodeToAir != null)
                              SizedBox(height: 16),
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
                                            1||
                                    tv.nextEpisodeToAir!.overview != null&&
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
                                            1||
                                    tv.nextEpisodeToAir!.overview != null&&
                                        tv.nextEpisodeToAir!.overview
                                                .toString()
                                                .length >
                                            1))
                              _episodesItem(tv.nextEpisodeToAir!),
                            SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            Container(
                              height: 130,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final seasonsItem = tv.seasons[index];
                                  return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: _seasonsItem(
                                          index,
                                          seasonsItem.name,
                                          seasonsItem.episodeCount ?? 1,
                                          seasonsItem.airDate,
                                          seasonsItem.posterPath));
                                },
                                itemCount: tv.seasons.length,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Consumer<TVDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.Loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.recommendationState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.recommendationState ==
                                    RequestState.Loaded) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TVSeasonsDetailPage.ROUTE_NAME,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
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

  String _showDuration(List<int> runtime) {
    if (runtime.length > 1) {
      return "Around ${runtime.last < runtime.first ? runtime.last : runtime.first} - ${runtime.last < runtime.first ? runtime.first : runtime.last} minutes per episode(s)";
    } else {
      return "Around ${runtime.first} minutes per episode(s)";
    }
  }

  Widget _episodesItem(TVEpisodes episodes) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (episodes.name != null)
            Text(
              episodes.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: kHeading6,
            ),
          Text(
            episodes.overview ?? '-',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _seasonsItem(int index, String? seasonsTitle, int episodesCount,
      String? airDate, String? poster) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
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
                      seasonsTitle ?? "Seasons $index",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    Text(
                      episodesCount < 1
                          ? 'TBA'
                          : '$episodesCount episode(s)${airDate != null ? '\n\nAired on $airDate' : ''}',
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
                  imageUrl: '$BASE_IMAGE_URL$poster',
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
        ));
  }
}
