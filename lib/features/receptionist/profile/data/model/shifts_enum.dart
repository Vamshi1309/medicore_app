enum Shifts {
  MORNING,
  AFTERNOON,
  RIGHT;

  static Shifts fromJson(String value) {
    return Shifts.values.firstWhere((shift) => shift.name == value);
  }

  String toJson() => name;
}
