import 'package:flutter/material.dart';

class Cast {
  List<Actor> actores = [];

  Cast();

  Cast.fromJsonList(List<dynamic> jsonList) {
    // if (jsonList == null) return;

    // Otra forma:
    // for (var item in jsonList) {
    //   final actor = new Actor.fromJsonMap(item);
    //   actores.add(actor);
    // }

    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
    });
  }
}

class Actor {
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;
  int? castId;
  String? character;
  String? creditId;
  int? order;

  Actor({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    this.creditId,
    this.order,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    adult = json['adult'];
    gender = json['gender'];
    id = json['id'];
    knownForDepartment = json['known_for_department'];
    name = json['name'];
    originalName = json['original_name'];
    popularity = json['popularity'];
    profilePath = json['profile_path'];
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    order = json['order'];
  }

  getFoto() {
    if (profilePath == null) {
      return 'https://via.placeholder.com/150x200';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}
