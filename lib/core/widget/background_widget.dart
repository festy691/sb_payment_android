import 'package:flutter/material.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';

typedef OnPopResult = Function(bool, Object?);

class BackgroundWidget extends StatelessWidget {
  final Widget body;
  final List<Widget>? actions;
  final Widget? leadingWidget;
  final Widget? titleWidget;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool hasPadding;
  final Color backgroundColor;
  final Widget? drawer;
  final AppBar? appBar;
  final bool? shouldExit;
  final OnPopResult? onPopResult;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const BackgroundWidget({
    Key? key,
    required this.body,
    this.actions,
    this.hasPadding = false,
    this.shouldExit = false,
    this.leadingWidget,
    this.titleWidget,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.appBar,
    this.scaffoldKey,
    this.onPopResult,
    this.backgroundColor = Pallet.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: shouldExit ?? false,
      onPopInvokedWithResult: onPopResult ?? (status, result) {},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        drawer: drawer,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
