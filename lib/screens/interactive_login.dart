import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../alerts/loading_alert.dart';

class InteractiveLoginScreen extends StatefulWidget {
  static const String route = 'interactive';
  const InteractiveLoginScreen({Key? key}) : super(key: key);

  @override
  State<InteractiveLoginScreen> createState() => _InteractiveLoginScreenState();
}

class _InteractiveLoginScreenState extends State<InteractiveLoginScreen> {
  String validEmail = 'javier@gmail.com';
  String validPassword = '12345';

  //inputlogin
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  //inputpassword
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  StateMachineController? controller;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  bool isObscure = true;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD6E2EA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              const HeaderCertus(),
              //Interactive Teddy
              SizedBox(
                height: 258,
                width: 258,
                child: RiveAnimation.asset(
                  'assets/login-teddy.riv',
                  fit: BoxFit.fitHeight,
                  stateMachines: const ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                        artboard, 'Login Machine');
                    if (controller == null) return;
                    artboard.addController(controller!);
                    isChecking = controller?.findInput('isChecking');
                    numLook = controller?.findInput('numLook');
                    isHandsUp = controller?.findInput('isHandsUp');
                    trigSuccess = controller?.findInput('trigSuccess');
                    trigFail = controller?.findInput('trigFail');
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        focusNode: emailFocusNode,
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {
                          numLook?.change(value.length.toDouble());
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextField(
                        focusNode: passwordFocusNode,
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off_rounded,
                              color: isObscure
                                  ? const Color(0xff00205B)
                                  : Colors.grey,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        obscureText: isObscure,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00205B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          emailFocusNode.unfocus();
                          passwordFocusNode.unfocus();

                          final email = emailController.text;
                          final password = passwordController.text;

                          showLoadingDialog(context);

                          await Future.delayed(const Duration(seconds: 2));
                          if (mounted) Navigator.pop(context);

                          if (email == validEmail &&
                              password == validPassword) {
                            trigSuccess?.change(true);
                          } else {
                            trigFail?.change(true);
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderCertus extends StatelessWidget {
  const HeaderCertus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 120,
        width: 200,
        child: Image.asset('assets/logocertus.png'),
      ),
    );
  }
}
