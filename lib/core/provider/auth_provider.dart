import 'package:flutter/material.dart';
import 'package:sb_payment_sdk/core/services/auth_service.dart';
import 'package:sb_payment_sdk/models/bank_account_model.dart';

class AuthProvider with ChangeNotifier {
  AuthService _authService;
  AuthProvider(AuthService authService) : _authService = authService;

  final _loadingKey = GlobalKey<State>();

  List<BankAccountModel> bankList = [
    BankAccountModel(id: "0", accountName: "Checkout Earth", accountNumber: "0011223344", bankName: "Bains Credit"),
    BankAccountModel(id: "0", accountName: "Checkout Earth", accountNumber: "7711994488", bankName: "Fidelity"),
    BankAccountModel(id: "0", accountName: "Checkout Earth", accountNumber: "6655338899", bankName: "Wema"),
  ];


}