import 'package:flutter/material.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    Key? key,
    @required this.passwordTextController,
    this.validator,
    this.hintText,
  }) : super(key: key);

  final TextEditingController? passwordTextController;
  final String? Function(String?)? validator;
  final String? hintText;

  @override
  _PasswordTextFormFieldState createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordTextController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _passwordObscured,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(
            _passwordObscured ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _passwordObscured = !_passwordObscured;
            });
          },
        ),
      ),
      validator: widget.validator,
    );
  }
}
