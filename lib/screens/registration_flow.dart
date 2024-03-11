import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pep/blocs/registration_events.dart';
import 'package:pep/blocs/validation_state.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/home.dart';
import 'package:pep/blocs/registration_bloc.dart';
import 'package:pep/screens/registration_forms/date_of_birth.dart';
import 'package:pep/screens/registration_forms/email_code_sent.dart';
import 'package:pep/screens/registration_forms/enter_email_code.dart';
import 'package:pep/screens/registration_forms/enter_phone_code.dart';
import 'package:pep/screens/registration_forms/gender.dart';
import 'package:pep/screens/registration_forms/name.dart';
import 'package:pep/screens/registration_forms/registration_credentials.dart';
import 'package:pep/screens/registration_forms/registration_ended.dart';

class RegistrationFlowPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegistrationFlowPageState();
}

class _RegistrationFlowPageState extends State<RegistrationFlowPage> {
  final RegistrationFlowBloc _registrationBloc =
      RegistrationFlowBloc(Incorrect(errorMessage: ''));

  final PageController _pageController = PageController(keepPage: true);
  late List<Widget> pages;

  int _currentPage = 0;
  bool _isFormCorrect = false;
  bool _showBackButton = true;

  @override
  void initState() {
    super.initState();
    pages = [
      RegistrationCredentialsForm(onContinue: _goToNextForm),
      EmailCodeSent(
          onContinue: () {
            _goToNextForm(checkFormCorrectness: false);
          },
          email: () => _registrationBloc.userData['email']),
      EnterEmailCodeForm(onContinue: _goToNextForm),
      NameForm(onContinue: _goToNextForm),
      GenderForm(onContinue: _goToNextForm),
      DateOfBirthForm(onContinue: _goToNextForm),
      EnterPhoneCodeForm(onContinue: () {
        setState(() {
          _showBackButton = false;
        });
        _goToNextForm();
      }),
      RegistrationEnded(onContinue: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _registrationBloc,
        child: Scaffold(
            body: BlocConsumer<RegistrationFlowBloc, ValidationState>(
                bloc: _registrationBloc,
                listener: (context, state) {
                  _isFormCorrect = state is Correct;
                },
                builder: (context, state) => Column(children: [
                      SizedBox(height: 24),
                      Container(
                        child: _RegistrationFlowHeader(
                          showBackButton: _showBackButton,
                          progress: (_currentPage + 1) / pages.length,
                          onBackPressed: _goToPreviousForm,
                        ),
                        margin: EdgeInsets.only(left: 24, right: 24, top: 16),
                      ),
                      Expanded(
                          child: PageView(
                              onPageChanged: (pageNumber) {
                                _currentPage = pageNumber;
                                setState(() {});
                              },
                              controller: _pageController,
                              physics: NeverScrollableScrollPhysics(),
                              children: pages))
                    ]))));
  }

  _goToNextForm({bool checkFormCorrectness: true}) {
    if (!checkFormCorrectness || _isFormCorrect) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      _registrationBloc.add(NextFormEvent());
      _isFormCorrect = false;
    }
  }

  _goToPreviousForm() {
    if (_currentPage == 0) {
      Navigator.of(context).pop();
    }
    _pageController.previousPage(
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    _isFormCorrect = true;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _RegistrationFlowHeader extends StatelessWidget {
  const _RegistrationFlowHeader(
      {Key? key,
      required this.progress,
      required this.onBackPressed,
      required this.showBackButton})
      : super(key: key);

  final Function() onBackPressed;
  final double progress;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LinearProgressIndicator(
        color: kPrimaryColor,
        backgroundColor: kInputBackgroundColor,
        minHeight: 5.0,
        value: progress,
      ),
      Visibility(
          visible: showBackButton,
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.topLeft,
              child: InkResponse(
                  radius: 32,
                  child: SvgPicture.asset("assets/ic_arrow_2.svg"),
                  onTap: onBackPressed)))
    ]);
  }
}
