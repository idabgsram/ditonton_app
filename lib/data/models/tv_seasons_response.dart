import 'package:ditonton/data/models/tv_seasons_model.dart';
import 'package:equatable/equatable.dart';

class TVSeasonsResponse extends Equatable {
  final List<TVSeasonsModel> tvSeasonsList;

  TVSeasonsResponse({required this.tvSeasonsList});

  factory TVSeasonsResponse.fromJson(Map<String, dynamic> json) =>
      TVSeasonsResponse(
        tvSeasonsList: List<TVSeasonsModel>.from(
            (json["results"] as List).map((x) => TVSeasonsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(tvSeasonsList.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [tvSeasonsList];
}
