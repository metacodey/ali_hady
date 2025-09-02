enum ValidateTypes { none, username, email, phone, password, number, name }

extension TxtValidateTypes on ValidateTypes {
  String get name {
    switch (this) {
      case ValidateTypes.email:
        return "email";
      case ValidateTypes.username:
        return "userName";
      case ValidateTypes.phone:
        return "phone";
      case ValidateTypes.password:
        return "password";
      case ValidateTypes.number:
        return "number";
      case ValidateTypes.name:
        return "name";

      default:
        return "none";
    }
  }

  bool get isUserName {
    return this == ValidateTypes.username;
  }

  bool get isName {
    return this == ValidateTypes.name;
  }

  bool get isEmail {
    return this == ValidateTypes.email;
  }

  bool get isNumber {
    return this == ValidateTypes.number;
  }

  bool get isPassword {
    return this == ValidateTypes.password;
  }

  bool get isPhone {
    return this == ValidateTypes.phone;
  }
}
