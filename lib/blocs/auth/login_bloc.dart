import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/auth/validation_state.dart';
import 'package:quizapp/util/validation.dart';

import '../../data/api/auth.dart';

class NeedsRegistration extends Incorrect {
  NeedsRegistration()
      : super(errorMessage: 'Пользователя с данным Email не существует');
}

class IncorrectEmail extends Incorrect {
  IncorrectEmail() : super(errorMessage: 'Неправильный формат почты');
}

class IncorrectLoginCredentials extends Incorrect {
  IncorrectLoginCredentials({String? msg = null})
      : super(errorMessage: msg ?? "Неправильный логин или пароль");
}

class LoggedIn extends Correct {}

class LoginBloc extends Cubit<ValidationState> {
  LoginBloc(ValidationState initialState) : super(initialState);

  String? _email;
  String? _password;

  validateEmail(String? email) async {
    if (validateEmailFormat(email) != null) {
      emit(IncorrectEmail());
    } else {
      try {
        if (await checkEmailRegistered(email)) {
          _email = email;
          emit(Correct());
        } else {
          emit(NeedsRegistration());
        }
      } catch (e) {
        emit(IncorrectEmail());
      }
    }
  }

  validatePassword(String? password) async {
    String? result = validatePasswordFormat(password);
    if (result == null) {
      _password = password;
      emit(Correct());
    } else {
      emit(Incorrect(errorMessage: result));
    }
  }

  Future<ValidationState> _auth() async {
    if (_password != null && _email != null) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email!, password: _password!);
        return LoggedIn();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return NeedsRegistration();
        } else if (e.code == 'wrong-password') {
          return IncorrectLoginCredentials(msg: 'Неверный пароль');
        }
      } catch (e) {
        return IncorrectLoginCredentials();
      }
    }
    return IncorrectLoginCredentials();
  }

  logIn() {
    _auth().then((value) => emit(value));
  }
}
