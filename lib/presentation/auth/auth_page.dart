import 'package:app_builder_mobile/presentation/auth/auth_web_view_message_handler.dart';
import 'package:app_builder_mobile/presentation/auth/cubit/auth_cubit.dart';
import 'package:app_builder_mobile/presentation/auth/cubit/auth_state.dart';
import 'package:app_builder_mobile/presentation/home/cubit/home_cubit.dart';
import 'package:app_builder_mobile/presentation/home/home_page.dart';
import 'package:app_builder_mobile/presentation/webview/custom_web_view.dart';
import 'package:app_builder_mobile/util/app_colors.dart';
import 'package:app_builder_mobile/util/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginUrl();
  }

  void _checkLoginUrl() {
    final loginUrl = AppUtil.config.urls?.login;

    if (loginUrl == null || loginUrl.isEmpty) {
      // No login URL configured, navigate to home
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToHome();
      });
    }
  }

  void _navigateToHome() {
    debugPrint('Navigating to home page after successful login');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => HomeCubit(),
          child: HomePage(title: AppUtil.config.appName ?? ""),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginUrl = AppUtil.config.urls?.login;

    if (loginUrl == null || loginUrl.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final authCubit = context.read<AuthCubit>();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (userData) {
            // User is authenticated, navigate to home
            _navigateToHome();
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: CustomWebView(
            url: loginUrl,
            messageHandler: AuthWebViewMessageHandler(
              authCubit: authCubit,
              onLoginSuccess: () {
                if (mounted) {
                  _navigateToHome();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
