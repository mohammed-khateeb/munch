import 'package:flutter/material.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Widgets/AddToCart.dart';
import '../Services/ShowMessage.dart';
import 'MunchCake_Screen.dart';

class GroupedItemScreen extends StatefulWidget {
  //const GroupedItemScreen({Key? key}) : super(key: key);

  final String itemId;
  final String source;
  // ignore: use_key_in_widget_constructors
  GroupedItemScreen({required this.itemId, required this.source});

  @override
  // ignore: no_logic_in_create_state
  State<GroupedItemScreen> createState() => _State(GroupedItemScreen);
}

class _State extends State<GroupedItemScreen> {
  _State(Type ordersScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isLoading = false;
  var productsList = [];
  var selectedProduct = 0;
  var selectedProductImagePath = '';
  var description = '';
  @override
  void initState() {
    super.initState();
    print(widget.source);
    setState(() {
      isLoading = true;
      if (widget.source == 'ecommerce') {
        getEcommerceProducts();
      } else {
        getOccasionProducts();
      }
    });
  }

  void getEcommerceProducts() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryProductsByProductGroupIdAPI/${widget.itemId}/${prefs.getString('langId')}/-1/-1/-1/-1',
        '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    productsList = await networkHelper.getData();
    print('productsList = $productsList');
    try {
      selectedProductImagePath =
          productsList[0]['lstPictures'][0]['PicturePath'];
    } catch (e) {
      selectedProductImagePath = '';
    }

    try {
      description = productsList[0]['Description'];
    } catch (e) {
      description = '';
    }
    setState(() {
      isLoading = false;
    });
  }

  void getOccasionProducts() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchCakeProductsByProductGroupIdAPI/',
        '{"langId":"${prefs.getString('langId')}","ProductGroupId":"${widget.itemId}","CityId":"-1","DistrictId":"-1","ZoneId":"-1"}');
    var response = await networkHelper.postData();
    productsList = response['GetMunchCakeProductsByProductGroupIdResult'];
    print('productsList = $productsList');
    try {
      selectedProductImagePath =
          productsList[0]['lstPictures'][0]['PicturePath'];
    } catch (e) {
      selectedProductImagePath = '';
    }
    try {
      description = productsList[0]['Description'];
    } catch (e) {
      description = '';
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    openDrawerCustom() {
      _scaffoldKey.currentState!.openDrawer();
    }

    Widget normalItemPriceWidget() {
      var arr = productsList[selectedProduct]['Price'].toString().split('.');
      return Text(
        '${arr[0].toString()} (${AppLocalizations.of(context)!.sar})',
        style: const TextStyle(
          color: Color.fromRGBO(49, 157, 92, 1.0),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      );
    }

    Widget discountItemPriceWidget() {
      var arr = productsList[selectedProduct]['Price'].toString().split('.');
      var arrOld =
          productsList[selectedProduct]['OldPrice'].toString().split('.');
      var saved = double.parse(productsList[selectedProduct]['OldPrice']) -
          double.parse(productsList[selectedProduct]['Price']);
      var arrSaved = saved.toString().split('.');
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${arrOld[0].toString()} (${AppLocalizations.of(context)!.sar})',
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough),
                textAlign: TextAlign.center,
              ),
              Text(
                '${arr[0].toString()} (${AppLocalizations.of(context)!.sar})',
                style: const TextStyle(
                  color: Color.fromRGBO(49, 157, 92, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              'Save ${arrSaved[0].toString()} ${AppLocalizations.of(context)!.sar}',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    void showAddToCartCustomDialog(BuildContext context) async {
      await showGeneralDialog(
        context: context,
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) {
          return Center(
            child: AddToCart(productsList[selectedProduct]['Id'].toString(),
                productsList[selectedProduct]['Price'].toString()),
          );
        },
      ).then((value) async {
        final prefs = await SharedPreferences.getInstance();
        if (prefs.getString('IsInStock') == 'true') {
          ShowMessage showMessage =
              ShowMessage('', AppLocalizations.of(context)!.addedSuccessfully);
          showMessage.showAlertDialog(context);
        } else if (prefs.getString('IsInStock') == 'false') {
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
      });
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: selectedProductImagePath,
                              //placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              width: 200,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Divider(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            productsList[selectedProduct]['Name'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        productsList[selectedProduct]['Price'] ==
                                productsList[selectedProduct]['OldPrice']
                            ? normalItemPriceWidget()
                            : discountItemPriceWidget(),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 40, right: 40, top: 20),
                          child: Divider(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            AppLocalizations.of(context)!.pickSize,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SizedBox(
                            height: 60,
                            child: ListView.builder(
                              itemCount: productsList.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) =>
                                  Container(
                                height: 60,
                                width: 85,
                                color: Colors.white,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(3),
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedProduct = index;
                                      try {
                                        selectedProductImagePath =
                                            productsList[selectedProduct]
                                                    ['lstPictures'][0]
                                                ['PicturePath'];
                                      } catch (e) {
                                        selectedProductImagePath = '';
                                      }
                                      try {
                                        description =
                                            productsList[selectedProduct]
                                                ['Description'];
                                      } catch (e) {
                                        description = '';
                                      }
                                    });
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(BorderSide(
                                        color: index == selectedProduct
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
                                    productsList[index]['AttributeValue'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            description,
                            style: const TextStyle(
                              color: Color.fromRGBO(242, 104, 130, 1.0),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 40, right: 40, bottom: 20),
                          child: Divider(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 160,
                          child: OutlinedButton(
                            onPressed: () {
                              if (widget.source == 'ecommerce') {
                                showAddToCartCustomDialog(context);
                              } else {
                                Navigator.of(context)
                                    .push(MaterialPageRoute<MunchCakeScreen>(
                                  builder: (BuildContext context) {
                                    return MunchCakeScreen(
                                      productId: productsList[selectedProduct]
                                              ['Id']
                                          .toString(),
                                    );
                                  },
                                ));
                              }
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                  style: BorderStyle.solid)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.addToCart,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
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
