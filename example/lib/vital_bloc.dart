import 'package:vital_flutter/environment.dart';
import 'package:vital_flutter/services/data/user.dart';
import 'package:vital_flutter/vital_flutter.dart';

class VitalBloc {
  final client = VitalClient();
  late final users = client.userService.getAll();

  final String apiKey;
  final Region region;

  VitalBloc(this.apiKey, this.region) {
    client.init(region: region, environment: Environment.sandbox, apiKey: apiKey);
  }

  Stream<List<User>?> getUsers() {
    return Stream.fromFuture(users.then((value) => value.body));
  }

  void refresh() {}

  Future<bool> launchLink(User user) async {
    return client.linkProvider(user, 'strava');
  }

  deleteUser(User user) {}
}
