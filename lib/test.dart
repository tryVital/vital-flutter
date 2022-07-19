import 'services/user_service.dart';

Future<void> main() async {
  const apiKey = 'sk_eu_HCgKZT1Icv0Oyw8mmpyPu6E2NuD-bnmeFFeg43k2hgw';
  //const apiKey = 'sk_us_309IjVjh-vSuDw-DM_06k3b3N2NzuItWYmQ9pRhLDV0';
  const userId = '312b6eb9-43af-47b4-ae26-f70423b5d305';

  final userService = UserService.create("${urls['eu']!['sandbox']}/v2", apiKey);

  //print(await userService.getUser(userId));

  //print(await userService.createUser("Jan 3"));

  final result = await userService.getAll();
  print(result);
}
