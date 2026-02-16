import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vital_health/vital_health.dart' as vital_health;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("test permissionStatus round-trip", (WidgetTester tester) async {
    var result =
        await vital_health.permissionStatus(vital_health.HealthResource.values);
    expect(result.keys.toSet(),
        equals(vital_health.HealthResource.values.toSet()));
  });
}
