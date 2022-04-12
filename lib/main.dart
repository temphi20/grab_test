import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'func.dart';
import 'page.dart';
import 'notifier.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<Notifier>(create: (_) => Notifier())
        // Provider<Notifier>(create: (_) => Notifier())
      ],
      child: MaterialApp(
        title: 'Pylon Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: GrabPage(),
      ),
    );
  }
}
