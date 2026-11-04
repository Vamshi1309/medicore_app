import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/network/api_constants.dart';

void main() {
  group('Inventory API constants', () {
    test('low-stock endpoint includes a named threshold query parameter', () {
      expect(
        ApiConstants.getLowStockMedicines(10),
        '/inventory/low-stock?threshold=10',
      );
    });

    test('inventory base endpoint is the correct route', () {
      expect(ApiConstants.getAllMedicines, '/inventory');
    });
  });
}
