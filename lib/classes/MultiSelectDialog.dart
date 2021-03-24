import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Models/Relay.dart';
import 'package:sidebar_animation/Models/Sensor.dart';

class MultiSelectDialog extends StatefulWidget {
  /// List to display the answer.
  final List<Sensor> answers;

  /// Widget to display the question.
  final Widget question;

  /// Map that holds selected option with a boolean value
  /// i.e. { 'a' : false}.
  static Map<Sensor, bool> mappedItem;

  MultiSelectDialog({this.answers, this.question});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  /// List to hold the selected answer
  /// i.e. ['a'] or ['a','b'] or ['a','b','c'] etc.
  final List<Sensor> selectedItems = [];
  final List<Relay> RelaySelection = [];
  /// Function that converts the list answer to a map.
  Map<Sensor, bool> initMap() {
    return MultiSelectDialog.mappedItem = Map.fromIterable(widget.answers,
        key: (k) => k,
        value: (v) {
          if (v != true && v != false)
            return false;
          else
            return v as bool;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (MultiSelectDialog.mappedItem == null) {
      initMap();
    }
    return SimpleDialog(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: widget.question,
      children: [
        ...MultiSelectDialog.mappedItem.keys.map((Sensor key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => CheckboxListTile(
                title: Text(
                  key.name,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ), // Displays the option
                value: MultiSelectDialog
                    .mappedItem[key], // Displays checked or unchecked value
                controlAffinity: ListTileControlAffinity.platform,
                onChanged: (value) =>
                    setState(() => MultiSelectDialog.mappedItem[key] = value)),
          );
        }).toList(),
        Align(
            alignment: Alignment.center,
            child: Container(
              width: 200,
              child: FlatButton(
                  child: Text('Select'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      side: BorderSide(color: Colors.blue[300], width: 1.5)),
                  textColor: Colors.blue,
                  onPressed: () async {
                    // Clear the list
                    selectedItems.clear();

                    // Traverse each map entry
                    MultiSelectDialog.mappedItem.forEach((key, value) {
                      if (value == true) {
                        selectedItems.add(key);
                      }
                    });

                    // Close the Dialog & return selectedItems
                    selectedItems.forEach((element) {
                      Relay r =new Relay(itemId:element.id,itemText:element.name);
                      RelaySelection.add(r);
                    });
                    Navigator.pop(context);
                    print("......." + RelaySelection.toString());
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.setString("Electro",Relay.relayToJson(RelaySelection));

                  }),
            ))
      ],
    );
  }
}
