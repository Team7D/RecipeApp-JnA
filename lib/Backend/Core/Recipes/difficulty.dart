class Difficulty {
  late final Level _level; // e.g., "Easy", "Medium", "Hard"

  Difficulty({required Level level}) : _level = level;

  Level getLevel() => _level;
}

enum Level{
  Easy,
  Medium,
  Hard
}
