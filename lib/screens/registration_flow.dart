import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pep/blocs/validation_state.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/home.dart';
import 'package:pep/blocs/registration_bloc.dart';
import 'package:pep/screens/registration_forms/email_code_sent.dart';
import 'package:pep/screens/registration_forms/registration_credentials.dart';

class RegistrationFlowPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegistrationFlowPageState();
}

class _RegistrationFlowPageState extends State<RegistrationFlowPage> {
  final RegistrationFlowBloc _registrationBloc =
      RegistrationFlowBloc(Incorrect(errorMessage: ''));

  final PageController _pageController = PageController();
  late List<Widget> pages;

  int _currentPage = 0;
  bool _isFormCorrect = false;

  @override
  void initState() {
    super.initState();
    pages = [
      RegistrationCredentialsForm(onContinue: _goToNextForm),
      EmailCodeSent(
          onContinue: _goToNextForm,
          email: () => _registrationBloc.userData['email']),
      RegistrationCredentialsForm(onContinue: _goToNextForm)
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
                          progress: (_currentPage + 1) / pages.length,
                          onBackPressed: _goToPrevoiusForm,
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

  _goToNextForm() {
    if (_isFormCorrect) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      _isFormCorrect = false;
    }
  }

  _goToPrevoiusForm() {
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
      {Key? key, required this.progress, required this.onBackPressed})
      : super(key: key);

  final Function() onBackPressed;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LinearProgressIndicator(
        color: kPrimaryColor,
        backgroundColor: kInputBackgroundColor,
        minHeight: 5.0,
        value: progress,
      ),
      Container(
          margin: EdgeInsets.symmetric(vertical: 24),
          alignment: Alignment.topLeft,
          child: InkResponse(
              radius: 32,
              child: SvgPicture.asset("assets/ic_arrow_2.svg"),
              onTap: onBackPressed))
    ]);
  }
}
