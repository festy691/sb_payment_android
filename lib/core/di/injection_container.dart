import 'package:get_it/get_it.dart';
import 'package:sb_payment_sdk/core/data/session_manager.dart';
import 'package:sb_payment_sdk/core/network/network_service.dart';
import 'package:sb_payment_sdk/core/network/url_config.dart';
import 'package:sb_payment_sdk/core/provider/auth_provider.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/services/auth_service.dart';

final sl = GetIt.instance;

Future<void> init({required Environment environment}) async {
  UrlConfig.environment = environment;
  await initCore();
  initProviders();
  await initServices();
}

Future<void> initCore() async {
  final sessionManager = SessionManager();
  await sessionManager.init();
  if (sl.isRegistered<SessionManager>()) {
    sl.unregister<SessionManager>();
  }
  sl.registerLazySingleton<SessionManager>(() => sessionManager);

  final paymentProvider = PaymentProvider();
  if (sl.isRegistered<PaymentProvider>()) {
    sl.unregister<PaymentProvider>();
  }
  sl.registerLazySingleton<PaymentProvider>(() => paymentProvider);
}

void initProviders() {
  if (sl.isRegistered<AuthProvider>()) {
    sl.unregister<AuthProvider>();
  }
  sl.registerFactory(() => AuthProvider(sl()));
}

Future<void> initServices() async {
  if (sl.isRegistered<NetworkService>()) {
    sl.unregister<NetworkService>();
  }
  sl.registerFactory<NetworkService>(
      () => NetworkService(baseUrl: UrlConfig.coreBaseUrl));

  if (sl.isRegistered<AuthService>()) {
    sl.unregister<AuthService>();
  }
  sl.registerLazySingleton<AuthService>(() => AuthService(networkService: sl()));
}
