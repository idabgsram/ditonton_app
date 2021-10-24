import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:ditonton/domain/entities/tv_seasons.dart';
import 'package:ditonton/presentation/pages/tv_episodes_detail_page.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_seasons_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class TVSeasonsDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-shows/seasons/detail';

  final int id;
  final int seasonNumber;
  TVSeasonsDetailPage({required this.id, required this.seasonNumber});

  @override
  _TVSeasonsDetailPageState createState() => _TVSeasonsDetailPageState();
}

class _TVSeasonsDetailPageState extends State<TVSeasonsDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TVSeasonsDetailNotifier>(context, listen: false)
          .fetchTVSeasonsDetail(widget.id, widget.seasonNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TVSeasonsDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvSeasonsState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvSeasonsState == RequestState.Loaded) {
            final tvSeasonsData = provider.tvSeasonsData;
            return SafeArea(
              child:
                  DetailContent(tvSeasonsData, widget.id, widget.seasonNumber),
            );
          } else {
            return Text(provider.message,key: Key('provider_message'));
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TVSeasons tvSeasonsData;
  final int tvId, seasonNumber;

  DetailContent(this.tvSeasonsData, this.tvId, this.seasonNumber);

  @override
  Widget build(BuildContext context) {
    final isPosterAvailable = tvSeasonsData.posterPath != null;
    final screenWidth = MediaQuery.of(context).size.width;
    return isPosterAvailable
        ? Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                    'https://image.tmdb.org/t/p/w500${tvSeasonsData.posterPath}',
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
            if (tvSeasonsData.airDate!=null && tvSeasonsData.airDate!.length > 0)
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
          onTap: () {
            Navigator.pushNamed(
              context,
              TVEpisodesDetailPage.ROUTE_NAME,
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
                      imageUrl: episodeData.stillPath != null
                          ? '$BASE_IMAGE_URL${episodeData.stillPath}'
                          : '$NO_IMAGE_URL',
                      width: 145,
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
                      if (episodeData.airDate.length > 0)
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
