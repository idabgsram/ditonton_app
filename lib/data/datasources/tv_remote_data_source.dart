import 'dart:convert';

import 'package:ditonton/common/connection.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_episodes_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_seasons_model.dart';

abstract class TVRemoteDataSource {
  Future<List<TVModel>> getOnTheAirTV();
  Future<List<TVModel>> getPopularTV();
  Future<List<TVModel>> getTopRatedTV();
  Future<TVDetailResponse> getTVDetail(int id);
  Future<List<TVModel>> getTVRecommendations(int id);
  Future<TVSeasonsResponse> getTVSeasonsDetail(int tvId, int seasonNumber);
  Future<TVEpisodesModel> getTVEpisodesDetail(
      int tvId, int seasonNumber, int epsNumber);
  Future<List<TVModel>> searchTV(String query);
}

class TVRemoteDataSourceImpl implements TVRemoteDataSource {
  static const API_KEY = 'api_key=76315bd76ea937981aa95c14d71bbac8';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final Connection _client = Connection();

  TVRemoteDataSourceImpl();

  @override
  Future<List<TVModel>> getOnTheAirTV() async {
    final response =
        await _client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVDetailResponse> getTVDetail(int id) async {
    final response = await _client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TVDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getTVRecommendations(int id) async {
    final response = await _client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getPopularTV() async {
    final response =
        await _client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getTopRatedTV() async {
    final response =
        await _client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVSeasonsResponse> getTVSeasonsDetail(
      int tvId, int seasonNumber) async {
    final response = await _client
        .get(Uri.parse('$BASE_URL/tv/$tvId/season/$seasonNumber?$API_KEY'));
    if (response.statusCode == 200) {
      return TVSeasonsResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVEpisodesModel> getTVEpisodesDetail(
      int tvId, int seasonNumber, int epsNumber) async {
    final response = await _client.get(Uri.parse(
        '$BASE_URL/tv/$tvId/season/$seasonNumber/episode/$epsNumber?$API_KEY'));
    if (response.statusCode == 200) {
      return TVEpisodesModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> searchTV(String query) async {
    final response = await _client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}
