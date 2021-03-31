import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:walk_for_future/widgets/secrets.dart';
import 'package:walk_for_future/pages/started_walking.dart';
import 'package:walk_for_future/widgets/user.dart';

class Maps extends StatefulWidget {
  final UserFromFirebase user;

  const Maps({Key key, this.user}) : super(key: key);
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Position _currentPosition;
  static const LatLng _center = const LatLng(37.3741, -122.0771);
  Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  Dio dio = new Dio();

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print("error");
      print(e);
    });
  }


  _onCameraMove(CameraPosition cameraPosition) {
    _lastMapPosition = cameraPosition.target;
  }



  _onAddMarkerButtonPressed() {
    if (_markers.length != 0) {
      setState(() {
        _markers = {};
      });
    }
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow:
            InfoWindow(title: 'This is Title', snippet: 'This is Snippet'),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Widget button(Function function, IconData iconData) {
    return FloatingActionButton(
        heroTag: "btn1",
        onPressed: function,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Colors.black,
        child: Icon(iconData, size: 36.0));
  }

  Widget newButton(Function function, IconData iconData) {
    return FloatingActionButton(
        heroTag: "btn2",
        onPressed: function,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Colors.black,
        child: Icon(iconData, size: 36.0));
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 8.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    button(_onAddMarkerButtonPressed, Icons.add_location),
                    SizedBox(height: 16.0),
                    //button(_goToPosition, Icons.location_searching),
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.location_pin,
                  color: Colors.black,
                )),
          ),
          Padding(
            padding: EdgeInsets.all(42.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        Response response = await dio.get(
                            "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${_currentPosition.latitude},${_currentPosition.longitude}&destinations=${_markers.first.position.latitude}%2C${_markers.first.position.longitude}&mode=walking&key=${Secrets.API_KEY}");
                        var duration = response.data["rows"][0]["elements"]
                            [0]["duration"]["value"];
                        var distance = response.data["rows"][0]["elements"]
                            [0]["distance"]["value"];
                        if (response.data != null) {
                        if(distance > 1000) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => StartedWalkingPage(latitude: _markers.first.position.latitude.toString(), longtitude: _markers.first.position.longitude.toString(),
                            duration: duration, distance: distance, user: widget.user)),
                          );
                        } else {
                          showAlertDialog(context);
                        }
                        }
                      },
                      child: Text(
                        "Start Walking",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                    )
                  ],
                )),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.orange[100], // button color
                    child: InkWell(
                      splashColor: Colors.orange, // inkwell color
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () {
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                _currentPosition.latitude,
                                _currentPosition.longitude,
                              ),
                              zoom: 18.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () { Navigator.of(context).pop(); },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Distance is too close"),
    content: Text("Distance must be 0.6 miles or higher"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
}

/*class Maps extends StatefulWidget {
  @override
  State<Maps> createState() => MapsState();
}

class MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  _onAddMarkerButtonPressed() {
    _markers.add(Marker(
      markerId: MarkerId(_lastMapPosition.toString()),
      position: _lastMapPosition,
      infoWindow: InfoWindow(
        title: 'This is Title',
        snippet: 'This is Snippet'
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: Text('To the lake!'),
          icon: Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}*/
