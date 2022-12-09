import 'package:flutter/material.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

class OrdersScreen extends StatefulWidget {
  OrdersScreen({Key? key}) : super(key: key);

  

  @override
  // ignore: no_logic_in_create_state
  State<OrdersScreen> createState() => _State(OrdersScreen);
}

class _State extends State<OrdersScreen> {
  _State(Type ordersScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var ordersList = [];
  var orderDetails = {};
  var yourOrderTxt = '';
  var itemsList = [];
  var payByTxt = '';

  var viewFlag = 1;

  var prevOrderDetails = {};
  var prevYourOrderTxt = '';
  var prevItemsList = [];
  var prevPayByTxt = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getOrders();
  }

  void getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetCustomerOrderMunchBakeryAPI/${prefs.getString('CustomerGuid')}',
        '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    ordersList = await networkHelper.getData();

    if (ordersList.isNotEmpty) {
      getOrderDetails();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getOrderDetails() async {

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetOrderDetailMunchBakeryAPI/${prefs.getString('CustomerGuid')}/${ordersList[0]['OrderId'].toString()}/${prefs.getString('langId')}',
        '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    orderDetails = await networkHelper.getData();
    if (orderDetails['OrderTypeId'].toString() == '15') {
      yourOrderTxt =
          '${AppLocalizations.of(context)!.yourOrderPickup} #${orderDetails['OrderIdShowCustomer'].toString()} is ';
    } else {
      yourOrderTxt =
          '${AppLocalizations.of(context)!.yourOrderDelivery} #${orderDetails['OrderIdShowCustomer'].toString()} is ';
    }
    itemsList = orderDetails['LstOrderProducts'];
    if (orderDetails['PaymentTypeId'].toString() == '1') {
      payByTxt = AppLocalizations.of(context)!.payByCash;
    } else if (orderDetails['PaymentTypeId'].toString() == '4') {
      payByTxt = AppLocalizations.of(context)!.payByCard;
    } else if (orderDetails['PaymentTypeId'].toString() == '5') {
      payByTxt = AppLocalizations.of(context)!.payByMunch;
    } else if (orderDetails['PaymentTypeId'].toString() == '6') {
      payByTxt = AppLocalizations.of(context)!.smsPaymentMethod;
    }
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

    Widget previousOrdersWidget() {
      return SizedBox(
        height: size.height * 0.93 - 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             SizedBox(
              height: size.height*0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: size.width*0.05, top: size.height*0.015),
                  child: GestureDetector(
                    onTap: () {
                        setState(() {
                          viewFlag = 1;
                        });

                    },
                    child: SizedBox(
                      width:  size.height*0.025,
                      child: Transform.rotate(
                        angle:Localizations.localeOf(context).languageCode=="ar"?math.pi: 0,
                        child: Image.asset(
                          "lib/assets/images/arrow1.png",
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.previousOrders,
                  style:  TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height*0.022,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width:  size.height*0.03,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Divider(color: Colors.grey),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.93 - 210,
              child: ListView.builder(
                itemCount: ordersList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext ctx, int index) => GestureDetector(
                  onTap: () async {
                    print('${ordersList[index]['OrderId'].toString()}');

                    setState(() {
                      isLoading = true;
                    });

                    final prefs = await SharedPreferences.getInstance();
                    NetworkHelper networkHelper = NetworkHelper(
                        '$kbaseUrl/$kgetOrderDetailMunchBakeryAPI/${prefs.getString('CustomerGuid')}/${ordersList[index]['OrderId'].toString()}/${prefs.getString('langId')}',
                        '');
                    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                    prevOrderDetails = await networkHelper.getData();
                    print('prevOrderDetails = ${prevOrderDetails}');
                    if (prevOrderDetails['OrderTypeId'].toString() ==
                        '15') {
                      prevYourOrderTxt =
                          '${AppLocalizations.of(context)!.yourOrderPickup} #${prevOrderDetails['OrderIdShowCustomer'].toString()} is ';
                    } else {
                      prevYourOrderTxt =
                          '${AppLocalizations.of(context)!.yourOrderDelivery} #${prevOrderDetails['OrderIdShowCustomer'].toString()} is ';
                    }
                    prevItemsList =
                        prevOrderDetails['LstOrderProducts'];
                    setState(() {
                      isLoading = false;
                      viewFlag = 3;
                    });
                  },
                  child: SizedBox(
                    height: 90,
                    width: MediaQuery.of(context).size.width - 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${AppLocalizations.of(context)!.order} (#${ordersList[index]['OrderIdShowCustomer'].toString()})',
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height*0.018,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        ordersList[index]
                                                ['DeliveryDate']
                                            .toString(),
                                        style: TextStyle(
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
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ordersList[index]
                                                        ['OrderStatusId']
                                                    .toString() ==
                                                '111'
                                            ? AppLocalizations.of(context)!
                                                .recieved
                                            : ordersList[index]
                                                            ['OrderStatusId']
                                                        .toString() ==
                                                    '200'
                                                ? AppLocalizations.of(context)!
                                                    .accepted
                                                : ordersList[index]['OrderStatusId']
                                                            .toString() ==
                                                        '40'
                                                    ? AppLocalizations.of(context)!
                                                        .cancelled
                                                    : ordersList[index]['OrderStatusId']
                                                                .toString() ==
                                                            '41'
                                                        ? AppLocalizations.of(context)!
                                                            .rejected
                                                        : ordersList[index]['OrderStatusId']
                                                                    .toString() ==
                                                                '380'
                                                            ? AppLocalizations.of(context)!
                                                                .ontheWay
                                                            : ordersList[index]['OrderStatusId'].toString() == '31'
                                                                ? AppLocalizations.of(context)!.readyforPickedUp
                                                                : '',
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height*0.018,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .viewItemsOrdered,
                                        style:  TextStyle(
                                          color: Color.fromRGBO(
                                              242, 104, 130, 1.0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height*0.018,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: Divider(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget prevOrderDetailsWidget() {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.93 - 120,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: size.width*0.05, top: size.height*0.015),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          viewFlag = 2;
                        });

                      },
                      child: SizedBox(
                        width:  size.height*0.025,
                        child: Transform.rotate(
                          angle:Localizations.localeOf(context).languageCode=="ar"?math.pi: 0,
                          child: Image.asset(
                            "lib/assets/images/arrow1.png",
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.order} (#${prevOrderDetails['OrderIdShowCustomer'].toString()})',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: size.width*0.03,)
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Divider(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 10),
                      child: Container(
                        width: size.height*0.05,
                        height: size.height*0.05,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(49, 157, 92, 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.thankYouVeryMunch,
                          style:  TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.018,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              prevYourOrderTxt,
                              style:  TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: size.height*0.015,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              AppLocalizations.of(context)!.recieved,
                              style:  TextStyle(
                                color: Color.fromRGBO(49, 157, 92, 1.0),
                                fontWeight: FontWeight.bold,
                                fontSize: size.height*0.015,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                child: Divider(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.orderDetails,
                      style:  TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height*0.018,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '#${prevOrderDetails['OrderIdShowCustomer'].toString()}',
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
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Divider(color: Colors.grey),
              ),
              ListView.builder(
                itemCount: prevItemsList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CachedNetworkImage(
                              imageUrl: prevItemsList[index]['Picture']
                                  ['PicturePath'],
                              //placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              height: size.height*0.06,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Text(
                                prevItemsList[index]['ProductName'],
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.018,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(width: size.width*0.03,),
                            Text(
                              '${prevItemsList[index]['TotalPrice']} (${AppLocalizations.of(context)!.sar})',
                              style:  TextStyle(
                                color: Color.fromRGBO(242, 104, 130, 1.0),
                                fontWeight: FontWeight.bold,
                                fontSize: size.height*0.015,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(width: size.width*0.03,),

                            Container(
                              height: size.height*0.035,
                              width: size.height*0.035,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Text(prevItemsList[index]
                                        ['Quantity']
                                    .toString(),style: TextStyle(fontSize: size.height*0.018),),
                              ),
                            ),
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  prevOrderDetails['PaymentTypeId'].toString() == '1'
                      ? AppLocalizations.of(context)!.payByCash
                      : prevOrderDetails['PaymentTypeId'].toString() ==
                              '4'
                          ? AppLocalizations.of(context)!.payByCard
                          : prevOrderDetails['PaymentTypeId']
                                      .toString() ==
                                  '5'
                              ? AppLocalizations.of(context)!.payByMunch
                              : prevOrderDetails['PaymentTypeId']
                                          .toString() ==
                                      '6'
                                  ? AppLocalizations.of(context)!
                                      .smsPaymentMethod
                                  : '',
                  style:  TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height*0.014,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.vat,
                style:  TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: size.height*0.013,
                ),
                textAlign: TextAlign.center,
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
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.subTotal,
                            style:  TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.018,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '${prevOrderDetails['OrderTotalExcludeTax'].toString()} ${AppLocalizations.of(context)!.sar}',
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
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.discount,
                            style:  TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.018,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '${prevOrderDetails['DiscountAmount'].toString()} ${AppLocalizations.of(context)!.sar}',
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
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.delFees,
                            style:  TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.018,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '${prevOrderDetails['DeliveryAmount'].toString()} ${AppLocalizations.of(context)!.sar}',
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
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.total,
                            style:  TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.018,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '${prevOrderDetails['OrderTotal'].toString()} ${AppLocalizations.of(context)!.sar}',
                            style:  TextStyle(
                              color: Color.fromRGBO(242, 104, 130, 1.0),
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.018,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: size.width*0.5,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            final prefs = await SharedPreferences.getInstance();
                            NetworkHelper networkHelper = NetworkHelper(
                                '$kbaseUrl/$kreOrderItemsMunchBakeryAPI/',
                                '{"CustomerGuid":"${prefs.getString('CustomerGuid')}","OrderId":"${prevOrderDetails['OrderId'].toString()}"}');
                            var response = await networkHelper.postData();
                            print(response);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          // ignore: prefer_const_constructors
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(242, 104, 130, 1.0)),
                          ),
                          child: Text(AppLocalizations.of(context)!.orderAgain,style: TextStyle(fontSize: size.height*0.018),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget orderDetailsWidget() {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.93 - 240,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 10),
                          child: Container(
                            width: size.height*0.05,
                            height: size.height*0.05,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(49, 157, 92, 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.thankYouVeryMunch,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: size.height*0.02,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: yourOrderTxt,
                                    style:  TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height*0.015,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        AppLocalizations.of(context)!.recieved,
                                    style:  TextStyle(
                                      color: Color.fromRGBO(49, 157, 92, 1.0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height*0.015,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       yourOrderTxt,
                            //       style: const TextStyle(
                            //         color: Colors.black,
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 13,
                            //       ),
                            //       textAlign: TextAlign.left,
                            //     ),
                            //     Text(
                            //       AppLocalizations.of(context)!.recieved,
                            //       style: const TextStyle(
                            //         color: Color.fromRGBO(49, 157, 92, 1.0),
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 13,
                            //       ),
                            //       textAlign: TextAlign.left,
                            //     ),
                            //   ],
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 20, bottom: 20),
                    child: Divider(color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.orderDetails,
                          style:  TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.018,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "#"+(orderDetails['OrderIdShowCustomer']??""),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: Divider(color: Colors.grey),
                  ),
                  ListView.builder(
                    itemCount: itemsList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) => SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: itemsList[index]['Picture']
                                      ['PicturePath'],
                                  //placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  height: size.height*0.06,
                                  fit: BoxFit.cover,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      itemsList[index]['ProductName'],
                                      style:  TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height*0.018
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width*0.03,),
                                Text(
                                  '${itemsList[index]['TotalPrice']} (${AppLocalizations.of(context)!.sar})',
                                  style:  TextStyle(
                                    color: Color.fromRGBO(242, 104, 130, 1.0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height*0.016
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(width: size.width*0.03,),

                                Container(
                                  height: size.height*0.035,
                                  width: size.height*0.035,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Center(
                                    child: Text(itemsList[index]
                                            ['Quantity']
                                        .toString(),style: TextStyle(fontSize: size.height*0.017),),
                                  ),
                                ),
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      payByTxt,
                      style:  TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height*0.014,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.vat,
                    style:  TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height*0.014,
                    ),
                    textAlign: TextAlign.center,
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
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.subTotal,
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.018,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${orderDetails['OrderTotalExcludeTax']??"0"} ${AppLocalizations.of(context)!.sar}',
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
                              left: 20, right: 20, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.discount,
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.018,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${orderDetails['DiscountAmount']??"0"} ${AppLocalizations.of(context)!.sar}',
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
                              left: 20, right: 20, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.delFees,
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.018,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${orderDetails['DeliveryAmount']??"0"} ${AppLocalizations.of(context)!.sar}',
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
                              left: 20, right: 20, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.total,
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.018,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${orderDetails['OrderTotal']??"0"} ${AppLocalizations.of(context)!.sar}',
                                style:  TextStyle(
                                  color: Color.fromRGBO(242, 104, 130, 1.0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.018,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            AppLocalizations.of(context)!.finalReceipt,
                            style:  TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.014,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 60,
                height: size.height*0.042,
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: ElevatedButton(
                  onPressed: () {},
                  // ignore: prefer_const_constructors
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(242, 104, 130, 1.0)),
                  ),
                  child: Text(AppLocalizations.of(context)!.chatWithUs,style: TextStyle(fontSize: size.height*0.018),),
                ),
              ),
              const Divider(color: Colors.grey),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    viewFlag = 2;
                  });
                }),
                child: SizedBox(
                  height: size.height*0.045,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.viewPreviousOrders,
                      style:  TextStyle(
                        color: Color.fromRGBO(242, 104, 130, 1.0),
                        fontWeight: FontWeight.bold,
                        fontSize: size.height*0.015,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.grey),
            ],
          ),
        ],
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
              : viewFlag == 1
                  ? orderDetailsWidget()
                  : viewFlag == 2
                      ? previousOrdersWidget()
                      : prevOrderDetailsWidget(),
          FooterCustom(
            '1',
            openDrawerCustom: () {
              openDrawerCustom();
            },
          ),
        ],
      ),
    );
  }
}
