import 'package:flutter/material.dart';
import 'package:munch/Checkout_Screen.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Services/ShowMessage.dart';
import 'package:intl/intl.dart';
import './models/ItemObj.dart';
import 'Widgets/Product_Item.dart';
import '../MunchCake_Screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<CartScreen> createState() => _State(CartScreen);
}

class _State extends State<CartScreen> {
  _State(Type ordersScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isLoading = false;
  var cartList = [];
  var itemsList = [];
  var selectedItem = -1;
  var total = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getCart();
    getRelated();
  }

  Future getCart() async {
    final prefs = await SharedPreferences.getInstance();

    var now = DateTime.now();
    var formatter = DateFormat('MM/dd/yyyy');
    String formattedDate = formatter.format(now);

    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetShoppingCartItemsByCustomerStoreMunchBakeryAPI/',
        '{"langId":"${prefs.getString('langId')}","CustomerGuid":"${prefs.getString('CustomerGuid')}","OrderDate":"$formattedDate","CityId":"-1","DistrictId":"-1","ZoneId":"-1","StoreId":"-1","OrderType":"-1"}');
    var response = await networkHelper.postData();
    setState(() {
      cartList =
          response['GetShoppingCartItemsByCustomerStoreMunchBakeryResult'];
      total = 0.0;
      for (var i = 0; i < cartList.length; i++) {
        total += cartList[i]['Price'] * cartList[i]['Quantity'];
      }
      isLoading = false;
    });
  }

  void getRelated() async {
    final prefs = await SharedPreferences.getInstance();
    var customerGuid = '-1';
    if (prefs.getString('CustomerGuid') != null) {
      customerGuid = prefs.getString('CustomerGuid')!;
    }
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryRelatedProductsAPI/',
        '{"langId":"${prefs.getString('langId')}","CityId":"-1","DistrictId":"-1","ZoneId":"-1","CustomerGuid":"$customerGuid","ProductId":"-1"}');
    var response = await networkHelper.postData();
    //widget.itemsList = response['GetMunchBakeryRelatedProductsResult'];

    //print('response = $response');

    setState(() {
      isLoading = false;
      for (var i = 0;
          i < response['GetMunchBakeryRelatedProductsResult'].length;
          i++) {
        String path;
        try {
          path = response['GetMunchBakeryRelatedProductsResult'][i]
              ['lstPictures'][0]['PicturePath'];
        } catch (e) {
          print(e);
          path = 'tttt';
        }

        itemsList.add(ItemObj(
          response['GetMunchBakeryRelatedProductsResult'][i]['Id'].toString(),
          response['GetMunchBakeryRelatedProductsResult'][i]['Name'],
          response['GetMunchBakeryRelatedProductsResult'][i]['Price']
              .toString(),
          response['GetMunchBakeryRelatedProductsResult'][i]['OldPrice']
              .toString(),
          path,
          response['GetMunchBakeryRelatedProductsResult'][i]['IsGroupProduct'],
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    openDrawerCustom() {
      _scaffoldKey.currentState!.openDrawer();
    }

    void deletePressed() async {
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
          '{"CustomerId":"-1","CustomerGuid":"$customerGuid","StoreId":"1","Price":"${cartList[selectedItem]['Price'].toString()}","Quantity":"${cartList[selectedItem]['Quantity'].toString()}","ProductId":"${cartList[selectedItem]['ProductId'].toString()}","MarkAsDeleted":"1","ShoppingCartId":"${cartList[selectedItem]['ShoppingCartId'].toString()}","OrderDate":"$formattedDate","CityId":"-1","DistrictId":"-1","ZoneId":"-1"}');
      var response = await networkHelper.postData();
      print(response);

      await getCart();
      setState(() {
        isLoading = false;
      });
    }

    void plusPressed() async {
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
          '{"CustomerId":"-1","CustomerGuid":"$customerGuid","StoreId":"-1","Price":"${cartList[selectedItem]['Price'].toString()}","Quantity":"1","ProductId":"${cartList[selectedItem]['ProductId'].toString()}","MarkAsDeleted":"0","ShoppingCartId":"-1","OrderDate":"$formattedDate","CityId":"-1","DistrictId":"-1","ZoneId":"-1"}');
      var response = await networkHelper.postData();
      print(response);


      await getCart();
      setState(() {
        isLoading = false;
      });
      //getRelated();
    }

    void minusPressed() async {
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
          '{"CustomerId":"-1","CustomerGuid":"$customerGuid","StoreId":"-1","Price":"${cartList[selectedItem]['Price'].toString()}","Quantity":"-1","ProductId":"${cartList[selectedItem]['ProductId'].toString()}","MarkAsDeleted":"0","ShoppingCartId":"-1","OrderDate":"$formattedDate","CityId":"-1","DistrictId":"-1","ZoneId":"-1"}');
      var response = await networkHelper.postData();
      print(response);

      await getCart();
      setState(() {
        isLoading = false;
      });
    }

    Widget cartWidget() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.yourCart,
                  style:  TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height*0.018,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  AppLocalizations.of(context)!.price,
                  style:  TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: size.height*0.018,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  AppLocalizations.of(context)!.quantity,
                  style:  TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: size.height*0.018,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 5),
            child: Divider(color: Colors.grey),
          ),
          ListView.builder(
            itemCount: cartList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => Container(
              color: index == 0 ? Colors.white : Colors.white,
              width: MediaQuery.of(context).size.width - 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: CachedNetworkImage(
                            imageUrl: cartList[index]['Picture']['PicturePath'],
                            //placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            height: size.height*0.06,
                            width: size.height*0.06,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: size.width*0.35,
                                    child: Text(
                                      cartList[index]['ProductName'],
                                      style:  TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height*0.018,
                                      ),
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.white,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    cartList[index]['IsGiftCardApplied']
                                                .toString() ==
                                            'false'
                                        ? TextButton(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .delete,
                                              style:  TextStyle(
                                                color: Color.fromRGBO(
                                                    242, 104, 130, 1.0),
                                                fontWeight: FontWeight.normal,
                                                fontSize: size.height*0.014,
                                              ),
                                            ),
                                            onPressed: () {
                                              selectedItem = index;
                                              deletePressed();
                                            },
                                          )
                                        : const SizedBox(
                                            width: 0,
                                          ),
                                    cartList[index]['IsMunchCakeProduct']
                                                .toString() ==
                                            'true'
                                        ? TextButton(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .edit,
                                              style:  TextStyle(
                                                color: Color.fromRGBO(
                                                    242, 104, 130, 1.0),
                                                fontWeight: FontWeight.normal,
                                                fontSize: size.height*0.014,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute<
                                                      MunchCakeScreen>(
                                                builder:
                                                    (BuildContext context) {
                                                  return MunchCakeScreen(
                                                    productId: cartList[index]
                                                            ['ProductId']
                                                        .toString(),
                                                  );
                                                },
                                              ));
                                            },
                                          )
                                        : const SizedBox(),
                                    Text(
                                      cartList[index]['IsGiftCardApplied']
                                                  .toString() ==
                                              '0'
                                          ? AppLocalizations.of(context)!.free
                                          : '${cartList[index]['Price'].toString()} (${AppLocalizations.of(context)!.sar})',
                                      style:  TextStyle(
                                        color:
                                            Color.fromRGBO(242, 104, 130, 1.0),
                                        fontWeight: FontWeight.normal,
                                        fontSize: size.height*0.0135,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            cartList[index]['IsGiftCardApplied'].toString() ==
                                        'false' &&
                                    cartList[index]['IsMunchCakeProduct']
                                            .toString() ==
                                        'false'
                                ? Container(
                              padding: EdgeInsets.symmetric(vertical: size.height*0.007),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (cartList[index]['Quantity'] >
                                                1) {
                                              selectedItem = index;
                                              minusPressed();
                                            }
                                          },
                                          icon: const Icon(Icons.remove),
                                          iconSize: size.height*0.022,
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 12),
                                          constraints: const BoxConstraints(),
                                        ),
                                        Text(
                                          cartList[index]['Quantity']
                                              .toString(),
                                          style:  TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: size.height*0.02,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            selectedItem = index;
                                            plusPressed();
                                          },
                                          icon: const Icon(Icons.add),
                                          iconSize: size.height*0.022,
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 12),
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Divider(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget recommendedItemsWidget() {
      return Container(
        margin: const EdgeInsets.only(left: 0, right: 0),
        child: GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1.5 / 2.01,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
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
              : Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.93 - 120,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            cartList.isNotEmpty
                                ? cartWidget()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, bottom: 20),
                                    child: Text(
                                      AppLocalizations.of(context)!.noCart,
                                      style:  TextStyle(
                                        fontSize:  size.height*0.02,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .customersWhoBought,
                                style:  TextStyle(
                                  fontSize: size.height*0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            recommendedItemsWidget(),
                            SizedBox(height: size.height*0.2,)
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: size.height*0.15,
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(
                              bottom: 5,
                              left: 30,
                              right: 30),
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
                                color: Colors.grey.withOpacity(0.5),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.subTotal} (${cartList.length} ${AppLocalizations.of(context)!.items}):',
                                      style:  TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height*0.02,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      ' $total ${AppLocalizations.of(context)!.sar}',
                                      style:  TextStyle(
                                        color: Color.fromRGBO(242, 104, 130, 1.0),
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
                                    left: 20, right: 20, top: 20),
                                child: SizedBox(
                                  width: size.width*0.6,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (cartList.isNotEmpty) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute<CheckoutScreen>(
                                          builder: (BuildContext context) {
                                            return CheckoutScreen(
                                              total: total,
                                            );
                                          },
                                        ));
                                      } else {
                                        ShowMessage showMessage = ShowMessage("",
                                            AppLocalizations.of(context)!.noCart);
                                        showMessage.showAlertDialog(context);
                                      }
                                    },
                                    // ignore: prefer_const_constructors
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<
                                              Color>(
                                          const Color.fromRGBO(242, 104, 130, 1.0)),
                                    ),
                                    child: Text(AppLocalizations.of(context)!
                                        .proceedToCheckout,style: TextStyle(fontSize: size.height*0.018),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
