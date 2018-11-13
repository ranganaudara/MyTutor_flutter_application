class ValidatorMixin {
  String passwordValidator(String value) {
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
}
