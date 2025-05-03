class Time {
  final int _preparationTime; // Time in minutes
  final int _cookingTime; // Time in minutes

  Time(this._preparationTime, this._cookingTime);

  int getPrepTime() => _preparationTime;

  int getCookingTime() => _cookingTime;

  int getTotalTime() {
    return _preparationTime + _cookingTime;
  }
}
