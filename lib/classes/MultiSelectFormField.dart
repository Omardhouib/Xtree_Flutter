import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidebar_animation/Models/Sensor.dart';
import 'package:sidebar_animation/classes/MultiSelectDialog.dart';

class MultiSelectFormField extends FormField<List<String>> {
  /// Holds the items to display on the dialog.
  final List<Sensor> itemList;

  /// Enter text to show on the button.
  final String buttonText;

  /// Enter text to show question on the dialog
  final String questionText;

  // Constructor
  MultiSelectFormField({
    this.buttonText,
    this.questionText,
    this.itemList,
    BuildContext context,
    FormFieldSetter<List<String>> onSaved,
    FormFieldValidator<List<String>> validator,
    List<String> initialValue,
  }) : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue ?? [], // Avoid Null
    autovalidate: true,
    builder: (FormFieldState<List<String>> state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                  child: Container(
                    width: 180,
                    height: 40,
                    child: FlatButton(
                      child: Center(
                        //If value is null or no option is selected
                        child: (state.value == null ||
                            state.value.length <= 0)

                        // Show the buttonText as it is
                            ? Row(
                          children: [
                            Icon(
                              Icons.developer_board,
                              color: Colors.blue,
                            ),
                            Text(
                              '      Select relays',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500, color: Colors.blue),
                            ),
                          ],
                        )
                        // Else show number of selected options
                            : Text(
                          state.value.length == 1
                          // SINGLE FLAVOR SELECTED
                              ? '${state.value.length.toString()} '
                              ' ${buttonText.substring(0, buttonText.length - 1)} SELECTED '
                          // MULTIPLE FLAVOR SELECTED
                              : '${state.value.length.toString()} '
                              ' $buttonText SELECTED',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Colors.blue[300], width: 1.5)),
                    ),
                  ),
                  onTap: () async => state.didChange(await showDialog(
                      context: context,
                      builder: (_) => MultiSelectDialog(
                        question: Text(questionText),
                        answers: itemList,
                      )) ??
                      []))
            ],
          ),
          // If validation fails, display an error
          state.hasError
              ? Center(
            child: Text(
              state.errorText,
              style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          )
              : Container() //Else show an empty container
        ],
      );
    },
  );
}
