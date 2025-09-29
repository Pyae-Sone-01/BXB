import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Hello World Tests', () {
    test('should return true for true', () {
      expect(true, isTrue);
    });

    test('should return 2 for 1 + 1', () {
      expect(1 + 1, 2);
    });
  });
}