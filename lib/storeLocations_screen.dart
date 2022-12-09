import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Widgets/Screen_Header.dart';
import './models/CategoryObj.dart';
import 'Widgets/Category_Item.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// ignore: must_be_immutable
class StoreLocationsScreen extends StatefulWidget {
  StoreLocationsScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StoreLocationsScreen> createState() => _State(StoreLocationsScreen);
}

class _State extends State<StoreLocationsScreen> {
  _State(Type storeLocationsScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var storeLocationsList = [];

  Position? currentLocation;

  double latitude = 0;

  double longitude = 0;

  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(31.9594, 35.859),
    zoom: 12.0,
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getStoreLocations();
    // getPermission();
    // getCurrentUserLocation();
  }

  void getStoreLocations() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryMunchStoresAPI/',
        '{"langId":"${prefs.getString('langId')}"}');
    var response = await networkHelper.postData();
    storeLocationsList = response['GetMunchBakeryMunchStoresResult'];
    print('storeLocationsList = $storeLocationsList');
    setState(() {
      for(int i = 0;i<storeLocationsList.length;i++){
        _markers.add(Marker(
            markerId: MarkerId('Address${storeLocationsList[i]['Id']}'),
            position: LatLng(double.parse(storeLocationsList[i]['Latitude'].toString()), double.parse(storeLocationsList[i]['Longitude'].toString())),
            infoWindow:  InfoWindow(title: storeLocationsList[i]['Name'])));
      }
      isLoading = false;

    });
  }

  getPermission() async {
    bool services;
    LocationPermission permission;
    services = await Geolocator.isLocationServiceEnabled();
    if (services == false) {
      AwesomeDialog(
              context: context,
              title: 'services',
              body: const Text('Location not enabled'))
          .show();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  getCurrentUserLocation() async {
    currentLocation =
        await Geolocator.getCurrentPosition().then((value) => value);
    latitude = currentLocation!.latitude;
    longitude = currentLocation!.longitude;

    changeCameraPosition(latitude, longitude);

    getLocationAddressInformation(latitude, longitude);

    setState(() {});
  }

  void changeCameraPosition(latitude, longitude) async {
    _kGooglePlex = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );


    final c = await _controller.future;
    final p =
        CameraPosition(target: LatLng(latitude, longitude), zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  Future<String> getLocationAddressInformation(
      double latitude, double longitude) async {
    latitude = latitude;
    longitude = longitude;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    Placemark placeMark = placemarks[0];

    // _cityController.text =
    //     placeMark.locality == null ? "" : placeMark.locality!;
    // _neighborhoodController.text =
    //     placeMark.subLocality == null ? "" : placeMark.subLocality!;
    // _streetNameController.text =
    //     placeMark.street == null ? "" : placeMark.street!;

    return "${placeMark.subLocality}, ${placeMark.subLocality}, ${placeMark.subLocality}, ${placeMark.street}";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    openDrawerCustom() {
      _scaffoldKey.currentState!.openDrawer();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: CustomDrawer(
        closeDrawerCustom: () {
          openDrawerCustom();
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ScreenHeader('lib/assets/images/giftIcon.png'),
          Expanded(
            child: isLoading
                ? Center(
                    child: Image.asset(
                      "lib/assets/images/MunchLoadingTransparent.gif",
                      height: 100.0,
                      width: 100.0,
                    ),
                  )
                : Stack(
                  children: [
                    GoogleMap(
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        onTap: (latLng) async {
                          _markers.add(Marker(
                              markerId: const MarkerId('Address'),
                              position: latLng,
                              infoWindow: const InfoWindow(title: 'Address')));

                          latitude = latLng.latitude;
                          longitude = latLng.longitude;

                          //_getLocationAddressInformation(
                          //    latLng.latitude, latLng.longitude);

                          getLocationAddressInformation(latitude, longitude);

                          setState(() {});
                        },
                        gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(
                            () => EagerGestureRecognizer())),
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.transparent,

                          height: size.height*0.2,
                          width: size.width,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),
                            itemCount: storeLocationsList.length,
                            itemBuilder: (_,index){
                              return InkWell(
                                onTap: ()async{

                                  changeCameraPosition(
                                      double.parse(storeLocationsList[index]['Latitude'].toString()), double.parse(storeLocationsList[index]['Longitude'].toString())
                                  );

                                },
                                child: Container(
                                  color: Colors.pink,
                                  margin:  EdgeInsets.symmetric(
                                      vertical: size.height*0.005,
                                      horizontal: size.width*0.05
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: size.width*0.025,
                                        vertical: size.height*0.01
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              storeLocationsList[index]["Name"],
                                              style: TextStyle(
                                                  fontSize: size.height*0.019,
                                                  color: Colors.white
                                              ),
                                            ),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          ),
          FooterCustom(
            '-1',
            openDrawerCustom: () {
              openDrawerCustom();
            },
          ),
        ],
      ),
    );
  }
}
