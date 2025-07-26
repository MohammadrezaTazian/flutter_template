class MobileNumberCache {
  static String _mobileNumber = '';

  static void setMobileNumber(String mobileNumber) {
    _mobileNumber = mobileNumber;
    print('Mobile Number Cache - Set: $_mobileNumber');
  }

  static String getMobileNumber() {
    print('Mobile Number Cache - Get: $_mobileNumber');
    return _mobileNumber;
  }

  static void clear() {
    _mobileNumber = '';
    print('Mobile Number Cache - Cleared');
  }
}