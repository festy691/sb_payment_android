import 'dart:io';
import 'package:flutter/widgets.dart';

class Validators {
  static String? Function(String?) validateAlphaNumeric({String? error}) {
    return (String? value) {
      if (value!.isEmpty) {
        return error ?? 'Name is required.';
      }
      final RegExp nameExp = RegExp(r'^\w+$');
      if (!nameExp.hasMatch(value)) {
        return error ?? 'Please enter only alphanumeric characters.';
      }
      return null;
    };
  }
 static String? validateCACNumber(String value) {
    // Check if CAC number starts with BN, RC, IT, LP, or LLP
    if (!(value.startsWith('BN') ||
        value.startsWith('RC') ||
        value.startsWith('IT') ||
        value.startsWith('LP') ||
        value.startsWith('LLP'))) {
      return 'CAC Number must start with BN, RC, IT, LP, or LLP';
    }
    // Check if the length is within the allowed range
    if (value.length > 14) {
      return 'CAC Number length must be at most 14 characters';
    }
    // Check if the rest of the characters are digits
    if (!RegExp(r'^[0-9]+$').hasMatch(value.substring(2))) {
      return 'CAC Number must contain only digits after prefix';
    }
    return null; // Return null if validation passes
  }

  static String? Function(String?) validateAlpha({String? error}) {
    return (String? value) {
      if (value!.isEmpty) {
        return error ?? 'Name is required.';
      }
      final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
      if (!nameExp.hasMatch(value)) {
        return error ?? 'Please enter only alphabetical characters.';
      }
      return null;
    };
  }

