import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/api/client.dart';
import 'package:pep/blocs/validation_state.dart';
import 'package:pep/util/validation.dart';
import 'package:openapi/api.dart';

class NeedsRegistration extends Incorrect {
  NeedsRegistration()
      : super(errorMessage: 'Пользователя с данным Email не существует');
}

class IncorrectEmail extends Incorrect {
  IncorrectEmail() : super(errorMessage: 'Неправильный формат почты');
}

class LoginBloc extends Cubit<ValidationState> {
  LoginBloc(ValidationState initialState) : super(initialState);

  validateEmail(String? email) async {
    try {
      final result = await DefaultApi(apiClient).apiAuthEmailCheckPost(ModelsCheckEmailRequest()..email = email);
      if (result.isUserRegistered) {
        emit(Correct());
      } else {
        emit(NeedsRegistration());
      }
    } catch (e) {
      emit(IncorrectEmail());
    }
  }

  validatePassword(String? password) =>
      _emitValidationResult(validatePasswordFormat(password));

  _emitValidationResult(String? result) {
    if (result == null) {
      emit(Correct());
    } else {
      emit(Incorrect(errorMessage: result));
    }
  }
}
