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

Future<bool> isUserRegistered({String? email}) async {
  if (email == null) {
    return false;
  }
  return true;
  // todo
  // ModelsCheckEmailResponse? result = await DefaultApi(client)
  //     .apiAuthEmailCheckPost(ModelsCheckEmailRequest(email: email));
  // return result.isUserRegistered;
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
