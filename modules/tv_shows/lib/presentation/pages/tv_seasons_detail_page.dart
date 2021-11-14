import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:tv_shows/domain/entities/tv_episodes.dart';
import 'package:tv_shows/domain/entities/tv_seasons.dart';
import 'package:tv_shows/presentation/bloc/tv_seasons_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TVSeasonsDetailPage extends StatefulWidget {

  final int id;
  final int seasonNumber;
  final BaseCacheManager? cacheManager;
  TVSeasonsDetailPage(
      {required this.id, required this.seasonNumber, this.cacheManager});

  @override
  _TVSeasonsDetailPageState createState() => _TVSeasonsDetailPageState();
}

class _TVSeasonsDetailPageState extends State<TVSeasonsDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<TVSeasonsDetailBloc>()
        .add(FetchData(widget.id, widget.seasonNumber)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVSeasonsDetailBloc, TVSeasonsDetailState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataAvailable) {
            final tvSeasonsData = state.result;
            return SafeArea(
              child: DetailContent(
                  tvSeasonsData, widget.id, widget.seasonNumber,
                  cacheManager: widget.cacheManager),
            );
          } else if (state is DataError) {
            return Text(state.message, key: Key('provider_message'));
          } else {
            return Center(
              key: Key('empty_image'),
              child: Text('Empty'),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TVSeasons tvSeasonsData;
  final int tvId, seasonNumber;
  final BaseCacheManager? cacheManager;

  DetailContent(this.tvSeasonsData, this.tvId, this.seasonNumber,
      {this.cacheManager});

  @override
  Widget build(BuildContext context) {
    final isPosterAvailable = tvSeasonsData.posterPath != null;
    final screenWidth = MediaQuery.of(context).size.width;
    return isPosterAvailable
        ? Stack(
            children: [
              CachedNetworkImage(
                key: Key('cached_image_poster'),
                cacheManager: cacheManager,
                imageUrl:
                    'https://image.tmdb.org/t/p/w500${tvSeasonsData.posterPath}',
                width: screenWidth,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, key: Key('cached_image_poster_error')),
              ),
              Container(
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
                          _detailBody(context,
                              scrollController: scrollController),
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
                    key: Key('back_button'),
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            ],
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                key: Key('back_button_no_poster'),
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                tvSeasonsData.name,
              ),
            ),
            body: _detailBody(context, isPosterAvailable: isPosterAvailable),
          );
  }

  Widget _detailBody(BuildContext mainContext,
      {ScrollController? scrollController, bool isPosterAvailable = true}) {
    return Container(
      padding: isPosterAvailable
          ? null
          : const EdgeInsets.only(
              left: 16,
              top: 16,
              right: 16,
            ),
      margin: EdgeInsets.only(top: isPosterAvailable ? 16 : 0),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tvSeasonsData.name,
              style: kHeading5,
            ),
            if (tvSeasonsData.airDate != null &&
                tvSeasonsData.airDate!.length > 0)
              Text('Aired on ${tvSeasonsData.airDate}'),
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
              tvSeasonsData.overview.length < 3 ? "-" : tvSeasonsData.overview,
            ),
            SizedBox(height: 8),
            Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey.withOpacity(.2)),
            SizedBox(height: 8),
            Text(
              'Episodes',
              style: kHeading6,
            ),
            Container(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final episodesItem = tvSeasonsData.episodes[index];
                  return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: _episodesItem(mainContext, episodesItem));
                },
                itemCount: tvSeasonsData.episodes.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _episodesItem(BuildContext context, TVEpisodes episodeData) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          key: Key('episodes_item_tap'),
          onTap: () {
            Navigator.pushNamed(
              context,
              TV_EPISODES_DETAIL_ROUTE,
              arguments: {
                'id': tvId,
                'seasonNumber': seasonNumber,
                'epsNumber': episodeData.episodeNumber
              },
            );
          },
          child: Card(
            color: Colors.white.withOpacity(.1),
            child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  top: 8,
                  bottom: 8,
                  right: 13,
                ),
                child: Row(children: [
                  ClipRRect(
                    child: CachedNetworkImage(
                      key: Key('cached_image_episodes_${episodeData.id}'),
                      cacheManager: cacheManager,
                      imageUrl: episodeData.stillPath != null
                          ? '$BASE_IMAGE_URL${episodeData.stillPath}'
                          : '$NO_IMAGE_URL',
                      width: 145,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                          key: Key('cached_image_episodes_error_${episodeData.id}'),
                          height: 120,
                          color: Colors.black38,
                          child: Icon(Icons.error)),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Episode ${episodeData.episodeNumber}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kHeading6,
                      ),
                      if (episodeData.name !=
                          "Episode ${episodeData.episodeNumber}")
                        Text(
                          episodeData.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (episodeData.airDate != null &&
                          episodeData.airDate!.length > 0)
                        Text(
                          'Aired on ${episodeData.airDate}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ])),
          ),
        ));
  }
}
