import 'package:get/get.dart';

class AppValidation {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Email Address.'.tr;
    } else if (!GetUtils.isEmail(value.trim().toLowerCase())) {
      return 'Enter valid email address'.tr;
    } else {
      return null;
    }
  }

  static String? firstname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a valid First Name (2-20 characters, only letters).'.tr;
    } else {
      return null;
    }
  }

  static String? title(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'enter valid title.'.tr;
    } else {
      return null;
    }
  }

  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a Description(50-200 Characters long).'.tr;
    } else {
      return null;
    }
  }

  static String? loaction(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '*Enter Location';
    } else {
      return null;
    }
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the correct Password'.tr;
    } else if (value.length < 8) {
      return 'Password must contain at least 8 characters. '.tr;
    } else {
      return null;
    }
  }

  static String? conformPass(String? value, String pass) {
    String val = value?.trim() ?? '';
    if (val.isEmpty) {
      return 'Passwords do not match!'.tr;
    } else if (val != pass) {
      return 'password must be SameAsAbove'.tr;
    } else {
      return null;
    }
  }

  static String? userField(String? value) {
    String val = value?.trim() ?? '';
    if (val.isEmpty) {
      return 'Please enter Username!'.tr;
    } else if (!RegExp(r'[a-z0-9_]').hasMatch(val)) {
      return 'User name only contain a-z, 0-9 and _';
    } else {
      return null;
    }
  }

  static String? country(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a select country!'.tr;
    } else {
      return null;
    }
  }

  static String? lastname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a valid Last Name (2-20 characters, only letters).'.tr;
    } else {
      return null;
    }
  }

  static String? notEmpty(String? value, String? name) {
    if (value == null || value.trim().isEmpty) {
      return '${'enter'.tr} $name';
    } else {
      return null;
    }
  }

  static String? number(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'errorMsgNumber'.tr;
    } else if (!GetUtils.isNumericOnly(value.trim())) {
      return 'errorMsgNumber'.tr;
    } else {
      return null;
    }
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'errorMsgPhoneNo'.tr;
    } else if (value.length < 10) {
      return 'errorMsgPhoneNo'.tr;
    }
    return null;
  }

  static String? dateValidation({String? birthDate}) {
    return null;
    // String? foo;
    // final value = birthDate?.trim().split('/');
    // logger.i(value?.length);
    // if (value?.length == 3) {
    //   String currentYear = DateTime.now().year.toString();
    //   // String currentMonth = DateTime.now().month.toString();
    //   String date = value?[0] ?? '';
    //   String month = value?[1] ?? '';
    //   String year = value?[2] ?? '';
    //   DateTime Date = DateTime.parse("$year-$month-$date");
    //   int finalDifference =
    //       (DateTime.now().difference(Date).inDays / 365).floor();
    //   if (value?.isEmpty ?? false) foo = 'Date should not be empty.';
    //   if ((value?.length ?? 0) < 10) foo = 'Invalid Date';
    //   if (int.parse(date) < 1) foo = 'Invalid date';
    //   if (int.parse(date) > 31) foo = 'Invalid date';
    //   if (int.parse(month) < 1) foo = 'Invalid month';
    //   if (int.parse(month) > 12) foo = 'Invalid month';
    //   if (int.parse(year) > int.parse(currentYear)) {
    //     foo = 'Invalid Year';
    //   }
    //   logger.wtf(finalDifference);
    //   logger.w("$date-$month-$year");
    //   if (finalDifference <= 16) {
    //     foo = 'Invalid';
    //   } else if (finalDifference >= 80) {
    //     foo = 'Invalid';
    //   }
    // }
    // logger.w(foo);
    // return foo;
  }
}
