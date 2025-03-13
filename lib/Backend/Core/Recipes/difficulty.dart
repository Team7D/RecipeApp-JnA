class Difficulty {
  late final Level _level; // e.g., Easy, Medium, Hard

  Difficulty({required String level}){
    switch(level){
      case "Easy":
        _level = Level.Easy;
        break;
      case "Medium":
        _level = Level.Medium;
        break;
      case "Hard":
        _level = Level.Hard;
        break;
    }
  }

  Level getLevel() => _level;
}

enum Level{
  Easy,
  Medium,
  Hard
}
