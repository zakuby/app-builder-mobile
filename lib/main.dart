import 'dart:async';
import 'dart:ui';

import 'package:app_builder_mobile/core/di/injection.dart';
import 'package:app_builder_mobile/domain/repositories/auth_repository.dart';
import 'package:app_builder_mobile/presentation/auth/auth_page.dart';
import 'package:app_builder_mobile/presentation/auth/cubit/auth_cubit.dart';
import 'package:app_builder_mobile/presentation/auth/cubit/auth_state.dart';
import 'package:app_builder_mobile/presentation/home/cubit/home_cubit.dart';
import 'package:app_builder_mobile/presentation/home/home_page.dart';
import 'package:app_builder_mobile/services/fcm_service.dart';
import 'package:app_builder_mobile/util/app_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
        
          // Initialize dependency injection
          await initializeDependencies();

        try {
          // Initialize Firebase
          await Firebase.initializeApp();
          debugPrint('Firebase initialized successfully');

          // Set up background message handler
          FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

          // Initialize FCM service
          await FCMService().initialize();
          debugPrint('FCM Service initialized successfully');


          runApp(const MyApp());
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
    return BlocProvider(
      create: (context) => AuthCubit(authRepository: getIt<AuthRepository>()),
      child: MaterialApp(
        title: 'App Builder',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AuthCheckWrapper(),
      ),
    );
  }
}

/// Wrapper widget that checks authentication status and routes accordingly
class AuthCheckWrapper extends StatefulWidget {
  const AuthCheckWrapper({super.key});

  @override
  State<AuthCheckWrapper> createState() => _AuthCheckWrapperState();
}

class _AuthCheckWrapperState extends State<AuthCheckWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final loginUrl = AppUtil.config.urls?.login;

    // If no login URL configured, skip auth check
    if (loginUrl == null || loginUrl.isEmpty) {
      context.read<AuthCubit>().emit(const AuthState.authenticated());
      return;
    }

    // Check if user is logged in
    await context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          authenticated: (userData) => BlocProvider(
            create: (context) => HomeCubit(),
            child: HomePage(title: AppUtil.config.appName ?? ""),
          ),
          unauthenticated: () => const AuthPage(),
          error: (message) {
            // On error, show auth page
            debugPrint('Auth error: $message');
            return const AuthPage();
          },
        );
      },
    );
  }
}
