List tryToParseList(dynamic data) {
  if (data is List) {
    return data;
  } else {
    return [];
  }
}

double tryToParseDouble(dynamic data) {
  try {
    return num.parse(data).toDouble();
  } on FormatException {
    return 0;
  }
}

bool listEquals(List a, List b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

List<dynamic> convertFlattenFixtures(List<List<dynamic>> fixtures) {
  final List<dynamic> flatList = [];
  for (final group in fixtures) {
    flatList.addAll(group);
  }
  return flatList;
}
