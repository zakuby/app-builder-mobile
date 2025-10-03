import 'package:app_builder_mobile/presentation/my_home_cubit.dart';
import 'package:app_builder_mobile/presentation/my_home_page.dart';
import 'package:app_builder_mobile/util/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
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
