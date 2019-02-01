class ValidatorMixin {

  String password;

  String passwordValidator(String value) {
    password = value;
    if (value.length < 6) {
      return "Password must containe at least 6 charactors";
    }
    return null;
  }

  String emailValidator(String value) {
    if (!value.contains('@')) {
      return "Please enter valid email";
    }
    return null;
  }

  String mobileValidator(String value) {
    if (value.length != 10) {
      return "Enter valid phone number";
    }
    return null;
  }

  String confirmPassword(String value) {
    if (password != value) {
      return "Passwords do not match! Re-enter your password!";
    }
    return null;
  }

}
