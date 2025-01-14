Payment sdk for StartButton

will need feedback before proceeding to convert to a package
Release Notes for StartButton Payment SDK
Version 0.1.0

## Features

## Getting started

Enhanced payment flow to provide a smoother user experience.
Optimized error handling for more informative feedback.
Improved compatibility with various payment gateways.

## Bug fixes

## Transaction Response Updates
Transaction Response Updates:
The response from successful transactions now includes detailed transaction data.
Transaction data includes reference, amount, email, currency, bank details (name, account number, account name), payment status, payment type, and payment date.
Improved error handling and messages for failed transactions.

## Usage

## Usage Guide:
## Imports:

```dart
import 'package:sb_payment_sdk/sb_payment_sdk.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
```

## Initialization:

```dart
StartButtonPlugin _paymentPlugin = StartButtonPlugin();
_paymentPlugin.initialize(isLive: false, publicKey: "sb_e73bc345*************2bc08442957****8db719f*******12c0");
```

## Making a Payment:

```dart
const _reference = ""; //Generate any random string
num _amount = 2000;
APIResponse response = await _paymentPlugin.makePayment(
context,
charge: Payment(amount: _amount, email: "example@gmail.com", currencyType: CurrencyType.NGN, reference: _reference)
);
```

Upon successful transaction, the response will contain detailed transaction data.

## Example response data for successful transaction:

```dart
var data = { "reference": "reference", "amount": 2000, "email": "example@gmail.com", "currency": "NGN", "bankName": "", "accountName": "", "accountNumber": "", "paymentStatus": "successful", "paymentType": "Paystack", "paymentDate": "2024-03-19T18:42:51.757Z" };
```


## Additional information

For more information and detailed usage instructions, please refer to the updated documentation or contact our support team.