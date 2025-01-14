import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sb_payment_sdk/core/di/injection_container.dart';
import 'package:sb_payment_sdk/core/provider/auth_provider.dart';

class Providers {
  static List<SingleChildWidget> getProviders = [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider(sl())),
  ];
}
