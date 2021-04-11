import 'package:flutter/material.dart';
import 'package:sidebar_animation/classes/ElectroONOFFClass.dart';

class ElectrovanneClass extends StatefulWidget {
  dynamic list;

  ElectrovanneClass({this.list});
  @override
  _ElectrovanneClassState createState() => _ElectrovanneClassState();
}

class _ElectrovanneClassState extends State<ElectrovanneClass> {

  String id;
  String status;
  String active = "true";
  bool pressGeoON = false;
  bool cmbscritta = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.developer_board,
                      size: 30,
                      color: Colors.white,
                    ),
                    radius: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Relays:",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
                itemCount: widget.list == null ? 0 : widget.list.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  id = widget.list[i].id.toString();
                  print("...." + cmbscritta.toString());
                  if (widget.list[i].status.toString().isNotEmpty)
                    return ElectroONOFFClass(Electro: widget.list[i]);
                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}
