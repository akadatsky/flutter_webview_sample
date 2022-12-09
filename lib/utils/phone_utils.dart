import 'package:flutter_webview_sample/utils/phone_decoration_utils.dart';

class PhoneUtils {
  static bool isPhoneNumber(String input) {
    return RegExp(r'^[0-9\\_+=()-]+$').hasMatch(input);
  }

  static bool validatePhone(String input) {
    return RegExp(r'((^0\d{8,9})|(\+?\d{10,12}))').hasMatch(
      PhoneTextDecoration.trimPhoneNumber(input),
    );
  }
}
