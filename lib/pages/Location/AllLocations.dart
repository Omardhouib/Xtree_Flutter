import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/pages/Location/LocationDetails.dart';

import '../../bloc.navigation_bloc/navigation_bloc.dart';

class Locations extends StatefulWidget with NavigationStates {
  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  GoogleMapController _controller;
  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(33.892166, 9.400138), zoom: 5.0);
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Marker> Markers = [];
  List<Location> locations = [];

  /*Coord() {
     databaseHelper2.AllLocationByUser().then((locations) {
       print("heloooooooo"+locations.toString());
       if(locations.isNotEmpty){
         for(int i=0; i < locations.length; i++){
           initMarker(locations[i], locations[i].id);
         }
       }
    });

  }
  @override
  void initstate(){
    Coord();
    super.initState();
  }

 */ /* addMarker(cordinate){
    int id = Random().nextInt(1);
    setState(() {
      markers.add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }*/ /*

  void initMarker(specify, specifyId) async{
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
       markerId: markerId,
       position: LatLng(specify.coordinates[0], specify.coordinates[1]),
        infoWindow: InfoWindow(title: specify.siteName)
    );
    setState(() {
      markers[markerId] = marker;
    });
}
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Location>>(
//                future: databaseHelper.getData(),
          future: databaseHelper2.AllLocationByUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data.forEach((Location) {
                Markers = snapshot.data
                    .map((Location) => Marker(
                        markerId: MarkerId(Location.id),
                        position: LatLng(
                            Location.coordinates[0], Location.coordinates[1]),
                        icon: BitmapDescriptor.defaultMarker,
                        onTap: () => {
                        Navigator.push(
                        context, MaterialPageRoute(builder: (context) => LocationDetails())),
                        },
                        infoWindow: InfoWindow(
                          title: Location.siteName,
                          onTap: () => {},
                        )))
                    .toList(growable: true);
              });
            }
            print("Markers !!! :" + Markers.toString());
            return GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: Set<Marker>.of(Markers),
              mapType: MapType.hybrid,
              onMapCreated: (controller) {
                setState(() {
                  _controller = controller;
                });
              },
              /*markers: markers.toSet(),
            onTap: (cordinate){
              _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
              addMarker(cordinate);
              print("cord"+cordinate.toString());
            },*/
            );
          }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.animateCamera(CameraUpdate.zoomOut());
        },
        child: Icon(Icons.zoom_out),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/*class ItemList extends StatelessWidget{
  List list;
  ItemList({this.list});

  ScrollController _controller = new ScrollController();


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, i) {

//            DateTime t = DateTime.parse(list[i]['date_published'].toString());

          return Container(
            margin: EdgeInsets.symmetric(vertical: 2),

            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.7,

            child: Stack(
              children: <Widget>[
                Positioned(
//                    top: 60,
                  top: MediaQuery.of(context).size.height * 0.08,
                  left: MediaQuery.of(context).size.width / 3.2,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Text(
                          'Location name is',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24),
                        child:
                        Text(
                          list[i]['SiteName'],
                        ),
                      ),
                      SizedBox(height: 10),


                    ],
                  ),
                ),

              ],
            ),
          );
        });

  }
}*/
/* FutureBuilder(
//                future: databaseHelper.getData(),
          future: databaseHelper2.AllLocationByUser(),
          builder: (context,snapshot) {
            if (snapshot.hasError)
            {
              print(snapshot.error);
              print("mochkla lenaa *");
            }
            return snapshot.hasData
                ?  ItemList(list: snapshot.data)
                :  Center(child: CircularProgressIndicator(
            ),
            );
          }
      ),*/
