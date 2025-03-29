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
      case "Any":
        _level = Level.None;
        break;
    }
  }

  Level getLevel() => _level;
}

enum Level{
  None,
  Easy,
  Medium,
  Hard
}
