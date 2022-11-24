import 'package:flutter/material.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../Services/ShowMessage.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class SaveVeryMunchScreen extends StatefulWidget {
  SaveVeryMunchScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<SaveVeryMunchScreen> createState() => _State(SaveVeryMunchScreen);
}

class _State extends State<SaveVeryMunchScreen> {
  _State(Type ordersScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var giftsList = [];
  var packagesList = [];
  var listFlag = 1;
  var firstName = '';

  var isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getGifts();
    getPackages();
  }

  void getGifts() async {
    final prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString('FirstName')!;
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetCustomerGiftCardHistoryAPI/${prefs.getString('MobileNumber')}/${prefs.getString('langId')}',
        '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    var response = await networkHelper.getData();
    for (var i = 0; i < response.length; i++) {
      if (response[i]['IsUsed'] == false) {
        giftsList.add(response[i]);
      }
    }
    print('giftsList = ${giftsList}');
    setState(() {
      isLoading = false;
    });
  }

  void getPackages() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryProductsForComboCategoryAPI/${prefs.getString('langId')}/55/-1/-1/-1',
        '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    packagesList = await networkHelper.getData();
    print('packagesList = ${packagesList}');
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    openDrawerCustom() {
      _scaffoldKey.currentState!.openDrawer();
    }

    var selectedPrice = '';
    var selectedPoductId = '';
    var selectedCopounCode = '';

    redeemNowBtn() async {
      var now = DateTime.now();
      var formatter = DateFormat('MM/dd/yyyy');
      String formattedDate = formatter.format(now);
      print(formattedDate);

      final prefs = await SharedPreferences.getInstance();
      var customerGuid = '-1';
      if (prefs.getString('CustomerGuid') != null) {
        customerGuid = prefs.getString('CustomerGuid')!;
      }

      setState(() {
        isLoading = true;
      });

      NetworkHelper networkHelper = NetworkHelper(
          '$kbaseUrl/$kapplyOrRevokeMunchCouponCodeAPI/',
          '{"CustomerId":"${prefs.getString('CustomerId')}","CustomerGuid":"$customerGuid","StoreId":"-1","CouponCode":"$selectedCopounCode","IsApplyCopoun":"1","langId":"${prefs.getString('langId')}","OrderType":"-1","OrderDate":"$formattedDate","CityId":"-1","DistrictId":"-1","ZoneId":"-1"}');
      var response = await networkHelper.postData();
      print(response);

      setState(() {
        isLoading = false;
      });

      if (response['ApplyOrRevokeMunchCouponCodeResult']['Status'].toString() ==
          'SUCCESS') {
        Navigator.of(context).push(MaterialPageRoute<MyHomePage>(
          builder: (BuildContext context) {
            return MyHomePage(
              title: '',
            );
          },
        ));
      } else {
        ShowMessage showMessage = ShowMessage(
            '',
            response['ApplyOrRevokeMunchCouponCodeResult']['ErrorResponse']
                ['ErrorMessage']);
        showMessage.showAlertDialog(context);
      }
    }

    addToCartBtn() async {
      var now = DateTime.now();
      var formatter = DateFormat('MM/dd/yyyy');
      String formattedDate = formatter.format(now);
      print(formattedDate);

      final prefs = await SharedPreferences.getInstance();
      var customerGuid = '-1';
      if (prefs.getString('CustomerGuid') != null) {
        customerGuid = prefs.getString('CustomerGuid')!;
      }

      setState(() {
        isLoading = true;
      });

      NetworkHelper networkHelper = NetworkHelper(
          '$kbaseUrl/$kaddUpdateShoppingCartItemMunchBakeryAPI/',
          '{"CustomerId":"-1","CustomerGuid":"$customerGuid","StoreId":"-1","Price":"$selectedPrice","Quantity":"1","ProductId":"$selectedPoductId","MarkAsDeleted":"0","ShoppingCartId":"-1","OrderDate":"$formattedDate","CityId":"-1","DistrictId":"-1","ZoneId":"-1"}');
      var response = await networkHelper.postData();
      print(response);

      setState(() {
        isLoading = false;
      });
      print(response['IsInStock']);
      if (response['IsInStock'] == 'true') {
        ShowMessage showMessage =
            ShowMessage('', AppLocalizations.of(context)!.addedSuccessfully);
        showMessage.showAlertDialog(context);
      } else if (response['IsInStock'] == 'false') {
        ShowMessage showMessage = ShowMessage(
            AppLocalizations.of(context)!.errorLabel,
            AppLocalizations.of(context)!.outOfStock);
        showMessage.showAlertDialog(context);
      } else {
        ShowMessage showMessage = ShowMessage(
            AppLocalizations.of(context)!.errorLabel,
            AppLocalizations.of(context)!.unknownError);
        showMessage.showAlertDialog(context);
      }
    }

