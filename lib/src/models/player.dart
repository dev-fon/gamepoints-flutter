class Player {
  String name;
  int points;

  Player({this.name, this.points});

  incrementPoints() {
    points++;
  }

  decrementPoints() {
    points--;
  }
}
