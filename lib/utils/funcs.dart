import 'package:collection/collection.dart';

Map<String, List<T>> groupByInitials<T>(
  List<T> ts,
  {String Function(T) toString}
) {
  if (toString != null) {
    return groupBy(ts, (t) => toString(t).substring(0, 1).toUpperCase());
  } else {
    return groupBy(ts, (t) => t.toString().substring(0, 1).toUpperCase());
  }
}

bool searchFilter(String field, String search) {
  return field
      .toLowerCase()
      .trim()
      .contains(RegExp(r'' + search.toLowerCase().trim() + ''));
}
