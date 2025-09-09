enum EnumPages { signin, signup, forgetPassword, none }

extension EnumPagesEx on EnumPages {
  String get name {
    switch (this) {
      case EnumPages.signin:
        return 'signin';
      case EnumPages.signup:
        return 'signup';
      case EnumPages.forgetPassword:
        return 'forgetPassword';
      default:
        return 'none';
    }
  }

  bool get isSigin {
    return this == EnumPages.signin;
  }

  bool get isSignup {
    return this == EnumPages.signup;
  }

  bool get isForget {
    return this == EnumPages.forgetPassword;
  }

  static EnumPages selctePage(String page) {
    switch (page) {
      case 'signin':
        return EnumPages.signin;
      case 'signup':
        return EnumPages.signup;
      case 'forgetPassword':
        return EnumPages.forgetPassword;
      default:
        return EnumPages.none;
    }
  }
}
