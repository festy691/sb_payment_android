import 'package:flutter/material.dart';

bool hasOpenedLogOutDialog = false;

class Routes {
  static const String LANDING_PAGE = '/landing_page';
  static const String ON_BOARDING_PAGE = '/on_boarding_page';
  static const String ACTIVE_MOBILE_SCREEN = '/ActiveMobileScreen';
  static const String VERIFY_ACTIVE_MOBILE_SCREEN = '/VerifyActiveMobileScreen';
  static const String SIGN_IN_PAGE = '/SignInPage';
  static const String SIGN_IN_SCREEN = '/SignInScreen';
  static const String DASHBOARD_PAGE = '/Dashboard';
  static const String PLAN_NAME_SCREEN = '/PlanNameScreen';
  static const String MY_PLAN_SCREEN = '/MyPlansScreen';
  static const String PROFILES_CREEN = '/ProfileScreen';
  static const String SECURITY_SCREEN = '/SecurityScreen';
  static const String CUSTOMER_COMPLIANT_SCREEN = '/CustomerCompliantScreen';
  static const String ADD_BANK_PAGE = '/AddBankPage';
  static const String BANK_SCREEN = '/BankScreen';
  static const String MY_DEBIT_CARD = '/MyDebitCard';
  static const String REFERRER_PAGE = '/ReferrerPage';
  static const String WHERE_TO_TRANSFER_SCREEN = '/WhereToTransferScreen';


  static Map<String, Widget Function(BuildContext mainContext)> get getRoutes => {
   /* LANDING_PAGE: (BuildContext context) {
          globalContext = context;
          return LandingPage();
        },*/
  };


}
