class PhoneTextDecoration {
  static String trimPhoneNumber(String phone) {
    return phone.replaceAll(RegExp('[^0-9.]'), '');
  }

  static String formatPhone(String phone) {
    final regExp = RegExp(
      r'[+]?([0-9]{1,2})?([0]{0,2})([0-9]{2})?([0-9]{3})?([0-9]{2})?([0-9]{2})',
    );
    var trimmedPhone = (phone.startsWith('0') && phone.length == 10)
        ? '+38$phone'
        : ((!phone.startsWith('0') && phone.length == 9)
            ? '+380$phone'
            : phone);

    return trimmedPhone.replaceAllMapped(regExp, (match) {
      final group1 =
          (match.group(1)?.isEmpty ?? true) ? '' : '+${match.group(1)}';

      final group2 = match.group(2);
      String? group2Result = '';
      if ((group1.isNotEmpty) && (group2!.isNotEmpty)) {
        group2Result += group2.substring(0, 1);

        group2Result += group2.substring(1) + ' ';
      } else {
        group2Result = group2;
      }

      return '$group1$group2Result${match.group(3)} ${match.group(4)}-'
          '${match.group(5)}-${match.group(6)}';
    });
  }
}
