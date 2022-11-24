import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Services/ShowMessage.dart';
import 'Widgets/Screen_Header.dart';
import './models/CategoryObj.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
class AddressesScreen extends StatefulWidget {
  AddressesScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<AddressesScreen> createState() => _State(AddressesScreen);
}

class _State extends State<AddressesScreen> {
  _State(Type addressesScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var addressesList = [];

  Position? currentLocation;

  double latitude = 0;

  double longitude = 0;

  bool addUpdateAddress = false;
  bool isUpdate = false;
  String? addressEdit;

  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(31.9594, 35.859),
    zoom: 12.0,
  );

  final Set<Marker> _markers = {};
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();


  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getAddresses();
    getPermission();
    getCurrentUserLocation();
  }

  addAddress() async {
    if (titleController.text.isEmpty ||
        desController.text.isEmpty ) {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.warning,
          AppLocalizations.of(context)!.fillAll);
      showMessage.showAlertDialog(context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kaddCustomerAddressAPI/',
        '{"AddressName":"${titleController.text}","LocationDescription":"${desController.text}","CustomerGuid":"${prefs.getString('CustomerGuid')}","Longitude":"${longitude.toString()}","Latitude":"${latitude.toString()}","CityId":"-1","DistrictId":"-1"}');

    var response = await networkHelper.postData();
    print('response = $response');
    setState(() {
      isLoading = false;
    });
    if (response == "1") {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.successfullTitle,
          AppLocalizations.of(context)!.done);
      showMessage.showAlertDialog(context);
      getAddresses();
      setState(() {
        addUpdateAddress = false;
        isUpdate = false;
        addressEdit = null;
        titleController.clear();
        desController.clear();

      });
      return;
    } else {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.errorLabel,
          AppLocalizations.of(context)!.unknownError);
      showMessage.showAlertDialog(context);
      return;
    }
  }


  deleteAddress(String addressId) async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kdeleteCustomerAddressAPI/',
        '{"AddressId":"$addressId","CustomerGuid":"${prefs.getString('CustomerGuid')}"}');

    var response = await networkHelper.postData();
    print('response = $response');
    setState(() {
      isLoading = false;
    });
    if (response == "1") {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.successfullTitle,
          AppLocalizations.of(context)!.done);
      showMessage.showAlertDialog(context);
      getAddresses();

      return;
    } else {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.errorLabel,
          AppLocalizations.of(context)!.unknownError);
      showMessage.showAlertDialog(context);
      return;
    }
  }

  editAddress(String addressId) async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kupdateCustomerAddressAPI/',
        '{"AddressId":"$addressId","AddressName":"${titleController.text}","LocationDescription":"${desController.text}","CustomerGuid":"${prefs.getString('CustomerGuid')}","Longitude":"${longitude.toString()}","Latitude":"${latitude.toString()}","CityId":"-1","DistrictId":"-1"}');

    var response = await networkHelper.postData();
    print('response = $response');
    setState(() {
      isLoading = false;
    });
    if (response == "1") {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.successfullTitle,
          AppLocalizations.of(context)!.done);
      showMessage.showAlertDialog(context);
      getAddresses();
      setState(() {
        addUpdateAddress = false;
        isUpdate = false;
        addressEdit = null;

        titleController.clear();
        desController.clear();
      });
      return;
    } else {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.errorLabel,
          AppLocalizations.of(context)!.unknownError);
      showMessage.showAlertDialog(context);
      return;
    }
  }

  void getAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetCustomerAddressesAPI/',
        '{"CustomerGuid":"${prefs.getString('CustomerGuid')}"}');
    var response = await networkHelper.postData();
    //print('response addressesList = $response');
    addressesList = response['GetCustomerAddressesResult'];
    print('addressesList = $addressesList');
    print('addressesList = ${addressesList.first['AddressName']}');

    setState(() {
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

    _markers.clear();

    _markers.add(Marker(
        markerId: const MarkerId('Address'),
        position: LatLng(latitude, longitude),
        infoWindow: const InfoWindow(title: 'Address')));

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
                          color: addUpdateAddress?Colors.white:Colors.transparent,

                          height: size.height*0.2,
                          width: size.width,
                          child: addUpdateAddress
                              ?Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      isUpdate&&addressEdit!=null?editAddress(addressEdit!):addAddress();
                                    },
                                    child: Container(
                                      height: size.height*0.05,
                                      width: size.width*0.5,
                                      color: Colors.green.withOpacity(0.8),
                                      child: Center(
                                        child: Text(
                                          isUpdate?AppLocalizations.of(context)!.edit:AppLocalizations.of(context)!.add,
                                          style: TextStyle(
                                            fontSize: size.height*0.022,
                                              color: Colors.white,
                                            fontWeight: FontWeight.bold

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        addUpdateAddress = false;
                                        isUpdate = false;
                                        addressEdit = null;


                                      });
                                    },
                                    child: Container(
                                      height: size.height*0.05,
                                      width: size.width*0.5,
                                      color: Colors.red.withOpacity(0.8),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.cancel,
                                          style: TextStyle(
                                              fontSize: size.height*0.022,
                                            color: Colors.white,
                                              fontWeight: FontWeight.bold

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 30, right: 30, top: 20, bottom: 10),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10.0)),
                                height: 40,
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: TextField(
                                            controller: titleController,
                                            decoration: InputDecoration(
                                              hintText:
                                              AppLocalizations.of(context)!.locName,
                                              //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                              border: InputBorder.none,
                                            ),
                                            keyboardType:
                                            TextInputType.visiblePassword,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.height*0.017,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 30, right: 30, top: 20, bottom: 20),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10.0)),
                                height: 40,
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: TextField(
                                            controller: desController,
                                            decoration: InputDecoration(
                                              hintText:
                                              AppLocalizations.of(context)!.descOfLoc,
                                              //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                              border: InputBorder.none,
                                            ),
                                            keyboardType:
                                            TextInputType.visiblePassword,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.height*0.017,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                              :ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),
                            itemCount: addressesList.length,
                            itemBuilder: (_,index){
                              return Container(
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
                                            addressesList[index]["AddressName"],
                                            style: TextStyle(
                                              fontSize: size.height*0.019,
                                                color: Colors.white
                                            ),
                                          ),
                                          Text(
                                            addressesList[index]["LocationDescription"],
                                            style: TextStyle(
                                                fontSize: size.height*0.018,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.edit,color: Colors.white),
                                        iconSize: size.height*0.025,
                                        onPressed: (){
                                          setState(() {
                                            addUpdateAddress = true;
                                            isUpdate = true;
                                            addressEdit = addressesList[index]['AddressId'].toString();
                                            titleController.text = addressesList[index]['AddressName'];
                                            desController.text = addressesList[index]['LocationDescription'];
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close,color: Colors.white,),
                                        iconSize: size.height*0.025,
                                        onPressed: (){
                                          deleteAddress(addressesList[index]['AddressId'].toString());
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              addUpdateAddress = !addUpdateAddress;
                              isUpdate = false;
                              addressEdit = null;
                           });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: size.height*0.03),
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width*0.02,
                              vertical: size.height*0.01
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(size.height*0.03),
                              color: Colors.pink,
                            ),
                            child: Text(
                              addUpdateAddress?AppLocalizations.of(context)!.cancel:AppLocalizations.of(context)!.addNewAddress,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height*0.023
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
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
