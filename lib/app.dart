import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'notifier/ui_notifier.dart';
import 'pages/grab_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider(create: (_) => UINotifier())],
      child: FluentApp(
        title: 'Pylon Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: GrabPage(),
      ),
    );
  }
}
