import 'package:flutter/material.dart';

class ActionModel {
  String name;
  String year;
  String cover;
  Color boxColor;

  ActionModel({
    required this.name,
    required this.year,
    required this.cover,
    required this.boxColor,
  });

  static List<ActionModel> getActions() {
    List<ActionModel> actions = [];

    actions.add(ActionModel(
      name: 'Book 1',
      year: '1998',
      cover: 'assets/images/cover.jpeg',
      boxColor: Color(0xFF393E46),
    ));
    actions.add(ActionModel(
      name: 'Book 2',
      year: '1938',
      cover: 'assets/images/cover.jpeg',
      boxColor: Color(0xFF393E46),
    ));
    actions.add(ActionModel(
      name: 'Rango',
      year: '2298',
      cover: 'assets/images/cover.jpeg',
      boxColor: Color(0xFF393E46),
    ));
    actions.add(ActionModel(
      name: 'Book 4',
      year: '1948',
      cover: 'assets/images/cover.jpeg',
      boxColor: Color(0xFF393E46),
    ));

    return actions;
  }
}
