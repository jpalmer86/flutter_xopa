import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/pages/loading/loading_page.dart';
import 'package:xopa_app/pages/onboarding/signup/signup_bloc.dart';
import 'package:xopa_app/theme/widgets/themed_button.dart';
import 'package:xopa_app/theme/widgets/themed_textfield.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupBloc _signupBloc;

  bool _termsAccepted;

  TextEditingController _usernameController;
  TextEditingController _passwordController;
  TextEditingController _repeatPasswordController;
  TextEditingController _nameController;
  TextEditingController _emailController;

  @override
  void initState() {
    _signupBloc = new SignupBloc();
    _signupBloc.listen(_signupBlocListener);

    _termsAccepted = false;

    _usernameController = new TextEditingController();
    _passwordController = new TextEditingController();
    _repeatPasswordController = new TextEditingController();
    _nameController = new TextEditingController();
    _emailController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _signupBloc.close();
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Welcome to Xopa!',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                Icon(Icons.flash_on),
                const SizedBox(height: 24),
                Icon(Icons.group_add, size: 200),
                const SizedBox(height: 48),
                ThemedTextField(
                  label: 'Name',
                  controller: _nameController,
                ),
                const SizedBox(height: 24),
                ThemedTextField(
                  label: 'Email',
                  controller: _emailController,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                ThemedTextField(
                  label: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                ThemedTextField(
                  label: 'Repeat Password',
                  controller: _repeatPasswordController,
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                BlocBuilder(
                  bloc: _signupBloc,
                  builder: (BuildContext context, SignupState state) {
                    return ThemedTextField(
                      label: 'Username',
                      errorText: state is FormError ? state.message : null,
                      controller: _usernameController,
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value;
                        });
                      },
                    ),
                    const Text(
                      'Accept Terms and Conditions'
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                BlocBuilder(
                  bloc: _signupBloc,
                  builder: (BuildContext context, SignupState state) {
                    if (state is Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ThemedButton(
                      child: const Text('Sign Up'),
                      onPressed: _termsAccepted ? _signUp : null,
                      expanded: true,
                      filled: true,
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() {
    _signupBloc.add(
      SubmitSignup(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _repeatPasswordController.text,
        _usernameController.text,
      ),
    );
  }

  void _signupBlocListener(SignupState state) {
    if(state is Success) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => LoadingPage(),
      ));
    }
  }
}
