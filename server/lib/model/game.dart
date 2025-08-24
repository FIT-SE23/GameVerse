import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import "../config/config.dart";

class Game {
  final String? gameId;
  final String? publisherId;
  final String? name;
  final String? description;
  final String? briefDescription;
  final String? requirement;
  final double? price;
  final int? recommend;
  final DateTime? releaseDate;
  final List<Category>? categories;
  final List<Resource>? resources;
  final GameSale? gameSale;

  const Game({
    this.gameId,
    this.publisherId,
    this.name,
    this.description,
    this.briefDescription,
    this.requirement,
    this.categories,
    this.resources,
    this.price,
    this.recommend,
    this.releaseDate,
    this.gameSale,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final gameid = json["gameid"] as String?;
    final publisherid = json["publisherid"] as String?;
    final name = json["name"] as String?;
    final description = json["description"] as String?;
    final briefDescription = json["briefdescription"] as String?;
    final requirement = json["requirement"] as String?;
    final price = json["price"]?.toDouble() as double?;
    final recommend = json["recommend"]?.toInt() as int?;
    final releaseDate = DateTime.parse(json["releasedate"] as String? ?? "");
    final categories = <Category>[];
    for (var category in json["Category"] as List<dynamic>) {
      categories.add(Category.fromJson(category as Map<String, dynamic>));
    }

    final resources = <Resource>[];
    for (var resource in json["Resource"] as List<dynamic>) {
      resources.add(Resource.fromJson(resource as Map<String, dynamic>));
    }
    GameSale? gameSale = null;
    if (json["Game_Sale"] != null) {
      gameSale = GameSale.fromJson(json["Game_Sale"] as Map<String, dynamic>);
    }

    return Game(
      gameId: gameid,
      publisherId: publisherid,
      name: name,
      description: description,
      briefDescription: briefDescription,
      requirement: requirement,
      price: price,
      recommend: recommend,
      releaseDate: releaseDate,
      categories: categories,
      resources: resources,
      gameSale: gameSale,
    );
  }

  @override
  String toString() {
    return "Game {gameid: " +
        (this.gameId ?? "\"\"") +
        ", publisherid: " +
        (this.publisherId ?? "\"\"") +
        ", name: " +
        (this.name ?? "\"\"") +
        ", description: " +
        (this.description ?? "\"\"") +
        ", briefdescription: " +
        (this.briefDescription ?? "\"\"") +
        ", requirement: " +
        (this.requirement ?? "\"\"") +
        ", price: " +
        this.price.toString() +
        ", recommend: " +
        this.recommend.toString() +
        ", releasedate: " +
        this.releaseDate.toString() +
        ", categories: " +
        this.categories.toString() +
        ", resources: " +
        this.resources.toString() +
        ", gamesale: " +
        this.gameSale.toString() +
        "}";
  }
}
