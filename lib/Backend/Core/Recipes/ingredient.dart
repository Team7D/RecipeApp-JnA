class Ingredient {
  final String _name;
  final int _quantity;
  final String _unit; // e.g., "g", "cup", "tbsp"

  Ingredient(this._name, this._quantity, this._unit);

  String getName() => _name;

  int getQuantity() => _quantity;

  String getUnit() => _unit;

  bool matches(Ingredient other){
    if(_name == other._name){
      return true;
    }

    return false;
  }
}
