import 'year.dart';
import 'day.dart';
import 'month.dart';

class Calendar {
  List<Year> _years = [];

  Calendar(){
    DateTime today = DateTime.now();

    for(Year year in _years){
      if(year.year == today.year){
        return;
      }
    }
    _years.add(Year(today.year));
  }

  Day? today(){
    DateTime today = DateTime.now();

    return getDayInMonthInYear(today.year, today.month, today.day);
  }

  Month? thisMonth(){
    DateTime today = DateTime.now();

    return getMonthInYear(today.year, today.month);
  }

  Year? thisYear(){
    DateTime today = DateTime.now();

    return getYear(today.year);
  }

  void addYear(int yearNumber) {
    _years.add(Year(yearNumber));
  }

  Year? getYear(int yearNumber) {
    for (var year in _years) {
      if (year.year == yearNumber) {
        return year;
      }
    }
    return null;
  }

  Month? getMonthFromYear(Year year, int monthNumber){
    for(var month in year.months){
      if(month.monthNumber == monthNumber){
        return month;
      }
    }
    return null;
  }

  Month? getMonthInYear(int yearNumber, int monthNumber) {
    for (var year in _years) {
      if (year.year == yearNumber) {
        for(var month in year.months){
          if(month.monthNumber == monthNumber){
            return month;
          }
        }
      }
    }
    return null;
  }

  Day? getDayFromMonth(Month month, int dayNumber){
    for(var day in month.days){
      if(day.dayNumber == dayNumber ){
        return day;
      }
    }
    return null;
  }

  Day? getDayInMonthInYear(int yearNumber, int monthNumber, int dayNumber){
    for (var year in _years) {
      if (year.year == yearNumber) {
        for(var month in year.months){
          if(month.monthNumber == monthNumber){
            for(var day in month.days){
              if(day.dayNumber == dayNumber){
                return day;
              }
            }
          }
        }
      }
    }
    return null;
  }

  void displayYear(int yearNumber) {
    var year = getYear(yearNumber);
    if (year != null) {
      year.display();
    } else {
      print("YEAR NOT FOUND");
    }
  }

  void displayMonthInYear(int yearNumber, int monthNumber) {
    var year = getYear(yearNumber);
    if (year != null) {
      year.displayMonthInYear(monthNumber);
    } else {
      print("YEAR NOT FOUND");
    }
  }

  void displayMonthFromYear({required Year year, required int monthNumber}){
    year.displayMonthInYear(monthNumber);
  }

  void displayDayInMonthInYear(int yearNumber, int monthNumber, int dayNumber) {
    var year = getYear(yearNumber);
    if (year != null) {
      year.displayDayInMonthInYear(monthNumber, dayNumber);
    } else {
      print("YEAR NOT FOUND");
    }
  }

  void displayDayFromMonth({required Month month, required int dayNumber}){
    month.displayDay(dayNumber);
  }
}