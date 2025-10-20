import 'dart:async';
import 'dart:ui';

import 'package:app_builder_mobile/presentation/my_home_cubit.dart';
import 'package:app_builder_mobile/presentation/my_home_page.dart';
import 'package:app_builder_mobile/util/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      // Log to console or crash reporting service
      debugPrint('Flutter Error: ${details.exception}');
    };

    // Catch async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Async Error: $error');
      return true;
    };

    // Wrap app initialization in try-catch
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        try {
          // Load your config here
          runApp(MyApp());
        } catch (e, stack) {
          debugPrint('Init Error: $e\n$stack');
          runApp(ErrorApp(error: e.toString()));
        }
      },
      (error, stack) {
        debugPrint('Zone Error: $error\n$stack');
      },
    );
  }

  // Simple error display widget
  class ErrorApp extends StatelessWidget {
    final String error;
    const ErrorApp({super.key, required this.error});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text('App Initialization Failed',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(error, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (context) => MyHomeCubit(),
        child: MyHomePage(title: AppUtil.config.appName ?? "",),
      ),
    );
  }
}
