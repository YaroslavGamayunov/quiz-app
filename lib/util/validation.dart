import 'package:email_validator/email_validator.dart';

String? validateEmailFormat(String? email) {
  if (email == null) {
    return 'Поле почты не может быть пустым';
  }
  if (!EmailValidator.validate(email)) {
    return 'Неверный формат почты';
  }
  return null;
}

bool isEmailRegistered(String? email) {
  if (email == null) {
    return false;
  }
  if (email == 'a@a.a') {
    return true;
  }
  return false;
}

String? validatePasswordFormat(String? password) {
  if (password == null) {
    return 'Пароль не может быть пустым';
  }
  if (password.length <= 5) {
    return 'Пароль должен быть длиннее 5 символов';
  }
  return null;
}
