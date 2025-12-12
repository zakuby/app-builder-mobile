import 'package:app_builder_mobile/core/di/injection.dart';
import 'package:app_builder_mobile/domain/repositories/auth_repository.dart';
import 'package:app_builder_mobile/presentation/auth/auth_page.dart';
import 'package:app_builder_mobile/presentation/auth/cubit/auth_cubit.dart';
import 'package:app_builder_mobile/presentation/home/cubit/home_cubit.dart';
import 'package:app_builder_mobile/presentation/home/home_web_view_message_handler.dart';
import 'package:app_builder_mobile/presentation/webview/custom_web_view.dart';
import 'package:app_builder_mobile/util/app_colors.dart';
import 'package:app_builder_mobile/util/app_util.dart';
import 'package:app_builder_mobile/util/icon_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<GlobalKey<CustomWebViewState>> _webViewKeys;
  late final List<Widget> _pages;
  late final List<IconData> _pagesIcon;
  bool _isBottomBarVisible = true;
  bool _isNavigationBarVisible = AppUtil.config.enableAppBar ?? false;

  // Track navigation state and title for each tab
  late List<bool> _canGoBack;
  late List<String?> _pageTitles;

  @override
  void initState() {
    super.initState();
    final tabs = AppUtil.config.urls?.tabs ?? [];

    // Initialize navigation state tracking
    _canGoBack = List.filled(tabs.length, false);
    _pageTitles = List.filled(tabs.length, null);

    // Generate GlobalKeys for each WebView
    _webViewKeys = List.generate(
      tabs.length,
      (_) => GlobalKey<CustomWebViewState>(),
    );

    // Generate pages from config tabs with navigation callbacks
    _pages = tabs.asMap().entries.map((entry) {
      final index = entry.key;
      final tab = entry.value;
      return CustomWebView(
        key: _webViewKeys[index],
        url: tab.url ?? "",
        messageHandler: HomeWebViewMessageHandler(
          onLogout: _handleLogout,
          onHideBottomBar: _hideBottomBar,
          onShowBottomBar: _showBottomBar,
          onShowNavigationBar: _showNavigationBar, // Deprecated: use enableAppBar in config
          onHideNavigationBar: _hideNavigationBar, // Deprecated: use enableAppBar in config
          onShowToast: _showToast,
        ),
        onNavigationStateChanged: (canGoBack) {
          setState(() {
            _canGoBack[index] = canGoBack;
          });
        },
        onTitleChanged: (title) {
          setState(() {
            _pageTitles[index] = title;
          });
        },
      );
    }).toList();

    // Generate icons from config tabs using IconMapper
    _pagesIcon = tabs.map((tab) => IconMapper.getIcon(tab.iconId)).toList();
  }

  void _hideBottomBar() {
    setState(() {
      _isBottomBarVisible = false;
    });
  }

  void _showBottomBar() {
    setState(() {
      _isBottomBarVisible = true;
    });
  }

  void _showNavigationBar() {
    setState(() {
      _isNavigationBarVisible = true;
    });
  }

  void _hideNavigationBar() {
    setState(() {
      _isNavigationBarVisible = false;
    });
  }

  void _showToast(String message, String duration) {
    final snackBarDuration =
        duration == 'long' ? const Duration(seconds: 4) : const Duration(seconds: 2);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: snackBarDuration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleLogout() {
    debugPrint('Logout triggered, navigating to auth page');

    // Navigate to auth page and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              AuthCubit(authRepository: getIt<AuthRepository>()),
          child: const AuthPage(),
        ),
      ),
      (route) => false, // Remove all routes from the stack
    );
  }

  void _handleBackPressed(int currentTabIndex) {
    final webViewKey = _webViewKeys[currentTabIndex];
    webViewKey.currentState?.goBack();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = AppUtil.config.urls?.tabs ?? [];

    return BlocBuilder<HomeCubit, int>(
      builder: (context, currentTabIndex) {
        final canGoBack =
            currentTabIndex < _canGoBack.length && _canGoBack[currentTabIndex];
        final currentTitle = currentTabIndex < _pageTitles.length
            ? _pageTitles[currentTabIndex]
            : null;

        return Scaffold(
          backgroundColor: AppColors.primary,
          appBar: _isNavigationBarVisible
              ? AppBar(
                  backgroundColor: AppColors.primary,
                  leading: canGoBack
                      ? IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.textColor,
                          ),
                          onPressed: () => _handleBackPressed(currentTabIndex),
                        )
                      : null,
                  automaticallyImplyLeading: false,
                  title: Text(
                    currentTitle ?? widget.title,
                    style: TextStyle(color: AppColors.textSelectedColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  centerTitle: true,
                )
              : null,
          body: SafeArea(
            child: IndexedStack(index: currentTabIndex, children: _pages),
          ),
          bottomNavigationBar: _isBottomBarVisible && tabs.length > 1
              ? Theme(
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
                    selectedLabelStyle:
                        const TextStyle(fontWeight: FontWeight.w700),
                    unselectedFontSize: 10,
                    unselectedLabelStyle: TextStyle(
                      color: AppColors.textUnselectedColor,
                      fontWeight: FontWeight.w400,
                    ),
                    currentIndex: currentTabIndex,
                    onTap: (index) {
                      context.read<HomeCubit>().changeIndex(index);
                      // Reload the WebView silently when switching tabs
                      _webViewKeys[index].currentState?.reload(silent: true);
                    },
                    type: BottomNavigationBarType.fixed,
                    items: _pagesIcon
                        .mapIndexed(
                          (index, icon) => BottomNavigationBarItem(
                            icon: _navBarIcon(icon, index, currentTabIndex),
                            label: tabs[index].title ?? 'Page ${index + 1}',
                          ),
                        )
                        .toList(),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _navBarIcon(IconData icon, int index, int currentIndex) => Icon(
        icon,
        size: 24,
        color: index == currentIndex
            ? AppColors.textSelectedColor
            : AppColors.textUnselectedColor,
      );
}
