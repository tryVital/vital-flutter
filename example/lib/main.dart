import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vital_flutter/vital_flutter.dart';
import 'package:vital_flutter_example/users_screen.dart';
import 'package:vital_flutter_example/vital_bloc.dart';

const apiKey = 'sk_eu_S5LdXTS_CAtdFrkX9OYsiVq_jGHaIXtZyBPbBtPkzhA';
const region = Region.eu;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade300),
      ),
      home: Provider<VitalBloc>(
        create: (context) => VitalBloc(apiKey, region),
        child: const UsersScreen(),
      ),
    );
  }
}
