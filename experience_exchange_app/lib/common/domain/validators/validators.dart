bool validateEmail(String email) {
  RegExp regExp = new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return email.isNotEmpty && regExp.hasMatch(email);
}

bool validatePassword(String password) {
  print(password.length);
  if (password.isEmpty)
    return false;
  if (password.length < 7)
    return false;
  return true;
}