import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xopa_app/pages/loading/loading_page.dart';
import 'package:xopa_app/pages/onboarding/login/login_bloc.dart';
import 'package:xopa_app/pages/onboarding/signup/signup_page.dart';
import 'package:xopa_app/theme/widgets/themed_button.dart';
import 'package:xopa_app/theme/widgets/themed_textfield.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;

  TextEditingController _usernameController;
  TextEditingController _passwordController;

  @override
  void initState() {
    _loginBloc = new LoginBloc();
    _loginBloc.listen(_loginBlocListener);
    _usernameController = new TextEditingController();
    _passwordController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _loginBloc.close();
    _usernameController.dispose();
    _passwordController.dispose();
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
                  label: 'Username or Email',
                  textInputType: TextInputType.emailAddress,
                  controller: _usernameController,
                ),
                const SizedBox(height: 24),
                BlocBuilder(
                  bloc: _loginBloc,
                  builder: (BuildContext context, LoginState state) {
                    return ThemedTextField(
                      label: 'Password',
                      isPassword: true,
                      errorText: state is FormError ? state.message : null,
                      controller: _passwordController,
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder(
                  bloc: _loginBloc,
                  builder: (BuildContext context, LoginState state) {
                    if (state is Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ThemedButton(
                      child: const Text('Log In'),
                      onPressed: () {
                        _loginBloc.add(
                          SubmitLogin(
                            _usernameController.text,
                            _passwordController.text,
                          ),
                        );
                      },
                      expanded: true,
                      filled: true,
                    );
                  },
                ),
                const SizedBox(height: 12),
                ThemedButton(
                  child: const Text('No Account?'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SignupPage(),
                    ));
                  },
                  expanded: true,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginBlocListener(LoginState state) {
    if(state is Success) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => LoadingPage(),
      ));
    }
  }
}