    Widget allListWidget() {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.93 - 270,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 0.45,
          ),
          itemCount: giftsList.length + packagesList.length,
          itemBuilder: (BuildContext context, int index) => Container(
            color: Colors.white,
            margin: const EdgeInsets.all(10),
            child: index == 0 &&giftsList.isNotEmpty
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                          imageUrl: giftsList[index]['PhotoUrl'] ?? '',
                          //placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          // width: double.maxFinite,
                          height: size.height*0.27,

                          fit: BoxFit.fill,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height*0.25,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              giftsList[index]['Description'],
                              style:  TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: size.height*0.015,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  giftsList[index]['CouponCode'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: size.height*0.015,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: size.height*0.07,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: giftsList[index]
                                              ['CouponCode']));

                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  AppLocalizations.of(context)!
                                                      .copied)));
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      side: MaterialStateProperty.all(
                                          const BorderSide(
                                              color: Colors.black,
                                              width: 1.0,
                                              style: BorderStyle.solid)),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.copy,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Divider(color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Valid to ${giftsList[index]['CouponExpireDate']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Divider(color: Colors.grey),
                          ),
                          Container(
                            height: 30,
                            width: 150,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10),
                            child: OutlinedButton(
                              onPressed: () {
                                selectedCopounCode =
                                    giftsList[index]['CouponCode'];
                                redeemNowBtn();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                side: MaterialStateProperty.all(
                                    const BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                        style: BorderStyle.solid)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.redeemNow,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                          imageUrl: packagesList[index]['lstPictures'][0]
                                  ['PicturePath'] ??
                              '',
                          //placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          // width: double.maxFinite,
                          height: size.height*0.27,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           SizedBox(
                            height: size.height*0.25,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              packagesList[index]['Description'],
                              style:  TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: size.height*0.015,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              packagesList[index]['Price'] ==
                                      packagesList[index]['OldPrice']
                                  ? '${packagesList[index]['Price'].toString()} ${AppLocalizations.of(context)!.sar}'
                                  : 'You save ${packagesList[index]['OldPrice'] - packagesList[index]['Price']} SAR\n${packagesList[index]['Price'].toString()} ${AppLocalizations.of(context)!.sar}',
                              style:  TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: size.height*0.015,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Divider(color: Colors.grey),
                          ),
                          Container(
                            height: size.height*0.04,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10),
                            child: OutlinedButton(
                              onPressed: () async {
                                selectedPrice = packagesList[index]
                                        ['Price']
                                    .toString();
                                selectedPoductId =
                                    packagesList[index]['Id'].toString();

                                addToCartBtn();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                side: MaterialStateProperty.all(
                                    const BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                        style: BorderStyle.solid)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.addToCart,
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.015,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      );
    }

    Widget offersListWidget() {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.93 - 270,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 0.45,
          ),
          itemCount: giftsList.length,
          itemBuilder: (BuildContext context, int index) => Container(
            color: Colors.white,
            margin: const EdgeInsets.all(10),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: giftsList[index]['PhotoUrl'] ?? '',
                    //placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    // width: double.maxFinite,
                    height: size.height*0.27,

                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height*0.25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        giftsList[index]['Description'],
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: size.height*0.015,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            giftsList[index]['CouponCode'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: size.height*0.015,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: size.height*0.07,
                            child: OutlinedButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: giftsList[index]
                                    ['CouponCode']));

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .copied)));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.white),
                                side: MaterialStateProperty.all(
                                    const BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                        style: BorderStyle.solid)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30.0)),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.copy,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Divider(color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Valid to ${giftsList[index]['CouponExpireDate']}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Divider(color: Colors.grey),
                    ),
                    Container(
                      height: 30,
                      width: 150,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(10),
                      child: OutlinedButton(
                        onPressed: () {
                          selectedCopounCode =
                          giftsList[index]['CouponCode'];
                          redeemNowBtn();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.white),
                          side: MaterialStateProperty.all(
                              const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                  style: BorderStyle.solid)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(30.0)),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.redeemNow,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
        ),
      );
    }

    Widget packagesListWidget() {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.93 - 270,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 0.45,
          ),
          itemCount: packagesList.length,
          itemBuilder: (BuildContext context, int index) => Container(
            margin: const EdgeInsets.all(10),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: packagesList[index]['lstPictures'][0]
                    ['PicturePath'] ??
                        '',
                    //placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    // width: double.maxFinite,
                    height: size.height*0.27,
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height*0.25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        packagesList[index]['Description'],
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: size.height*0.015,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        packagesList[index]['Price'] ==
                            packagesList[index]['OldPrice']
                            ? '${packagesList[index]['Price'].toString()} ${AppLocalizations.of(context)!.sar}'
                            : 'You save ${packagesList[index]['OldPrice'] - packagesList[index]['Price']} SAR\n${packagesList[index]['Price'].toString()} ${AppLocalizations.of(context)!.sar}',
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: size.height*0.015,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Divider(color: Colors.grey),
                    ),
                    Container(
                      height: size.height*0.04,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(10),
                      child: OutlinedButton(
                        onPressed: () async {
                          selectedPrice = packagesList[index]
                          ['Price']
                              .toString();
                          selectedPoductId =
                              packagesList[index]['Id'].toString();

                          addToCartBtn();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.white),
                          side: MaterialStateProperty.all(
                              const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                  style: BorderStyle.solid)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(30.0)),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.addToCart,
                          style:  TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.015,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
          ScreenHeader('lib/assets/images/giftIcon.png'),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:  EdgeInsetsDirectional.only(top: 10, start: size.width*0.05),
                        child: Text(
                          '${AppLocalizations.of(context)!.hello} ${firstName}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.02,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        margin:  EdgeInsetsDirectional.only(top: 10, start: size.width*0.05),
                        child: Text(
                          AppLocalizations.of(context)!.hereGifts,
                          style:  TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: size.height*0.019,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.03),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  listFlag = 1;
                                });
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: listFlag == 1
                                        ? const Color.fromRGBO(
                                            242, 104, 130, 1.0)
                                        : Colors.black,
                                    width: 1.0,
                                    style: BorderStyle.solid)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.all,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.03),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  listFlag = 2;
                                });
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: listFlag == 2
                                        ? const Color.fromRGBO(
                                            242, 104, 130, 1.0)
                                        : Colors.black,
                                    width: 1.0,
                                    style: BorderStyle.solid)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.discountCards,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.03),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  listFlag = 3;
                                });
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: listFlag == 3
                                        ? const Color.fromRGBO(
                                            242, 104, 130, 1.0)
                                        : Colors.black,
                                    width: 1.0,
                                    style: BorderStyle.solid)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.offers,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      listFlag == 1
                          ? allListWidget()
                          : listFlag == 2
                              ? offersListWidget()
                              : packagesListWidget(),
                    ],
                  ),
                ),
          FooterCustom(
            '2',
            openDrawerCustom: () {
              openDrawerCustom();
            },
          ),
        ],
      ),
    );
  }
}
