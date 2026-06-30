import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = backgroundColor ??
        (brightness == Brightness.dark
            ? AppColors.darkBackground
            : AppColors.lightBackground);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar,
      body: SafeArea(
        child: padding != null
            ? Padding(padding: padding!, child: body)
            : body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
