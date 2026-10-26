import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/pharmacist/dashboard/presentation/pharmacist_dashboard.dart';

void main() {
  test('getInitials returns initials from patient name', () {
    expect(getInitials('John Doe'), 'JD');
    expect(getInitials('Alice'), 'A');
    expect(getInitials('  Mary  Jane  Watson  '), 'MW');
  });

  test('formatDispenseDate formats backend timestamp correctly', () {
    final date = DateTime.utc(2024, 8, 15, 18, 30);

    expect(formatDispenseDate(date), '15/08/2024');
    expect(formatDispenseTime(date), '6:30 PM');
  });
}
