import 'day.dart';
import 'month.dart';

class Year {
  List<Month> months = [];
  int year;
  late int firstDayOfYear;

  Year(this.year) {
    firstDayOfYear = calculateFirstDayOfYear(year);
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
}