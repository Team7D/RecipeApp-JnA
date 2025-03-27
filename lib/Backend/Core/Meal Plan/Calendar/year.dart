import 'day.dart';
import 'month.dart';

class Year {
  List<Month> months = [];
  int year;
  late int firstDayOfYear;

  Year(this.year) {
    firstDayOfYear = _calculateFirstDayOfYear(year);
    for (int monthNumber = 1; monthNumber <= 12; monthNumber++) {
      months.add(Month(monthNumber, firstDayOfYear, isLeapYear: _isLeapYear(year)));
      firstDayOfYear = (firstDayOfYear + months[monthNumber - 1].daysInMonth) % 7;
    }
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
  }

  void display() {
    for (var month in months) {
      month.display();
      print("");
    }
  }

  void displayMonthInYear(int month) {
    months[month - 1].display();
  }

  void displayDayInMonthInYear(int month, int day) {
    months[month - 1].displayDay(day);
  }

  int _calculateFirstDayOfYear(int year) {
    int day = 1;
    int month = 1;

    // Zeller's Congruence algorithm
    if (month == 1 || month == 2) {
      month += 12;
      year -= 1;
    }

    int k = year % 100; // The year within the century
    int j = year ~/ 100; // The century

    int f = (day + (13 * (month + 1)) ~/ 5 + k + k ~/ 4 + j ~/ 4 - 2 * j) % 7;

    return f;
  }
}