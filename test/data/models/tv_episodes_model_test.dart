import 'dart:convert';

import 'package:ditonton/data/models/crew_model.dart';
import 'package:ditonton/data/models/tv_episodes_model.dart';
import 'package:ditonton/domain/entities/crew.dart';
import 'package:ditonton/domain/entities/tv_episodes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTVEpisodesModel = TVEpisodesModel(
    airDate: "2019-01-25",
    crew: [
      CrewModel(
          job: "Animation Director",
          character: "Basketball Captain (voice)",
          name: "Huang Feng",
          id: 2965969,
          profilePath: null)
    ],
    episodeNumber: 3,
    guestStars: [
      CrewModel(
          job: "Animation Director",
          character: "Basketball Captain (voice)",
          name: "Aina Suzuki",
          id: 1661870,
          profilePath: "/bRLwfft4yckDTpLenlbTrt3FRRN.jpg"),
      CrewModel(
          job: "Animation Director",
          character: "Beard Man (voice)",
          name: "Ryota Akazawa",
          id: 3211842,
          profilePath: null)
    ],
    name: "A Mountain of Problems",
    overview: "Nino isn't happy that Futaro is beginning to get along with her sisters, so she takes matters into her own hands.",
    id: 1659817,
    seasonNumber: 1,
    stillPath: "/vkuYEpktTjfZTZcl8XcChR0CN71.jpg",
  );

  final tTVEpisodes = TVEpisodes(
airDate: "2019-01-25",
    crew: [
      Crew(
          job: "Animation Director",
          character: "Basketball Captain (voice)",
          name: "Huang Feng",
          id: 2965969,
          profilePath: null)
    ],
    episodeNumber: 3,
    guestStars: [
      Crew(
          job: "Animation Director",
          character: "Basketball Captain (voice)",
          name: "Aina Suzuki",
          id: 1661870,
          profilePath: "/bRLwfft4yckDTpLenlbTrt3FRRN.jpg"),
      Crew(
          job: "Animation Director",
          character: "Beard Man (voice)",
          name: "Ryota Akazawa",
          id: 3211842,
          profilePath: null)
    ],
    name: "A Mountain of Problems",
    overview: "Nino isn't happy that Futaro is beginning to get along with her sisters, so she takes matters into her own hands.",
    id: 1659817,
    seasonNumber: 1,
    stillPath: "/vkuYEpktTjfZTZcl8XcChR0CN71.jpg",
  );

  test('should be a subclass of Movie entity', () async {
    final result = tTVEpisodesModel.toEntity();
    expect(result, tTVEpisodes);
  });

  group('check fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_episodes.json'));
      // act
      final result = TVEpisodesModel.fromJson(jsonMap);
      // assert
      expect(result, tTVEpisodesModel);
    });
  });

  group('check toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "air_date": "2019-01-25",
        "crew": [
          {
            "job": "Animation Director",
            "character": "Basketball Captain (voice)",
            "name": "Huang Feng",
            "id": 2965969,
            "profile_path": null
          }
        ],
        "episode_number": 3,
        "guest_stars": [
          {
            "job": "Animation Director",
            "character": "Basketball Captain (voice)",
            "id": 1661870,
            "name": "Aina Suzuki",
            "profile_path": "/bRLwfft4yckDTpLenlbTrt3FRRN.jpg"
          },
          {
            "job": "Animation Director",
            "character": "Beard Man (voice)",
            "id": 3211842,
            "name": "Ryota Akazawa",
            "profile_path": null
          }
        ],
        "name": "A Mountain of Problems",
        "overview":
            "Nino isn't happy that Futaro is beginning to get along with her sisters, so she takes matters into her own hands.",
        "id": 1659817,
        "season_number": 1,
        "still_path": "/vkuYEpktTjfZTZcl8XcChR0CN71.jpg"
      };
      // act
      final result = tTVEpisodesModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
