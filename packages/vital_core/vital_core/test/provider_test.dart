import 'package:flutter_test/flutter_test.dart';
import 'package:vital_core/provider.dart';

void main() {
  test('Google Health provider slug round-trips', () {
    expect(ProviderSlug.googleHealth.toString(), 'google_health');
    expect(
      ProviderSlug.fromString('google_health'),
      ProviderSlug.googleHealth,
    );
  });

  test('Samsung Health provider slugs round-trip', () {
    expect(ProviderSlug.samsungHealth.toString(), 'samsung_health');
    expect(
      ProviderSlug.fromString('samsung_health'),
      ProviderSlug.samsungHealth,
    );
    expect(ManualProviderSlug.samsungHealth.toString(), 'samsung_health');
  });

  test('Google Health user connection decodes as a known provider', () {
    final connection = UserConnection.fromJson({
      'name': 'Google Health',
      'slug': 'google_health',
      'logo': null,
      'status': 'connected',
      'resourceAvailability': <String, dynamic>{},
      'createdOn': '2026-09-17T00:00:00Z',
    });

    expect(connection.slug, ProviderSlug.googleHealth);
  });
}
