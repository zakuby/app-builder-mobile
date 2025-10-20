import 'package:app_builder_mobile/presentation/my_home_cubit.dart';
import 'package:app_builder_mobile/presentation/webview/custom_web_view.dart';
import 'package:app_builder_mobile/util/app_colors.dart';
import 'package:app_builder_mobile/util/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<Widget> _pages;
  late final List<IconData> _pagesIcon;

  @override
  void initState() {
    super.initState();
    final tabs = AppUtil.config.urls?.tabs ?? [];

    // Generate pages from config tabs
    _pages = tabs.map((tab) => CustomWebView(url: tab.url ?? "")).toList();

    // Default icons based on number of tabs
    final defaultIcons = [
      Icons.home,
      Icons.newspaper,
      Icons.shopping_bag,
      Icons.store,
      Icons.person,
      Icons.settings,
    ];

    _pagesIcon = List.generate(
      tabs.length,
      (index) => index < defaultIcons.length
          ? defaultIcons[index]
          : Icons.tab,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = AppUtil.config.urls?.tabs ?? [];

    return BlocBuilder<MyHomeCubit, int>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(widget.title, style: TextStyle(color: AppColors.textColor)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: IndexedStack(index: state, children: _pages),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColors.primary,
            selectedItemColor: AppColors.textSelectedColor,
            unselectedItemColor: AppColors.textUnselectedColor,
            selectedFontSize: 10,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
            unselectedFontSize: 10,
            unselectedLabelStyle: TextStyle(
              color: AppColors.textUnselectedColor,
              fontWeight: FontWeight.w400,
            ),
            currentIndex: state,
            onTap: (index) {
              context.read<MyHomeCubit>().changeIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            items: _pagesIcon
                .mapIndexed(
                  (index, icon) => BottomNavigationBarItem(
                    icon: _navBarIcon(icon, index, state),
                    label: tabs[index].title ?? 'Page ${index + 1}',
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _navBarIcon(IconData icon, int index, int currentIndex) => Icon(
    icon,
    size: 24,
    color: index == currentIndex ? AppColors.textSelectedColor : AppColors.textUnselectedColor,
  );
}
