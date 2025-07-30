import 'package:echojar/app/navigation/router.dart';
import 'package:echojar/app/theme/app_theme.dart';
import 'package:echojar/common/services/local_notification_service.dart';
import 'package:echojar/common/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import 'app/database/database.dart';
import 'features/create-jar/providers/jar_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hasSeenIntro = await AppConfigManager().isOnboardingCompleted() ?? false;
  LocalNotificationService.initialize();

  runApp(MyApp(
    hasSeenIntro: hasSeenIntro,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.hasSeenIntro});

  final bool hasSeenIntro;

  static final _globalKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fToast.init(navigatorKey.currentContext!);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JarViewModel(),
      child: ShowCaseWidget(
        builder: (context) => MaterialApp.router(
            builder: (context, child) {
              child = FToastBuilder()(context, child);

              return child;
            },
            key: MyApp._globalKey,
            routerConfig: createRouter(hasSeenIntro: widget.hasSeenIntro),
            debugShowCheckedModeBanner: false,
            title: 'EchoJar',
            theme: appTheme,
        ),
      ),
    );
  }
}
