enum DispensingStatus {
  pending,
  completed;

  String get apiValue => switch (this) {
        DispensingStatus.pending => 'PENDING',
        DispensingStatus.completed => 'COMPLETED',
      };

  static DispensingStatus fromApi(String? value) {
    return switch (value?.toUpperCase()) {
      'PENDING' => DispensingStatus.pending,
      'COMPLETED' => DispensingStatus.completed,
      _ => DispensingStatus.pending,
    };
  }
}