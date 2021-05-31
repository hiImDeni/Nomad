bool validateEmail(String email) {
  RegExp regExp = new RegExp(r"/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return email.isNotEmpty && regExp.hasMatch(email);
}

bool validatePassword(String password) {
  if (password.isEmpty)
    return false;
  if (password.length < 7)
    return false;
  return true;
}