import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/test/test_bloc.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/screens/home.dart';
import 'package:quizapp/screens/registration_forms/login_credentials.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TestBloc>(
            create: (context) => TestBloc(),
            lazy: true,
          )
        ],
        child: MaterialApp(
          title: 'Quiz App',
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme:
                AppBarTheme(elevation: 0, backgroundColor: Colors.white),
            fontFamily: 'ProximaNova',
            textTheme: TextTheme(
              displayLarge: TextStyle(
                  fontSize: 39,
                  height: 41 / 39,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.02),
              bodyLarge: TextStyle(
                  fontSize: 24,
                  height: 29 / 24,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.02),
              bodyMedium: TextStyle(
                  fontSize: 14,
                  height: 17 / 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.02),
              labelLarge: TextStyle(
                  fontSize: 24,
                  height: 29 / 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.02),
            ),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                .copyWith(background: Colors.white),
          ),
          home: FirebaseAuth.instance.currentUser == null
              ? LoginCredentialsForm()
              : HomePage(),
        ));
  }
}
