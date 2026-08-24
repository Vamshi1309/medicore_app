enum MedicineFrequency {
  morning,
  afternoon,
  night,
  morningNight,
  morningAfternoon,
  afternoonNight,
  morningAfternoonNight,
}

extension MedicineFrequencyExtension on MedicineFrequency {
  String get apiValue {
    switch (this) {
      case MedicineFrequency.morning:
        return 'MORNING';

      case MedicineFrequency.afternoon:
        return 'AFTERNOON';

      case MedicineFrequency.night:
        return 'NIGHT';

      case MedicineFrequency.morningNight:
        return 'MORNING_NIGHT';

      case MedicineFrequency.morningAfternoon:
        return 'MORNING_AFTERNOON';

      case MedicineFrequency.afternoonNight:
        return 'AFTERNOON_NIGHT';

      case MedicineFrequency.morningAfternoonNight:
        return 'MORNING_AFTERNOON_NIGHT';
    }
  }

  static MedicineFrequency fromApiValue(String value) {
    switch (value) {
      case 'MORNING':
        return MedicineFrequency.morning;

      case 'AFTERNOON':
        return MedicineFrequency.afternoon;

      case 'NIGHT':
        return MedicineFrequency.night;

      case 'MORNING_NIGHT':
        return MedicineFrequency.morningNight;

      case 'MORNING_AFTERNOON':
        return MedicineFrequency.morningAfternoon;

      case 'AFTERNOON_NIGHT':
        return MedicineFrequency.afternoonNight;

      case 'MORNING_AFTERNOON_NIGHT':
        return MedicineFrequency.morningAfternoonNight;

      default:
        throw ArgumentError(
          'Unknown medicine frequency: $value',
        );
    }
  }
}