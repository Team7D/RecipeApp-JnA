class Instruction {
  final int _stepNumber;
  final String _instruction;

  Instruction(this._stepNumber, this._instruction);

  int getStepNumber() => _stepNumber;

  String getInstruction() => _instruction;
}
