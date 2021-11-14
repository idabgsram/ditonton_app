import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:tv_shows/domain/entities/tv_episodes.dart';
import 'package:tv_shows/presentation/bloc/tv_episodes_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TVEpisodesDetailPage extends StatefulWidget {

  final int id, seasonNumber, epsNumber;
  final BaseCacheManager? cacheManager;
  TVEpisodesDetailPage(
      {required this.id,
      required this.seasonNumber,
      required this.epsNumber,
      this.cacheManager});

  @override
  _TVEpisodesDetailPageState createState() => _TVEpisodesDetailPageState();
}

class _TVEpisodesDetailPageState extends State<TVEpisodesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<TVEpisodesDetailBloc>()
        .add(FetchData(widget.id, widget.seasonNumber, widget.epsNumber)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVEpisodesDetailBloc, TVEpisodesDetailState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataAvailable) {
            final tvEpisodesData = state.result;
            return SafeArea(
              child: DetailContent(tvEpisodesData,
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
  final TVEpisodes tvEpisodesData;
  final BaseCacheManager? cacheManager;

  DetailContent(this.tvEpisodesData, {this.cacheManager});

  @override
  Widget build(BuildContext context) {
    final isPosterAvailable = tvEpisodesData.stillPath != null;
    final screenWidth = MediaQuery.of(context).size.width;
    return isPosterAvailable
        ? Stack(
            children: [
              CachedNetworkImage(
                key: Key('cached_image_poster'),
                cacheManager: cacheManager,
                imageUrl:
                    'https://image.tmdb.org/t/p/w500${tvEpisodesData.stillPath}',
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
                  initialChildSize: 0.8,
                  minChildSize: 0.8,
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
                "Episode ${tvEpisodesData.episodeNumber}",
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
              tvEpisodesData.name,
              style: kHeading5,
            ),
            Text('Aired on ${tvEpisodesData.airDate}'),
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
              tvEpisodesData.overview.length < 3
                  ? "-"
                  : tvEpisodesData.overview,
            ),
            if (tvEpisodesData.guestStars.length > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey.withOpacity(.2)),
                  SizedBox(height: 8),
                  Text(
                    'Guest Star',
                    style: kHeading6,
                  ),
                  Container(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final crewItem = tvEpisodesData.guestStars[index];
                        return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: _crewItem(crewItem));
                      },
                      itemCount: tvEpisodesData.guestStars.length,
                    ),
                  )
                ],
              ),
            if (tvEpisodesData.crew.length > 0)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 8),
                Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(.2)),
                SizedBox(height: 8),
                Text(
                  'Crew',
                  style: kHeading6,
                ),
                Container(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final crewItem = tvEpisodesData.crew[index];
                      return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _crewItem(crewItem));
                    },
                    itemCount: tvEpisodesData.crew.length,
                  ),
                )
              ]),
          ],
        ),
      ),
    );
  }

  Widget _crewItem(Crew crewData) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
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
                      crewData.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    Text(
                      crewData.job ?? crewData.character ?? "-",
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
                  key: Key('cached_image_crew_${crewData.id}'),
                  cacheManager: cacheManager,
                  imageUrl: crewData.profilePath != null
                      ? '$BASE_IMAGE_URL${crewData.profilePath}'
                      : '$NO_IMAGE_URL',
                  width: 80,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                      key: Key('cached_image_crew_error_${crewData.id}'),
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
