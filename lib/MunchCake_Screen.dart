//import 'dart:html';

import 'dart:io';

import 'package:flutter/material.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'ContactUs_Screen.dart';
import '../Services/ShowMessage.dart';
import 'package:image_picker/image_picker.dart';
import '../Cart_Screen.dart';

class MunchCakeScreen extends StatefulWidget {
  //const MunchCakeScreen({Key? key}) : super(key: key);

  final String productId;
  // ignore: use_key_in_widget_constructors
  MunchCakeScreen({required this.productId});

  @override
  // ignore: no_logic_in_create_state
  State<MunchCakeScreen> createState() => _State(MunchCakeScreen);
}

class _State extends State<MunchCakeScreen> {
  _State(Type ordersScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBasic = true;
  var _cakeDescriptionText = TextEditingController();
  var _cakeMessageText = TextEditingController();

  var isLoading = false;
  var layersList = [];
  var flavorsList = [];
  var sizeInfo = '';
  var emptysearch = '';
  var categoriesList = [];
  var colorsList = [];
  var sizesList = [];
  var pricesList = [];
  var productsList = [];
  var categoryIdStr = '-1';
  var cakeSizeIdStr = '-1';
  var cakeColorIdStr = '-1';
  var searchKeyStr = '';
  var pageNumber = 1;
  var fromPriceStr = '0';
  var toPriceStr = '100000';
  var layerSelected = -1;
  var basicLayersCount = 0;
  var isLayerFixed = 0;
  var cakePriceStr = '0';
  var deliveryFeesStr = '0';
  var discountStr = '0';
  var totalStr = '0';
  var selectedFlavorsList = [];
  var firstFlavorSelected = -1;
  var secondFlavorSelected = -1;
  var imagesList = [];
  var imagesUrlsList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getLayers();
    getFlavors();
    getInfo();
    getCategories();
    getFilters();
    getProducts();
    getProductDetails();
  }

