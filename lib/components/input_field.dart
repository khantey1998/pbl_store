import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController inputController;
  final String inputError;
  final String inputHint;
  final String inputLabel;
  InputField({this.inputController, this.inputError, this.inputLabel, this.inputHint});

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: new Theme(
            data: new ThemeData(
                primaryColor: Theme.of(context).primaryColor,
                textSelectionColor: Theme.of(context).primaryColor
            ),
            child: new TextField(
                keyboardType: TextInputType.text,
                controller: inputController,
                decoration: new InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                  errorText: inputError,
                  labelText: inputLabel,
                  hintText: inputHint
                )
            )
        )
    );
  }

}