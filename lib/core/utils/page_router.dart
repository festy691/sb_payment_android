import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:route_animation_helper/route_animation_helper.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

export 'routes.dart';

class PageRouter {
  static Future gotoWidget(Widget screen, BuildContext context,
          {bool clearStack = false,
          bool fullScreenDialog = false,
          AnimType animationType = AnimType.slideStart,
          int duration = 300}) =>
      !clearStack
          ? Navigator.of(context).push(
              !kIsWeb && Platform.isIOS
                  ? SwipeablePageRoute(
                      canOnlySwipeFromEdge: true,
                      builder: (BuildContext context) => screen,
                    )
                  : RouteAnimationHelper.createRoute(
                      buildContext: context,
                      currentPage: context.widget,
                      destination: screen,
                      animType: animationType,
                      duration: duration.round()),
            )
          : Navigator.of(context).pushAndRemoveUntil(
              !kIsWeb && Platform.isIOS
                  ? SwipeablePageRoute(
                      canOnlySwipeFromEdge: true,
                      builder: (BuildContext context) => screen,
                    )
                  : RouteAnimationHelper.createRoute(
                      buildContext: context,
                      currentPage: context.widget,
                      destination: screen,
                      animType: animationType,
                      duration: duration.round()),
              (_) => false,
            );

  static Future gotoNamed(String route, BuildContext context,
          {bool clearStack = false, dynamic args = Object}) =>
      !clearStack
          ? Navigator.of(context).pushNamed(route, arguments: args)
          : Navigator.of(context)
              .pushNamedAndRemoveUntil(route, (_) => false, arguments: args);

  static gotoNavigatorNamed(
          String route, GlobalKey<NavigatorState> navigatorKey,
          {bool clearStack = false, dynamic args = Object}) =>
      !clearStack
          ? navigatorKey.currentState?.pushNamed(route, arguments: args)
          : navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(route, (_) => false, arguments: args);

  static void goBack(BuildContext context, {bool rootNavigator = false}) {
    Navigator.of(context, rootNavigator: rootNavigator).pop();
  }

  static void openPage(BuildContext context, Widget route) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => route));
  }

  static void replacePage(BuildContext context, Widget route) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => route));
  }

  static void replaceAllPages(BuildContext context, Widget route) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => route),
        (Route<dynamic> route) => false);
  }

  static void goToRoot(BuildContext context, {String routeName = ''}) =>
      routeName.isNotEmpty
          ? Navigator.of(context).popUntil(ModalRoute.withName(routeName))
          : Navigator.of(context).popUntil((route) => route.isFirst);

  static void goToNameRoutes(
          BuildContext context, Widget screen, String routeName) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          settings: RouteSettings(name: routeName),
          builder: (context) => screen,
        ),
      );
}
