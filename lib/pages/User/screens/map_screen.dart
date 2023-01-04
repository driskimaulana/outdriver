// ignore_f or_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:outdriver/app_utils.dart';
import 'package:outdriver/map_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:outdriver/pages/User/screens/foundDriver_screen.dart';

class MapScreen extends StatefulWidget {
  final DetailsResult? startPosition;
  final DetailsResult? endPosition;

  const MapScreen({Key? key, this.startPosition, this.endPosition})
      : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition _initialPosition;
  final Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  int selectedCarId = 1;
  bool backButtonVisible = true;
  double _distance = 0;
  int _total = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialPosition = CameraPosition(
      target: LatLng(widget.startPosition!.geometry!.location!.lat!,
          widget.startPosition!.geometry!.location!.lng!),
      zoom: 14.4746,
    );
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        points: polylineCoordinates,
        width: 10,
        color: Colors.lightBlue);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Utils.MAPS_API_KEY,
        PointLatLng(widget.startPosition!.geometry!.location!.lat!,
            widget.startPosition!.geometry!.location!.lng!),
        PointLatLng(widget.endPosition!.geometry!.location!.lat!,
            widget.endPosition!.geometry!.location!.lng!),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      for (var i = 0; i < polylineCoordinates.length - 1; i++) {
        _distance += Utils.calculateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude);
      }
      _total = ((_distance * 2000) / 500).ceil() * 500;
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> _markers = {
      Marker(
          markerId: MarkerId('start'),
          position: LatLng(widget.startPosition!.geometry!.location!.lat!,
              widget.startPosition!.geometry!.location!.lng!)),
      Marker(
          markerId: MarkerId('end'),
          position: LatLng(widget.endPosition!.geometry!.location!.lat!,
              widget.endPosition!.geometry!.location!.lng!))
    };

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 180, 54, 1),
        elevation: 0,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/only_logo.png",
                    height: 50,
                  ),
                  const Text(
                    "outDriver",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        leading: backButtonVisible
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              )
            : null,
      ),
      body: Stack(children: [
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            height: constraints.maxHeight * 0.55,
            child: GoogleMap(
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: _initialPosition,
              markers: Set.from(_markers),
              onMapCreated: (GoogleMapController controller) {
                Future.delayed(Duration(milliseconds: 2000), () {
                  controller.animateCamera(CameraUpdate.newLatLngBounds(
                      MapUtils.boundsFromLatLngList(
                          _markers.map((loc) => loc.position).toList()),
                      100));
                  _getPolyline();
                });
              },
            ),
          );
        }),
        DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.45,
            maxChildSize: 1,
            snapSizes: [0.5, 1],
            snap: true,
            builder: (BuildContext context, scrollSheetController) {
              return Container(
                  padding: EdgeInsets.only(bottom: 20),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Detail Perjalanan',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          ListTile(
                            visualDensity: VisualDensity(vertical: -4),
                            // contentPadding: EdgeInsets.all(10),
                            title: Text(
                              "From",
                              style: TextStyle(color: Colors.black54),
                            ),
                            trailing: Text(
                              widget.startPosition!.name!,
                            ),
                          ),
                          ListTile(
                            visualDensity: VisualDensity(vertical: -4),
                            // contentPadding: EdgeInsets.all(10),
                            title: Text(
                              "To",
                              style: TextStyle(color: Colors.black54),
                            ),
                            trailing: Text(
                              widget.endPosition!.name!,
                            ),
                          ),
                          ListTile(
                              visualDensity: VisualDensity(vertical: -4),
                              title: Text(
                                "Jarak",
                                style: TextStyle(color: Colors.black54),
                              ),
                              trailing:
                                  Text(_distance.toStringAsFixed(2) + ' km')),
                          ListTile(
                            visualDensity: VisualDensity(vertical: -4),
                            title: Text(
                              "Total Harga",
                              style: TextStyle(color: Colors.black54),
                            ),
                            trailing: Text(
                              "Rp. ${_total}",
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(28, 180, 54, 1),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => foundDriver(
                                          widget.startPosition,
                                          widget.endPosition,
                                          _distance,
                                          _total)));
                            },
                            child: Text("Find Driver")),
                      )
                    ],
                  ));
            }),
      ]),
    );
  }
}
