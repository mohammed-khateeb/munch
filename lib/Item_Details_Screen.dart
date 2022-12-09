import 'package:flutter/material.dart';
import 'Services/ShowMessage.dart';
import 'Widgets/AddToCart.dart';
import 'Widgets/Product_Item.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './models/ItemObj.dart';
import 'Services/Networking.dart';
import 'Services/constants.dart';
import 'Widgets/ItemDetailsSlider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemDetailsScreen extends StatefulWidget {
  //const ItemDetailsScreen({Key? key}) : super(key: key);


  final String itemId;
  // ignore: use_key_in_widget_constructors
  ItemDetailsScreen({required this.itemId});

  @override
  // ignore: no_logic_in_create_state
  State<ItemDetailsScreen> createState() => _State(ItemDetailsScreen);
}

class _State extends State<ItemDetailsScreen> {
  _State(Type ordersScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var imagesList = [];
  var itemsList = [];
  // ignore: prefer_typing_uninitialized_variables
  var itemObject;

  var isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getItemDetails();

  }

  void getItemDetails() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryProductDetailsAPI/${widget.itemId}/${prefs.getString('langId')}',
        '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    var response = await networkHelper.getData();
    itemObject = response;
    imagesList = response['lstPictures'];
    print('item details = $response');
    getRelated();
  }

  void getRelated() async {
    final prefs = await SharedPreferences.getInstance();
    var customerGuid = '-1';
    if (prefs.getString('CustomerGuid') != null) {
      customerGuid = prefs.getString('CustomerGuid')!;
    }
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryRelatedProductsAPI/',
        '{"langId":"${prefs.getString('langId')}","CityId":"-1","DistrictId":"-1","ZoneId":"-1","CustomerGuid":"$customerGuid","ProductId":"${widget.itemId}"}');
    var response = await networkHelper.postData();
    //widget.itemsList = response['GetMunchBakeryRelatedProductsResult'];
    for (var i = 0;
        i < response['GetMunchBakeryRelatedProductsResult'].length;
        i++) {
      String path;
      try {
        path = response['GetMunchBakeryRelatedProductsResult'][i]['lstPictures']
            [0]['PicturePath'];
      } catch (e) {
        print(e);
        path = 'tttt';
      }

      itemsList.add(ItemObj(
        response['GetMunchBakeryRelatedProductsResult'][i]['Id'].toString(),
        response['GetMunchBakeryRelatedProductsResult'][i]['Name'],
        response['GetMunchBakeryRelatedProductsResult'][i]['Price'].toString(),
        response['GetMunchBakeryRelatedProductsResult'][i]['OldPrice']
            .toString(),
        path,
        response['GetMunchBakeryRelatedProductsResult'][i]['IsGroupProduct'],
      ));
    }
    setState(() {
      isLoading = false;
    });
    //print('response = $response');
    print('itemsList = ${itemsList}');


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    openDrawerCustom() {
      _scaffoldKey.currentState!.openDrawer();
    }

    Widget normalItemPriceWidget() {
      //var arr = recommendedList[index]['Price'].split('.');
      return Text(
        '${itemObject['Price'].toString()} (${AppLocalizations.of(context)!.sar})',
        style: TextStyle(
          color: Color.fromRGBO(49, 157, 92, 1.0),
          fontWeight: FontWeight.bold,
          fontSize: size.height*0.02,
        ),
        textAlign: TextAlign.center,
      );
    }

    Widget discountItemPriceWidget() {
      // var arr = recommendedList[index]['Price'].split('.');
      // var arrOld = recommendedList[index]['OldPrice'].split('.');
      var saved = double.parse(itemObject['OldPrice'].toString()) -
          double.parse(itemObject['Price'].toString());
      //var arrSaved = saved.toString().split('.');
      return SizedBox(
        width: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${itemObject['OldPrice'].toString()} (${AppLocalizations.of(context)!.sar})',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height*0.015,
                      decoration: TextDecoration.lineThrough),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${itemObject['Price'].toString()} (${AppLocalizations.of(context)!.sar})',
                  style:  TextStyle(
                    color: Color.fromRGBO(49, 157, 92, 1.0),
                    fontWeight: FontWeight.bold,
                    fontSize: size.height*0.015,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                'Save ${saved.toString()} ${AppLocalizations.of(context)!.sar}',
                style:  TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: size.height*0.015,
                ),
                textAlign: TextAlign.center,
              ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemDetailsSlider(imagesList),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width*0.03),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    itemObject['Name'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height*0.02,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  showAddToCartCustomDialog(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  width: size.width*0.37,
                                  child: OutlinedButton(
                                    onPressed: null,
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.addToCart,
                                      style:  TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height*0.02,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(top: 10, start: size.width*0.03),
                          child: itemObject['Price'] ==
                                  itemObject['OldPrice']
                              ? normalItemPriceWidget()
                              : discountItemPriceWidget(),
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(top: 20, start: size.width*0.03),
                          child: Text(
                            itemObject['Description'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Divider(color: Colors.grey),
                        Container(
                          width: size.width*0.3,
                          height: size.height*0.05,
                          margin: const EdgeInsets.only(top: 10),
                          color: const Color.fromRGBO(242, 104, 130, 1.0),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.relatedItems,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: size.height*0.018,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: size.height*0.31,
                          child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                            ),
                            children: itemsList
                                .map((itemData) => ProductItem(
                                    itemData.id,
                                    itemData.name,
                                    itemData.price.toString(),
                                    itemData.oldPrice.toString(),
                                    itemData.picturePath,
                                    itemData.isGroupProduct,
                                    'normal'))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          FooterCustom(
            '0',
            openDrawerCustom: () {
              openDrawerCustom();
            },
          ),
        ],
      ),
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
          child: AddToCart(itemObject["Id"].toString(), itemObject["Price"].toString()),
        );
      },
    ).then((value) async {
      if(value!=null) {
        final prefs = await SharedPreferences.getInstance();
        if (prefs.getString('IsInStock') == 'true') {
          ShowMessage showMessage = ShowMessage(
              '', AppLocalizations.of(context)!.addedSuccessfully);
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
      }
    });
  }

}