  static String? Function(String?) validateDouble({String? error}) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return error ?? 'Field is required.';
      }
      if ((double.tryParse(value) ?? 0.0) <= 0.0) {
        return error ?? 'Not a valid number.';
      }
      return null;
    };
  }

  static String? Function(String?) validateInt({String? error}) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return error ?? 'Field is required.';
      }
      if ((int.tryParse(value) ?? 0.0) <= 0) {
        return error ?? 'Not a valid number.';
      }
      return null;
    };
  }

  static String? Function(String?) validateEmail(String? value, {String? error}) {
    return (String? value) {
      if (value!.isEmpty) {
        return error ?? 'Enter a valid email address';
      }
      if (!value.contains('@')) {
        return error ?? 'Not a valid email.';
      }
      return null;
    };
  }

  static String? validateEmail2({String? value}) {
    if (value!.isEmpty) {
      return 'Enter a valid email address';
    }
    final RegExp nameExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!nameExp.hasMatch(value)) {
      return 'Not a valid email.';
    }
    return null;
  }

  static String? Function(String?) validatePhone({String? error}) {
    return (String? value) {
      if (value!.isEmpty) {
        return error ?? 'Enter a valid phone number';
      }
      if (!RegExp(r'^\d+?$').hasMatch(value) ||
          !value.startsWith(RegExp("0[146789]")) ||
          // Land lines eg 01
          (value.startsWith("01") && value.length != 9) ||
          // Land lines eg 080
          (value.startsWith(RegExp("0[146789]")) && value.length != 11)) {
        return error ?? 'Not a valid phone number.';
      }
      return null;
    };
  }

  static String? validatePhone2({String? value}) {
    if (value!.isEmpty || value.length < 9) {
      return 'Enter a valid phone number';
    }
    /*if (!RegExp(r'^\d+?$').hasMatch(value) ||
        !value.startsWith(RegExp("0[146789]")) ||
        // Land lines eg 01
        (value.startsWith("01") && value.length != 9) ||
        // Land lines eg 080
        (value.startsWith(RegExp("0[146789]")) && value.length != 11)) {
      return 'Not a valid phone number.';
    }*/
    return null;
  }

  static String? validateBvn({String? value}) {
    if (value!.isEmpty) {
      return 'Enter a valid bvn number';
    }
    if (value.length < 11) {
      return 'Not a valid bvn number.';
    }
    return null;
  }

  static String? validateOtp({String? value}) {
    if (value!.isEmpty) {
      return 'Enter a valid otp';
    }
    if (value.length != 6) {
      return 'Not a valid otp.';
    }
    return null;
  }

  static String? validatePin({String? value}) {
    if (value!.isEmpty) {
      return 'Enter a valid PIN';
    }
    if (value.length != 4) {
      return 'Not a valid PIN.';
    }
    return null;
  }

  static String? validateTransactionPin({String? value}) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'Enter a valid pin';
    }
    if (value.length != 4) {
      return 'Not a valid pin.';
    }
    return null;
  }

  static String? validateInput({String? value, String? error}) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return error ?? 'Field is required.';
    }
    return null;
  }

  static String? validateAccountNumber({String? value, String? error}) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return error ?? 'Account number is required.';
    }
    if (value.length < 10) {
      return error ?? 'Invalid account number';
    }
    return null;
  }

  static String? Function(String?) validateString(String? value, {String? error}) {
    return (String? value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return error ?? 'Field is required.';
      }
      return null;
    };
  }

  static String? Function(String?) validatePass({String? error}) {
    return (String? value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return error;
      }

      // else if (value.length < 6 || value.length > 255) {
      //   return 'Password must be 6-255 characters';
      // } else if (!_hasSpecialCharacter(value)) {
      //   return 'Password must contain at least one special character';
      // }
      return null;
    };
  }

  static String? Function(String?) validatePlainPass({String? error}) {
    return (String? value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return 'Password is required';
      } else if (value.length < 6 || value.length > 255) {
        return 'Password must be 6-255 characters';
      }
      return null;
    };
  }

  static String? Function(File) validateFile({String? error}) {
    return (File file) {
      if (file.path.isEmpty) {
        return error ?? 'Invalid File.';
      }
      return null;
    };
  }

  static String? Function(String?) validateAmount(
      {String? error, double? minAmount, double? maxAmount}) {
    return (String? value) {
      value = value!.replaceAll(",", "");

      if (value.isEmpty) {
        return error ?? 'Amount is required.';
      }
      if (double.tryParse(value) == null) {
        return error ?? 'Invalid Amount.';
      }
      if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
        return error ?? 'Not a valid amount.';
      }
      if (double.tryParse(value)! <= 0.0) {
        return error ?? 'Zero Amount is not allowed.';
      }
      if (double.tryParse(value)! < minAmount!) {
        return error ?? 'Minimum amount allow is $minAmount';
      }
      if (double.tryParse(value)! > maxAmount!) {
        return 'Maximum amount allow is $maxAmount';
      }
      return null;
    };
  }

  static String? Function(String?) validateDiffChange(
    FormFieldState<String?> field, [
    String? error,
  ]) {
    return (String? value) {
      if (field.value != value) {
        return error ?? 'Values don\'t match';
      }
      return null;
    };
  }

  static String? Function(String?) validatePassword(
      FormFieldState<String?> passwordField) {
    return (String? value) {
      if (passwordField == null) {
        return 'Please enter a password.';
      }
      if (passwordField.value == null || passwordField.value!.isEmpty) {
        return 'Please enter a password.';
      }
      return validateDiffChange(
        passwordField,
        'The passwords don\'t match',
      )(value);
    };
  }

  static bool _hasSpecialCharacter(String? value) {
    var specialChars = "<>@!#\$%^&*()_+[]{}?:;|'\"\\,./~`-=";
    for (int i = 0; i < specialChars.length; i++) {
      if (value!.contains(specialChars[i])) {
        return true;
      }
    }
    return false;
  }

  static String? validPassword({String? value}) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'Password is required';
    } else if (!hasLowercase(value))
      return 'Password must have lowercase letter';
    else if (!hasUppercase(value))
      return 'Password must have uppercase letter';
    else if (!hasNumber(value))
      return 'Password must have number';
    else if (!has8Character(value)) return 'Password must be 8-255 characters';
    return null;
  }

  static String? validConfirmPassword({String? value1, String? value2}) {
    if (value1 == null || value1.isEmpty || value1.trim().isEmpty) {
      return 'Password is required';
    } else if (value2 == null || value2.isEmpty || value2.trim().isEmpty)
      return 'Confirm Password is required';
    else if (value1 != value2) return 'Password does not match';
    return null;
  }

  static bool has8Character(String? value) {
    if (value!.isNotEmpty && value.length >= 8) return true;
    return false;
  }

  static bool hasLowercase(String? value) {
    if (value!.isNotEmpty && RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
      return true;
    }
    return false;
  }

  static bool hasUppercase(String? value) {
    if (value!.isNotEmpty && RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
      return true;
    }
    return false;
  }

  static bool hasNumber(String? value) {
    if (value!.isNotEmpty && RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
      return true;
    }
    return false;
  }
  static String? fullname(String? name, [String title = "Full Name"]) {
    if (name != null) {
      if (name.isEmpty) {
        return "Your $title cannot be empty";
      } else if (!name.contains(" ") || name.length < 4) {
        return "Invalid $title";
      }
      return null;
    }
    return "Invalid $title";
  }
}