  void getLayers() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetCakePersonsLayersMunchCakeAPI/',
        '{"langId":"${prefs.getString('langId')}","ProductId":"${widget.productId}"}');
    var response = await networkHelper.postData();
    layersList = response['GetCakePersonsLayersMunchCakeResult'];
    setState(() {
      isLoading = false;
    });
  }

  void getFlavors() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetCakeFlavorsMunchCakeAPI/',
        '{"langId":"${prefs.getString('langId')}"}');
    var response = await networkHelper.postData();
    flavorsList = response['GetCakeFlavorsMunchCakeResult'];
    setState(() {
      isLoading = false;
    });
  }

  void getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetInfoTextMunchCakeAPI/',
        '{"langId":"${prefs.getString('langId')}"}');
    var response = await networkHelper.postData();
    List tmp = response['GetInfoTextMunchCakeResult'];
    if (tmp.isNotEmpty) {
      for (var i = 0; i < tmp.length; i++) {
        if (tmp[i]['Name'] == 'CakeSizeInfo') {
          sizeInfo = tmp[i]['Description'];
        } else if (tmp[i]['Name'] == 'emptysearch') {
          emptysearch = tmp[i]['Description'];
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchCakeCategoriesAPI/${prefs.getString('langId')}',
        '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    categoriesList = await networkHelper.getData();
    setState(() {
      isLoading = false;
    });
  }

  void getFilters() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchCakeFilterAPI/',
        '{"langId":"${prefs.getString('langId')}"}');
    var response = await networkHelper.postData();
    colorsList = response['GetMunchCakeFilterResult']['LstCakeColor'];
    sizesList = response['GetMunchCakeFilterResult']['LstCakeSize'];
    pricesList = response['GetMunchCakeFilterResult']['LstCakePriceRange'];
    setState(() {
      isLoading = false;
    });
  }

  void getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchCakeProductsAPI/',
        '{"langId":"${prefs.getString('langId')}","CityId":"-1","DistrictId":"-1","ZoneId":"-1","CategoryId":"$categoryIdStr","SearchKey":"$searchKeyStr","MinProductPrice":"$fromPriceStr","MaxProductPrice":"$toPriceStr","CakeSizeId":"$cakeSizeIdStr","CakeColorId":"$cakeColorIdStr","PageNumber":"$pageNumber","PageSize":"10"}');
    var response = await networkHelper.postData();
    productsList = response['GetMunchCakeProductsResult']
        ['lstECommerceProductsSearchResults'];
    setState(() {
      isLoading = false;
    });
  }

  void getProductDetails() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchCakeItemCartDetailsAPI/',
        '{"ProductId":"${widget.productId}","CustomerGuid":"${prefs.getString('CustomerGuid')}"}');
    var response = await networkHelper.postData();
    print('response = $response');
    setState(() {
      isLoading = false;
    });
  }

  void getPrice() async {
    var numberOfPersons = -1;
    var numberOfLayers = -1;
    if (layerSelected != -1) {
      numberOfPersons = layersList[layerSelected]['NumberOfPersons'];
      numberOfLayers = layersList[layerSelected]['NumberOfLayers'];
    }

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchCakeProductPriceDetailAPI/',
        '{"ProductId":"${widget.productId}","CustomerGuid":"${prefs.getString('CustomerGuid')}","NumberOfPersons":"$numberOfPersons","NumberOfLayers":"$numberOfLayers"}');
    var response = await networkHelper.postData();
    print('response = $response');
    setState(() {
      cakePriceStr = response['GetMunchCakeProductPriceDetailResult']
              ['CakePrice']
          .toString();
      deliveryFeesStr = response['GetMunchCakeProductPriceDetailResult']
              ['DeliveryFees']
          .toString();
      discountStr = response['GetMunchCakeProductPriceDetailResult']['Discount']
          .toString();
      totalStr =
          response['GetMunchCakeProductPriceDetailResult']['Total'].toString();
    });
  }

  void addToCartPressed() {
    imagesUrlsList = [];
    imagesUrlsList.add(
        'https://munch-image-live.s3.us-east-2.amazonaws.com/files_from_node/165641299959528-06-2022-01-43-180.png%20customer-9eb00f30-e5f6-4bbc-bc81-3ac1c142388a');

    // if (imagesList.isEmpty) {
    //   ShowMessage showMessage =
    //       ShowMessage('', AppLocalizations.of(context)!.imagesRequired);
    //   showMessage.showAlertDialog(context);
    //   return;
    // }

    if (layerSelected == -1) {
      ShowMessage showMessage =
          ShowMessage('', AppLocalizations.of(context)!.sizeRequired);
      showMessage.showAlertDialog(context);
      return;
    }
    for (var i = 0; i < selectedFlavorsList.length; i++) {
      var first = selectedFlavorsList[i]['first'].toString();
      var second = selectedFlavorsList[i]['second'].toString();
      if (first == '-1' || second == '-1') {
        ShowMessage showMessage =
            ShowMessage('', AppLocalizations.of(context)!.flavorsRequired);
        showMessage.showAlertDialog(context);
        return;
      }
    }

    if (_cakeDescriptionText.text == '') {
      ShowMessage showMessage = ShowMessage(
          '', AppLocalizations.of(context)!.cakeDescriptionRequired);
      showMessage.showAlertDialog(context);
      return;
    }
    addToCart();
  }

  void addToCart() async {
    var lstLayersInfo = '[';
    for (var i = 0; i < selectedFlavorsList.length; i++) {
      // ignore: non_constant_identifier_names
      var LayerNumber = (i + 1).toString();
      var first = selectedFlavorsList[i]['first'].toString();
      var second = selectedFlavorsList[i]['second'].toString();
      lstLayersInfo =
          '$lstLayersInfo{"LayerNumber":$LayerNumber,"FirstHalfFlavorId":$first,"SecondHalfFlavorId":$second},';
    }
    lstLayersInfo = lstLayersInfo.substring(0, lstLayersInfo.length - 1);
    lstLayersInfo = '$lstLayersInfo]';

    // ignore: non_constant_identifier_names
    var LstPhotos = '[';
    for (var i = 0; i < imagesUrlsList.length; i++) {
      // ignore: non_constant_identifier_names
      var picturePath = imagesUrlsList[i].toString();
      LstPhotos = '$LstPhotos{"PicturePath":"$picturePath"},';
    }
    LstPhotos = LstPhotos.substring(0, LstPhotos.length - 1);
    LstPhotos = '$LstPhotos]';

    var numberOfPersons = layersList[layerSelected]['NumberOfPersons'];
    var numberOfLayers = layersList[layerSelected]['NumberOfLayers'];

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kaddToCartMunchCakeProductAPI/',
        '{"ProductId":"${widget.productId}","CustomerGuid":"${prefs.getString('CustomerGuid')}","NumberOfPersons":"$numberOfPersons","NumberOfLayers":"$numberOfLayers","LanguageId":"${prefs.getString('langId')}","lstLayersInfo":$lstLayersInfo,"LstPhotos":$LstPhotos,"CakeMessage":"${_cakeMessageText.text}","CakeDescription":"${_cakeDescriptionText.text}","IsAddToCart":1}');
    var response = await networkHelper.postData();
    print('response = $response');
    Navigator.of(context).push(MaterialPageRoute<CartScreen>(
      builder: (BuildContext context) {
        return const CartScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    openDrawerCustom() {
      _scaffoldKey.currentState!.openDrawer();
    }

    void showChooseSizeCustomDialog(BuildContext context) async {
      await showGeneralDialog(
        context: context,
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.7),
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (_, __, ___) {
          return Center(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  itemCount: layersList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    onTap: () {
                      setState(() {
                        layerSelected = index;
                        basicLayersCount =
                            layersList[layerSelected]['NumberOfLayers'];

                        selectedFlavorsList = [];
                        for (var i = 0; i < basicLayersCount; i++) {
                          var tmp = {
                            "first": "-1",
                            "second": "-1",
                            "firstValue": "",
                            "secondValue": ""
                          };
                          selectedFlavorsList.add(tmp);
                        }
                        Navigator.of(context, rootNavigator: true).pop();

                        getPrice();
                      });
                    },
                    child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DefaultTextStyle(
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            child: Text(
                              layersList[index]['PersonsLayersText'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 60, right: 60),
                            child: Divider(
                              color: Colors.black,
                              thickness: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
        },
      ).then((value) {});
    }

    void showChooseFlavorsCustomDialog(
        BuildContext context, String half) async {
      await showGeneralDialog(
        context: context,
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.7),
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (_, __, ___) {
          return Center(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  itemCount: flavorsList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    onTap: () {
                      setState(() {
                        if (half == 'first') {
                          var tmp = {
                            "first": flavorsList[index]['Id'],
                            "second": selectedFlavorsList[firstFlavorSelected]
                                ['second'],
                            "firstValue": flavorsList[index]['Name'],
                            "secondValue":
                                selectedFlavorsList[firstFlavorSelected]
                                    ['secondValue']
                          };
                          selectedFlavorsList[firstFlavorSelected] = tmp;
                        } else {
                          var tmp = {
                            "first": selectedFlavorsList[secondFlavorSelected]
                                ['first'],
                            "second": flavorsList[index]['Id'],
                            "firstValue":
                                selectedFlavorsList[secondFlavorSelected]
                                    ['firstValue'],
                            "secondValue": flavorsList[index]['Name']
                          };
                          selectedFlavorsList[secondFlavorSelected] = tmp;
                        }
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    },
                    child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DefaultTextStyle(
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            child: Text(
                              flavorsList[index]['Name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 60, right: 60),
                            child: Divider(
                              color: Colors.black,
                              thickness: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
        },
      ).then((value) {});
    }

    void chooseImage() {
      print('here');
      showAlertDialog(BuildContext context) {
        // set up the button
        Widget takePhotoButton = TextButton(
          child: Text(AppLocalizations.of(context)!.takePhoto),
          onPressed: () async {
            Navigator.pop(context);
            final ImagePicker _picker = ImagePicker();
            final XFile? image = await _picker.pickImage(
                source: ImageSource.camera,
                maxWidth: 400,
                maxHeight: 400,
                imageQuality: 60);
            setState(() {
              imagesList.add(image);
              print('imagesList');
            });
          },
        );
        Widget photoLibraryButton = TextButton(
          child: Text(AppLocalizations.of(context)!.photoLibrary),
          onPressed: () async {
            Navigator.pop(context);
            final ImagePicker _picker = ImagePicker();
            final XFile? image = await _picker.pickImage(
                source: ImageSource.gallery,
                maxWidth: 400,
                maxHeight: 400,
                imageQuality: 60);
            setState(() {
              imagesList.add(image);
            });
          },
        );
        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text(AppLocalizations.of(context)!.uploadYourImage),
          content: Text(AppLocalizations.of(context)!.choose),
          actions: [
            takePhotoButton,
            photoLibraryButton,
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

      showAlertDialog(context);
    }

    Widget uploadImageWidget() {
      return Padding(
        padding:
            const EdgeInsets.only(top: 40, bottom: 20, left: 10, right: 10),
        child:SizedBox(
          width: size.width*0.75,
          height: size.height*0.1,
          child: ElevatedButton(
            onPressed: chooseImage,
            // ignore: prefer_const_constructors
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(242, 104, 130, 1.0)),
            ),
            child: Text(
              AppLocalizations.of(context)!.uploadYourImage,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: size.height*0.018,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    Widget imagesWidget() {
      print('here images');
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(onTap: (){chooseImage();},child: Image.file(File(imagesList[0].path),height: size.height*0.1,)),
            ),
          ],
        ),
      );
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ScreenHeader('lib/assets/images/arrow1.png'),
          isLoading
              ? Center(
                  child: Image.asset(
                    "lib/assets/images/MunchLoadingTransparent.gif",
                    height: 100.0,
                    width: 100.0,
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.93 - 120,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 20),
                          child: Text(
                            AppLocalizations.of(context)!.makeOwnCake,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.022,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width*0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width*0.4,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20
                                  ),
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        isBasic = true;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          isBasic?Icons.radio_button_checked:Icons.radio_button_off,
                                          size: size.height*0.023,
                                          color: Color.fromRGBO(242, 104, 130, 1.0),
                                        ),
                                        SizedBox(width: size.width*0.02,),
                                        Text(
                                          AppLocalizations.of(context)!.basic,
                                          style:  TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontSize: size.height*0.018,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20
                                    ),
                                    child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          isBasic = false;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            !isBasic?Icons.radio_button_checked:Icons.radio_button_off,
                                            size: size.height*0.023,
                                            color: Color.fromRGBO(242, 104, 130, 1.0),
                                          ),
                                          SizedBox(width: size.width*0.02,),
                                          Text(
                                            AppLocalizations.of(context)!.advanced,
                                            style:  TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                              fontSize: size.height*0.018,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 20, bottom: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                imagesList.isEmpty
                                    ? uploadImageWidget()
                                    : imagesWidget(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: Text(
                                    AppLocalizations.of(context)!.allUploads,
                                    style:  TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: size.height*0.015,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, top: 20, bottom: 20),
                                  child: Text(
                                    AppLocalizations.of(context)!.pricesMay,
                                    style:  TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: size.height*0.015,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute<ContactUsScreen>(
                                      builder: (BuildContext context) {
                                        return const ContactUsScreen();
                                      },
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .contactMunchCake,
                                      style:  TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: size.height*0.015,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height*0.02,)
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.sizeOfYourCake,
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.02,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ShowMessage showMessage =
                                      ShowMessage('', sizeInfo);
                                  showMessage.showAlertDialog(context);
                                },
                                child: SizedBox(
                                  width: size.width*0.05,
                                  child: Image.asset(
                                    'lib/assets/images/icons-35.png',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showChooseSizeCustomDialog(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 20),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            height: size.height*0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 10),
                                  child: Text(
                                    layerSelected == -1
                                        ? AppLocalizations.of(context)!
                                            .chooseSize
                                        : layersList[layerSelected]
                                            ['PersonsLayersText'],
                                    style:  TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height*0.018,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  width: size.width*0.05,
                                  child: Image.asset(
                                    'lib/assets/images/dropDownArrow.png',
                                    color: const Color.fromRGBO(
                                        242, 104, 130, 1.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 30, right: 30, bottom: 10),
                          child: Divider(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 30, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.flavors,
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.02,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          itemCount: basicLayersCount,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            width: MediaQuery.of(context).size.width - 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 25,right: 25),
                                  child: Text(
                                    'Layer ${index + 1}',
                                    style:  TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height*0.018,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          firstFlavorSelected = index;
                                          showChooseFlavorsCustomDialog(
                                              context, 'first');
                                        },
                                        child: Container(

                                          padding: const EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          height: size.height*0.045,
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.38,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  selectedFlavorsList[index]
                                                              ['first'] ==
                                                          '-1'
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .firstHalf
                                                      : selectedFlavorsList[index]
                                                          ['firstValue'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: size.height*0.018,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                width: size.width*0.05,
                                                child: Image.asset(
                                                  'lib/assets/images/dropDownArrow.png',
                                                  color: const Color.fromRGBO(
                                                      242, 104, 130, 1.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          secondFlavorSelected = index;
                                          showChooseFlavorsCustomDialog(
                                              context, 'second');
                                        },
                                        child: Container(

                                          padding: const EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          height: size.height*0.045,
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.38,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  selectedFlavorsList[index]
                                                              ['second'] ==
                                                          '-1'
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .secondHalf
                                                      : selectedFlavorsList[index]
                                                          ['secondValue'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: size.height*0.018,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                width: size.width*0.05,
                                                child: Image.asset(
                                                  'lib/assets/images/dropDownArrow.png',
                                                  color: const Color.fromRGBO(
                                                      242, 104, 130, 1.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 30, bottom: 10,top: 10),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.cakeDescription,
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.02,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            height: size.height*0.15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: _cakeDescriptionText,
                                          decoration: InputDecoration(
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .munchCakeDescPlaceholder,
                                            //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.multiline,
                                          style:  TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.height*0.016,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 30, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.cakeMessage,
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.018,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            height: size.height*0.15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: _cakeMessageText,
                                          decoration: InputDecoration(
                                            hintText: AppLocalizations.of(
                                                    context)!
                                                .munchCakeMessagePlaceholder,
                                            //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.multiline,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.height*0.015,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30, top: 30, right: 30, bottom: 50),
                          width: MediaQuery.of(context).size.width - 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.cakeDetails,
                                      style:  TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height*0.02,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.total,
                                      style:  TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height*0.016,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      '$totalStr ${AppLocalizations.of(context)!.sar}',
                                      style:  TextStyle(
                                        color:
                                            Color.fromRGBO(242, 104, 130, 1.0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height*0.018,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.vat,
                                  style:  TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height*0.014,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: size.width*0.7,
                                child: ElevatedButton(
                                  onPressed: addToCartPressed,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromRGBO(
                                                242, 104, 130, 1.0)),
                                  ),
                                  child: Text(
                                      AppLocalizations.of(context)!.addToCart),
                                ),
                              ),
                              SizedBox(height: size.height*0.02,)
                            ],
                          ),
                        ),
                      ],
                    ),
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
