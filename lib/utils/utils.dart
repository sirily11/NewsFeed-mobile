/// Get time difference
/// When days is greater than 365, then return in years
/// when time difference is greater than 23 hours, then return in days
/// if less than 1 hour, then return in minutes
String getTime(DateTime dateTime, {DateTime after}) {
  DateTime now = DateTime.now();
  Duration timeDiff;
  if (after == null) {
    timeDiff = now.difference(dateTime);
  } else {
    timeDiff = after.difference(dateTime);
  }
  if (timeDiff.inDays > 364) {
    int year = (timeDiff.inDays / 365).round();
    if (year < 2) {
      return "$year year ago";
    }
    return "$year years ago";
  }

  if (timeDiff.inHours > 23) {
    if (timeDiff.inDays < 2) {
      return "${timeDiff.inDays} day ago";
    }
    return "${timeDiff.inDays} days ago";
  } else if (timeDiff.inHours < 1) {
    if (timeDiff.inMinutes < 2) {
      return "${timeDiff.inMinutes} minute ago";
    }
    return "${timeDiff.inMinutes} minutes ago";
  }
  if (timeDiff.inHours < 2) {
    return "${timeDiff.inHours} hour ago";
  }
  return "${timeDiff.inHours} hours ago";
}
