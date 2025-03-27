import 'day.dart';

class Month {
  int monthNumber;
  List<Day> days = [];
  late int daysInMonth;
  late String monthName;
  int startingDay;

  Month(this.monthNumber, this.startingDay, {required bool isLeapYear}) {
    daysInMonth = getDaysInMonth(monthNumber, isLeapYear);
    monthName = MonthOfYear.values[monthNumber - 1].toString().split('.').last;
    _generateDays();
  }

  void _generateDays() {
    int currentDayOfWeek = startingDay;

    for (int day = 1; day <= daysInMonth; day++) {
      days.add(Day(day, currentDayOfWeek));
      currentDayOfWeek = (currentDayOfWeek + 1) % 7;
    }
  }

  void display() {
    print(monthName.toUpperCase());
    for (var day in days) {
      day.display();
    }
    print("");
  }

  void displayDay(int dayNumber) {
    days[dayNumber - 1].display();
  }
}