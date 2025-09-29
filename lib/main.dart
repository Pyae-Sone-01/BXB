import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'datasources/services/local/local_storage_service.dart';
import 'router/router.dart';
import 'utils/providers/connectivity_provider.dart';
import 'utils/themes/app_resources.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppResources.colors.blue800,
      statusBarBrightness: Brightness.light, // iOS (dark text/icons)
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await initialization();
  runApp(const ProviderScope(child: MyApp()));
}

Future initialization() async {
  await LocalStorageServices.init();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ConnectivityResult? _lastResult;
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    // Only set up the listener once
    if (!_isListening) {
      _isListening = true;
      ref.listen<AsyncValue<ConnectivityResult>>(connectivityProvider,
          (prev, next) {
        if (next.value != null && next.value != _lastResult) {
          _lastResult = next.value;
          if (next.value == ConnectivityResult.none) {
            Fluttertoast.showToast(msg: "No internet connection");
          } else {
            Fluttertoast.showToast(msg: "Internet connection restored");
          }
        }
      });
    }
    return ScreenUtilInit(
      designSize: const Size(360, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true, // Add this
      useInheritedMediaQuery: true, // Add this
      builder: (context, child) => SafeArea(
        child: MaterialApp.router(
          title: 'BXB',
          debugShowCheckedModeBanner: false,
          theme: AppResources.themes.whiteTheme,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
