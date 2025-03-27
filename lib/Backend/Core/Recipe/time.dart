class Time {
  final String _preparationTime; // Time in minutes
  final String _cookingTime; // Time in minutes

  Time(this._preparationTime, this._cookingTime);

  String getPrepTime() => _preparationTime;

  String getCookingTime() => _cookingTime;

  String getTotalTime() {
    final prep = int.tryParse(_preparationTime) ?? 0;
    final cook = int.tryParse(_cookingTime) ?? 0;
    return "${prep + cook} m";
  }
}
