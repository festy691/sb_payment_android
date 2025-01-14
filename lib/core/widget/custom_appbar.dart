import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sb_payment_sdk/core/utils/constants.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';

AppBar appBar(BuildContext context, {List<Widget>? actions, Widget? leadingWidget, Widget? titleWidget}){
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Pallet.white,
    title: titleWidget,
    toolbarHeight: ScreenUtil().setHeight(50),
    leading: leadingWidget ?? IconButton(
      color: Pallet.black,
      iconSize: setWidth(24),
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(Icons.arrow_back, size: setWidth(24), color: Pallet.black,)
    ),
    actions: actions,
  );
}