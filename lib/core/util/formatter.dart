import 'dart:convert';

class Formatter {
  static printJson(Map<String, dynamic> jsonMap) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(jsonMap);
    print(jsonString);
  }

  static String formatDuration(Duration duration) {
    if (duration.inSeconds < 30) {
      return "less than a minute";
    } else if (duration.inSeconds < 90) {
      return "1 minute";
    } else if (duration.inMinutes < 45) {
      return duration.inMinutes.toString() + " minutes";
    } else if (duration.inMinutes < 90) {
      return "about 1 hour";
    } else if (duration.inHours < 24) {
      return "about " + duration.inHours.toString() + " hours";
    } else if (duration.inHours < 42) {
      return "1 day";
    } else if (duration.inDays < 30) {
      return duration.inDays.toString() + " days";
    } else if (duration.inDays < 45) {
      return "about 1 month";
    } else if (duration.inDays < 60) {
      return "about 2 months";
    } else if (duration.inDays < 356) {
      return (duration.inDays ~/ 30).toString() + " months";
    }

    int years = duration.inDays ~/ 365;
    int months = (duration.inDays - (365 * years)) ~/ 30;

    if (years < 2) {
      if (months < 2) {
        return "1 year";
      }

      return "1 year " + months.toString() + " months";
    }

    if (months < 2) {
      return years.toString() + " years";
    }

    return years.toString() + " years " + months.toString() + " months";
  }
}
