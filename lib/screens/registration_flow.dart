import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quizapp/blocs/auth/registration_events.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/screens/home.dart';
import 'package:quizapp/screens/registration_forms/name.dart';
import 'package:quizapp/screens/registration_forms/registration_credentials.dart';
import 'package:quizapp/screens/registration_forms/registration_ended.dart';

import '../blocs/auth/registration_bloc.dart';
import '../blocs/auth/validation_state.dart';

class RegistrationFlowPage extends StatefulWidget {
  final Map<String, dynamic> initialData;

  RegistrationFlowPage({required this.initialData});

  @override
  State<StatefulWidget> createState() => _RegistrationFlowPageState();
}

class _RegistrationFlowPageState extends State<RegistrationFlowPage> {
  late final RegistrationFlowBloc _registrationBloc;

  final PageController _pageController = PageController(keepPage: true);
  late List<Widget> pages;

  int _currentPage = 0;
  bool _isFormCorrect = false;
  bool _showBackButton = true;

  @override
  void initState() {
    super.initState();
    _registrationBloc = RegistrationFlowBloc(
        initialData: widget.initialData,
        initialState: Incorrect(errorMessage: ''));
    pages = [
      RegistrationCredentialsForm(onContinue: _goToNextForm),
      NameForm(onContinue: _finishRegistration),
      RegistrationEnded(onContinue: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
      })
    ];
  }

  Future<void> _finishRegistration() async {
    developer.log("finishing registration", name: "registration_flow");
    _registrationBloc.add(EndRegistrationEvent());
    _goToNextForm();
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
                builder: (context, state) =>
                state is Processing
                    ? _buildFormProcessingState()
                    : _buildRegistrationFormBody())));
  }

  Widget _buildFormProcessingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildRegistrationFormBody() {
    return Column(children: [
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
    ]);
  }

  _goToNextForm({bool checkFormCorrectness = true}) {
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
  const _RegistrationFlowHeader({Key? key,
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
