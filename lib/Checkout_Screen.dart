
import 'package:flutter/material.dart';
import 'package:munch/addresses_screen.dart';
import 'Orders_Screen.dart';
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
import '../main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:math' as math;

class CheckoutScreen extends StatefulWidget {
  //const CheckoutScreen({Key? key}) : super(key: key);

  final double total;
  // ignore: use_key_in_widget_constructors
  const CheckoutScreen({required this.total});

  @override
  // ignore: no_logic_in_create_state
  State<CheckoutScreen> createState() => _State(CheckoutScreen);
}

class _State extends State<CheckoutScreen> {
  _State(Type ordersScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isLoading = false;
  var citiesList = [];
  var zoneId = '-1';
  var storesList = [];
  var addressesList = [];
  var munchSelected = -1;
  var paymentFaildApiStr = '';
  bool isMunchCakeOrder = false;
  var enablePrintPhoto = '1';
  var addressSelected = -1;
  var orderTypeId = '25';
  var dateForTimeSlotStr = '';
  var dateForPickerStr = '';
  var vatAmount = '';
  double totalWithoutDiscount = 0;
  double totalWithDiscount = 0;
  var totalAPI = '';
  var totalPayfortAPI = '';
  var subTotalAPI = '';
  var discountAmountAPI = '';
  var couponStr = '';
  var couponApplied = 0;
  var deliveryFeesStr = '';
  var paymentMethodsList = [];
  var paymentMethod = '';
  var paymentTypeId = '7';
  var paymentSelected = -1;
  var cartList = [];
  var addPhotoFlag = 0;
  var shoppingCartId = '';
  var photoUrl = '';
  var fileName = '';
  var proceedFlag = 1;
  var timeSlotsList = [];
  var deliverySelected = 1;
  var pickupSelected = 0;
  var carDeliveredSelected = 0;
  var termsAgreedSelected = 1;
  var seeAllFlag = 0;
  var selectedItem = -1;
  var citySelected = -1;
  var cityId = '-1';
  var citiesStoresFlag = 1;
  var selectedSlot = 0;
  DateTime selectedDate = DateTime.now();
  var toCheckLat = '';
  var toCheckLong = '';
  var addressSaveSelected = 0;

  final _carDescriptionText = TextEditingController();
  final _orderNotesText = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getCities();
  }

  void getCities() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryCitiesAPI/${prefs.getString('langId')}', '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    citiesList = await networkHelper.getData();
    print(citiesList);
    setState(() {
      //isLoading = false;
      updateZone();
    });
  }

  void updateZone() async {
    final prefs = await SharedPreferences.getInstance();

    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/checkPointExistsInGeofencePolygonByCustomer/',
        '{"CustomerId":"${prefs.getString('CustomerId')}","Lng":"-1","Lat":"-1"}');
    var response = await networkHelper.postData();
    if (response['checkPointExistsInGeofencePolygonByCustomerResult']
            .toString() ==
        '0') {
      zoneId = '-1';
    } else {
      zoneId = response['checkPointExistsInGeofencePolygonByCustomerResult']
          .toString();
    }
    print(zoneId);
    setState(() {
      getStores();
    });
  }

  void getStores() async {
    var now = DateTime.now();
    var formatter = DateFormat('MM/dd/yyyy');
    String formattedDate = formatter.format(now);

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryStoresPickupCheckoutAPI/',
        '{"langId":"${prefs.getString('langId')}","CustomerGuid":"${prefs.getString('CustomerGuid')}","OrderDate":"$formattedDate","CityId":"-1","DistrictId":"-1","ZoneId":"$zoneId"}');
    var response = await networkHelper.postData();
    storesList = response['GetMunchBakeryStoresPickupCheckoutResult'];
    print(storesList);
    setState(() {
      getAddresses();
    });
  }

  void getStoresForCity() async {
    var now = DateTime.now();
    var formatter = DateFormat('MM/dd/yyyy');
    String formattedDate = formatter.format(now);

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryStoresPickupCheckoutAPI/',
        '{"langId":"${prefs.getString('langId')}","CustomerGuid":"${prefs.getString('CustomerGuid')}","OrderDate":"$formattedDate","CityId":"$cityId","DistrictId":"-1","ZoneId":"-1"}');
    var response = await networkHelper.postData();
    storesList = response['GetMunchBakeryStoresPickupCheckoutResult'];
    print(storesList);
    setState(() {});
  }

  void getAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetCustomerAddressesAPI/',
        '{"CustomerGuid":"${prefs.getString('CustomerGuid')}"}');
    var response = await networkHelper.postData();
    print('response addressesList = $response');
    addressesList = response['GetCustomerAddressesResult'];
    print('addressesList = $addressesList');
    setState(() {
      getInfo();
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
        if (tmp[i]['Name'] == 'FailedPayment') {
          paymentFaildApiStr = tmp[i]['Description'];
        }
      }
    }
    print(paymentFaildApiStr);
    setState(() {
      checkIsMunchcake();
    });
  }

  void checkIsMunchcake() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kisMunchCakeOrderAPI/',
        '{"CustomerId":"${prefs.getString('CustomerId')}"}');
    var response = await networkHelper.postData();
    isMunchCakeOrder = response['IsMunchCakeOrderResult'];

    print(isMunchCakeOrder);
    setState(() {
      getFirstAvailableDate();
    });
  }

  void getFirstAvailableDate() async {
    var storeId = '';
    if (munchSelected == -1) {
      storeId = '-1';
    } else {
      storeId = storesList[munchSelected]['StoreId'].toString();
    }
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetFirstAvailableDateCheckoutAPI/',
        '{"CustomerId":"${prefs.getString('CustomerId')}","CityId":"-1","DistrictId":"-1","ZoneId":"$zoneId","StoreId":"$storeId","OrderType":"$orderTypeId"}');
    var response = await networkHelper.postData();
    if (response['GetFirstAvailableDateCheckoutResult']['SuccessResponse'] ==
        null) {
      Navigator.of(context).push(MaterialPageRoute<MyHomePage>(
        builder: (BuildContext context) {
          return MyHomePage(
            title: '',
          );
        },
      ));
    } else {
      dateForTimeSlotStr =
          response['GetFirstAvailableDateCheckoutResult']['SuccessResponse'];
      dateForPickerStr =
          response['GetFirstAvailableDateCheckoutResult']['SuccessResponse'];
    }
    //print(dateForTimeSlotStr);
    setState(() {
      getCart();
    });
  }

  void getCart() async {
    double vat = widget.total * 0.05;
    vatAmount = vat.toString();

    var storeId = '';
    if (munchSelected == -1) {
      storeId = '-1';
    } else {
      storeId = storesList[munchSelected]['StoreId'].toString();
    }
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetShoppingCartSummaryAPI/',
        '{"langId":"${prefs.getString('langId')}","CustomerGuid":"${prefs.getString('CustomerGuid')}","CustomerId":"${prefs.getString('CustomerId')}","CityId":"-1","DistrictId":"-1","ZoneId":"$zoneId","StoreId":"$storeId","OrderType":"$orderTypeId","OrderDate":"$dateForTimeSlotStr"}');
    var response = await networkHelper.postData();
    print(response);
    totalWithoutDiscount = 0;
    totalAPI =
        response['GetShoppingCartSummaryResult']['OrderTotal'].toString();
    totalPayfortAPI =
        (response['GetShoppingCartSummaryResult']['OrderTotal'] * 100)
            .toString();
    totalPayfortAPI = totalPayfortAPI.trim().toString();
    subTotalAPI =
        response['GetShoppingCartSummaryResult']['SubOrderTotal'].toString();
    discountAmountAPI =
        response['GetShoppingCartSummaryResult']['DiscountAmount'].toString();
    couponStr =
        response['GetShoppingCartSummaryResult']['CouponCode'].toString();
    if (couponStr == '') {
      couponApplied = 0;
    } else {
      couponApplied = 1;
    }
    deliveryFeesStr =
        response['GetShoppingCartSummaryResult']['DeliveryFees'].toString();
    List paymentMethodsListTmp =
        response['GetShoppingCartSummaryResult']['LstECommercePaymentType'];
    paymentMethodsList = [];
    for (var i = 0; i < paymentMethodsListTmp.length; i++) {
      if (paymentMethodsListTmp[i]['Id'].toString() != '7') {
        if (paymentMethodsListTmp[i]['EnableMobile'] == true) {
          paymentMethodsList.add(paymentMethodsListTmp[i]);
        }
      }
    }
    for (var i = 0; i < paymentMethodsList.length; i++) {
      if (paymentMethodsList[i]['Id'].toString() == '6') {
        paymentMethod = 'sms';
        paymentTypeId = '6';
        paymentSelected = i;
      }
    }

    cartList = response['GetShoppingCartSummaryResult']
        ['LstECommerceShoppingCartItem'];
    for (var i = 0; i < cartList.length; i++) {
      if (cartList[i]['ProductId'].toString() == '1562') {
        addPhotoFlag = 1;
        shoppingCartId = cartList[i]['ShoppingCartId'].toString();
        photoUrl = prefs.getString('photoUrl')!;
        fileName = prefs.getString('fileName')!;
      }
    }
    setState(() {
      getSlots();
    });
    if (cartList.isNotEmpty) {
      proceedFlag = 1;
      for (var i = 0; i < cartList.length; i++) {
        if (cartList[i]['InStock'].toString() == '1') {
          proceedFlag = 0;
          if (orderTypeId == '25') {
            ShowMessage showMessage = ShowMessage(
                '', AppLocalizations.of(context)!.notAllAvailableDelivery);
            showMessage.showAlertDialog(context);
          } else {
            ShowMessage showMessage =
                ShowMessage('', AppLocalizations.of(context)!.notAllAvailable);
            showMessage.showAlertDialog(context);
          }
          return;
        }
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute<MyHomePage>(
        builder: (BuildContext context) {
          return MyHomePage(
            title: '',
          );
        },
      ));
    }
    print(cartList);
  }

  void getSlots() async {
    var storeId = '';
    if (munchSelected == -1) {
      storeId = '-1';
    } else {
      storeId = storesList[munchSelected]['StoreId'].toString();
    }

    var addressId = '';
    if (addressSelected == -1) {
      addressId = '';
    } else {
      addressId = addressesList[addressSelected]['AddressId'].toString();
    }

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetTimeSlotsMunchBakeryAPI/',
        '{"CustomerId":"${prefs.getString('CustomerId')}","CityId":"-1","DistrictId":"-1","ZoneId":"$zoneId","StoreId":"$storeId","OrderType":"$orderTypeId","OrderDate":"$dateForTimeSlotStr","LocationSelected":"$addressId"}');
    var response = await networkHelper.postData();

    setState(() {
      isLoading = false;
      timeSlotsList = response['GetTimeSlotsMunchBakeryNewResult'];
      print('slottts $response');
    });
  }



  void placeOrderPressed() async {
    if (termsAgreedSelected == 0) {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.warning,
          AppLocalizations.of(context)!.termsAgreedRequired);
      showMessage.showAlertDialog(context);
      return;
    }
    String DeliveryAmount,
        AddressId,
        AddressName,
        IsSaveAddressForLater = '',
        Longitude = '',
        Latitude = '',
        DeliveryLocationDescription,
        storeId,
        CustomerMobileNumber,
        CustomerPinCard,
        TimeSlotsValue;

    if (deliverySelected == 0 && pickupSelected == 0) {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.warning,
          AppLocalizations.of(context)!.choosePickupMethod);
      showMessage.showAlertDialog(context);
      return;
    }

    if (deliverySelected == 0) {
      if (munchSelected == -1) {
        ShowMessage showMessage = ShowMessage(
            AppLocalizations.of(context)!.warning,
            AppLocalizations.of(context)!.choosePickupMethod);
        showMessage.showAlertDialog(context);
        return;
      }

      DeliveryAmount = '0';
      orderTypeId = '15';
      AddressId = '';
      AddressName = '';
      DeliveryLocationDescription = '';
      IsSaveAddressForLater = '';
      Longitude = '';
      Latitude = '';
      storeId = storesList[munchSelected]['StoreId'].toString();
    } else {
      DeliveryAmount = '0';
      orderTypeId = '25';
      if (addressSelected == -1) {
        ShowMessage showMessage = ShowMessage(
            AppLocalizations.of(context)!.warning,
            AppLocalizations.of(context)!.chooseAddress);
        showMessage.showAlertDialog(context);
        return;
      }
      AddressId = addressesList[addressSelected]['AddressId'].toString();
      AddressName = addressesList[addressSelected]['AddressName'];
      DeliveryLocationDescription =
          addressesList[addressSelected]['LocationDescription'];
      IsSaveAddressForLater = addressSaveSelected.toString();
      if (zoneId == '-1') {
        Longitude = '';
        Latitude = '';
      } else {
        Longitude = addressesList[addressSelected]['Longitude'].toString();
        Latitude = addressesList[addressSelected]['Latitude'].toString();
      }
      storeId = '-1';
    }

    String lstInStockProductIds = '[';
    for (int i = 0; i < cartList.length; i++) {
      lstInStockProductIds =
          '$lstInStockProductIds${cartList[i]['ProductId'].toString()},'; //[NSString stringWithFormat:@"%@%@,",LstInStockProductIds,[NSString stringWithFormat:@"%@",[[cartArray objectAtIndex:i]objectForKey:@"ProductId"]]];
    }
    if (cartList.isNotEmpty) {
      lstInStockProductIds =
          lstInStockProductIds.substring(0, lstInStockProductIds.length - 1);
    }
    lstInStockProductIds = '$lstInStockProductIds]';

    final prefs = await SharedPreferences.getInstance();
    CustomerMobileNumber = prefs.getString('MobileNumber')!;
    CustomerPinCard = prefs.getString('CardPin')!;

    if (proceedFlag == 0) {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.warning,
          AppLocalizations.of(context)!.notAllAvailableDelivery);
      showMessage.showAlertDialog(context);
      return;
    }

    if (timeSlotsList.isEmpty) {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.warning,
          AppLocalizations.of(context)!.chooseTime);
      showMessage.showAlertDialog(context);
      return;
    }

    TimeSlotsValue =
        '${timeSlotsList[selectedSlot]['FromTime']} to ${timeSlotsList[selectedSlot]['ToTime']}';

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    String notes = _orderNotesText.text;
    String carDescription = _carDescriptionText.text;

    // if (deliverySelected==1) {
    //         if (Latitude =='' || Longitude =='') {
    //             //[self addCoordinatesBtn];
    //             return;
    //         }
    //     }

    setState(() {
      isLoading = true;
    });

    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kcreateOrderMunchBakeryAPI/',
        '{"CustomerId":"${prefs.getString('CustomerId')}","StateId":"-1","DistrictId":"-1","StockZoneId":"$zoneId","StoreId":"$storeId","OrderTypeId":"$orderTypeId","CustomerGuid":"${prefs.getString('CustomerGuid')}","OrderTotalExcludeTax":"$subTotalAPI","OrderTotal":"$totalAPI","VatAmount":"$vatAmount","DeliveryAmount":"$deliveryFeesStr","DiscountAmount":"$discountAmountAPI","PaymentTypeId":"$paymentTypeId","DeliveryDate":"$dateForTimeSlotStr","DeliveryTime":"${timeSlotsList[selectedSlot]['FromTime']}","CreditCardTransNumber":"","LanguageId":"${prefs.getString('langId')}","CustomerIP":"-1","LstInStockProductIds":$lstInStockProductIds,"AddressId":"$AddressId","AddressName":"$AddressName","Longitude":"$Longitude","Latitude":"$Latitude","DeliveryLocationDescription":"$DeliveryLocationDescription","IsSaveAddressForLater":"$IsSaveAddressForLater","LoyalityPoints":"0","LoyalityAmount":"0","CustomerMobileNumber":"$CustomerMobileNumber","CustomerPinCard":"","OrderSourceTypeId":"2","TimeSlotsValue":"$TimeSlotsValue","OrderDescription":"$notes","Remarks":"$version","PhotoUrl":"$photoUrl","IsCurbsidePickup":"${carDeliveredSelected.toString()}","CurbSideNotes":"$carDescription"}');

    var response = await networkHelper.postData();
    print('response $response');
    if (response['Status'] == 'SUCCESS') {
      setState(() {
        isLoading = false;
      });
      await prefs.setString('cartCount', '0');

      var now = DateTime.now();
      var formatter = DateFormat('MM/dd/yyyy');
      String formattedDate = formatter.format(now);

      await prefs.setString('DateToOrder', formattedDate);
      await prefs.setString('showRatePopup', '1');

      Navigator.of(context).push(MaterialPageRoute<OrdersScreen>(
        builder: (BuildContext context) {
          return OrdersScreen();
        },
      ));
    } else {
      setState(() {
        isLoading = false;
      });

      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.errorLabel,
          response['ErrorResponse']['ErrorMessage']);
      showMessage.showAlertDialog(context);
      return;
    }
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

    setState(() {
      isLoading = false;
      getCart();
    });
  }

  Widget timeSlotsWidget() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: timeSlotsList.length,
        itemBuilder: (_, index) {
          return Container(
              margin: EdgeInsets.only(left: index == 0 ? 10 : 0, top: 20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedSlot = index;
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedSlot == index
                              ? const Color.fromRGBO(242, 104, 130, 1.0)
                              : Colors.black),
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        '${timeSlotsList[index]['FromTime']} - ${timeSlotsList[index]['ToTime']}',
                        style: TextStyle(
                          color: selectedSlot == index
                              ? const Color.fromRGBO(242, 104, 130, 1.0)
                              : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var formatter = DateFormat('MM/dd/yyyy');
        dateForTimeSlotStr = formatter.format(selectedDate);
        dateForPickerStr = formatter.format(selectedDate);

        getSlots();
      });
    }
  }

  void _modalBottomSheetMenuPaymentMethods() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return Container(
            height: 350.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    scrollDirection: Axis.vertical,
                    itemCount: paymentMethodsList.length,
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (paymentMethodsList[index]['Id'].toString() ==
                                '1') {
                              paymentMethod = 'cod';
                              paymentTypeId = '1';
                            } else if (paymentMethodsList[index]['Id']
                                    .toString() ==
                                '4') {
                              paymentMethod = 'online';
                              paymentTypeId = '4';
                            } else if (paymentMethodsList[index]['Id']
                                    .toString() ==
                                '6') {
                              paymentMethod = 'sms';
                              paymentTypeId = '6';
                            }
                            paymentSelected = index;
                          });

                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          height: 60,
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  paymentMethodsList[index]['Id'].toString() ==
                                          '1'
                                      ? AppLocalizations.of(context)!
                                          .cashOnDelivery
                                      : paymentMethodsList[index]['Id']
                                                  .toString() ==
                                              '4'
                                          ? AppLocalizations.of(context)!
                                              .onlinePayment
                                          : paymentMethodsList[index]['Id']
                                                      .toString() ==
                                                  '7'
                                              ? 'Apple Pay'
                                              : paymentMethodsList[index]['Id']
                                                          .toString() ==
                                                      '6'
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .smsPaymentMethod
                                                  : '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      height: 60,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _modalBottomSheetMenuAddresses(Size size) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return Container(
            height: size.height*0.3,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    scrollDirection: Axis.vertical,
                    itemCount: addressesList.length,
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            addressSelected = index;
                            toCheckLat =
                                addressesList[index]['Latitude'].toString();
                            toCheckLong =
                                addressesList[index]['Longitude'].toString();
                          });

                          Navigator.pop(context);
                          addressCheckZone();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          height: size.height*0.065,
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  addressesList[index]['AddressName'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute<AddressesScreen>(
                        builder: (BuildContext context) {
                          return AddressesScreen();
                        },
                      ));
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      height: size.height*0.065,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              AppLocalizations.of(context)!.addNewAddress,
                              style:  TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: size.height*0.018,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      height: size.height*0.065,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style:  TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: size.height*0.018,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void addressCheckZone() async {
    final prefs = await SharedPreferences.getInstance();

    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kcheckPointExistsInGeofencePolygonForCheckoutAPI/',
        '{"CustomerId":"${prefs.getString('CustomerId')}","Lng":"$toCheckLong","Lat":"$toCheckLat"}');
    var response = await networkHelper.postData();
    if (response['CheckPointExistsInGeofencePolygonForCheckoutByCustomerResult']
            .toString() ==
        '0') {
      zoneId = '-1';
    } else {
      zoneId = response[
              'CheckPointExistsInGeofencePolygonForCheckoutByCustomerResult']
          .toString();
    }
    print(zoneId);
    setState(() {
      getSlots();
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    Widget deliveryWidget() {
      return Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 20, top: 10),
              child: Text(
                AppLocalizations.of(context)!.chooseAddress,
                style:  TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: size.height*0.018,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            InkWell(
              onTap: () {
                _modalBottomSheetMenuAddresses(size);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                height: size.height*0.05,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  border:
                  Border.all(color: const Color.fromRGBO(242, 104, 130, 1.0)),
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        addressSelected == -1
                            ? AppLocalizations.of(context)!.choose
                            : addressesList[addressSelected]['AddressName'],
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: size.height*0.018,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      width: size.height*0.025,
                      child: Image.asset(
                        'lib/assets/images/dropDownArrow.png',
                        color: const Color.fromRGBO(242, 104, 130, 1.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget chooseCityWidget() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              AppLocalizations.of(context)!.chooseCity,
              style:  TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.height*0.018,
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            height: size.height*0.15,
            child: ListView.builder(
              itemCount: citiesList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) => Container(
                color: Colors.white,
                height: 40,
                width: MediaQuery.of(context).size.width - 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        citySelected = index;
                        cityId = citiesList[index]['Id'].toString();
                        citiesStoresFlag = 2;
                        getStoresForCity();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              citiesList[index]['Name'],
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.normal,
                                fontSize: size.height*0.015,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          index == citySelected
                              ?  Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              Icons.check,
                              size: size.height*0.025,
                              color: Color.fromRGBO(242, 104, 130, 1.0),
                            ),
                          )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget chooseStoreWidget() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: size.width*0.05, top: size.height*0.015),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      citiesStoresFlag = 1;
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AppLocalizations.of(context)!.chooseStore,
                  style:  TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height*0.018,
                  ),
                ),
              ),
              SizedBox(width: size.width*0.035,)
            ],
          ),
          Container(
            color: Colors.transparent,
            height: size.height*0.15,
            child: ListView.builder(
              itemCount: storesList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width - 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        munchSelected = index;
                        setState(() {
                          getFirstAvailableDate();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              storesList[index]['Name'],
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.normal,
                                fontSize: size.height*0.015,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          index == munchSelected
                              ?  Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              Icons.check,
                              size: size.height*0.025,

                              color: Color.fromRGBO(242, 104, 130, 1.0),
                            ),
                          )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget pickupWidget() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          child: Column(
            children: [
              Container(
                height: size.height*0.222,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: citiesStoresFlag == 1
                    ? chooseCityWidget()
                    : chooseStoreWidget(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        vertical: 5
                      ),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            if (carDeliveredSelected == 0) {
                              carDeliveredSelected = 1;
                            } else {
                              carDeliveredSelected = 0;
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              carDeliveredSelected==1?Icons.radio_button_checked:Icons.radio_button_off,
                              size: size.height*0.02,
                              color: Color.fromRGBO(242, 104, 130, 1.0),
                            ),
                            SizedBox(width: size.width*0.02,),
                            Text(
                              AppLocalizations.of(context)!.carDelivered,
                              style:  TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: size.height*0.014,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: size.height*0.045,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 15),
                        child: TextField(
                            controller: _carDescriptionText,
                            decoration: InputDecoration(
                              hintText:
                              AppLocalizations.of(context)!.carDescription,
                              //   labelText:
                              //       AppLocalizations.of(context)!.carDescription,
                              //   //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.text,
                            style:  TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.016,
                            )),
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

    Widget choosePaymentWidget() {
      return Container(
        height: size.height*0.13,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 20, top: 10),
              child: Text(
                AppLocalizations.of(context)!.choosePaymentMethod,
                style:  TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: size.height*0.018,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            InkWell(
              onTap: () => _modalBottomSheetMenuPaymentMethods(),
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                height: size.height*0.05,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  border:
                  Border.all(color: const Color.fromRGBO(242, 104, 130, 1.0)),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        paymentSelected == -1
                            ? AppLocalizations.of(context)!.choose
                            : paymentMethod == 'cod'
                            ? AppLocalizations.of(context)!.cashOnDelivery
                            : paymentMethod == 'online'
                            ? AppLocalizations.of(context)!.onlinePayment
                            : paymentMethod == 'sms'
                            ? AppLocalizations.of(context)!
                            .smsPaymentMethod
                            : '',
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: size.height*0.018,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      width: size.width*0.05,
                      child: Image.asset(
                        'lib/assets/images/dropDownArrow.png',
                        color: const Color.fromRGBO(242, 104, 130, 1.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget paymentDetailsWidget() {
      return Container(
        margin: const EdgeInsets.only(left: 30, top: 30, right: 30, bottom: 50),
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
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.paymentDetails,
                    style:  TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height*0.018,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '$subTotalAPI ${AppLocalizations.of(context)!.sar}',
                    style:  TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height*0.018,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '$discountAmountAPI ${AppLocalizations.of(context)!.sar}',
                    style:  TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height*0.018,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '$deliveryFeesStr ${AppLocalizations.of(context)!.sar}',
                    style:  TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height*0.018,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '$totalAPI ${AppLocalizations.of(context)!.sar}',
                    style:  TextStyle(
                      color: Color.fromRGBO(242, 104, 130, 1.0),
                      fontWeight: FontWeight.bold,
                      fontSize: size.height*0.018,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20
              ),
              child: InkWell(
                onTap: (){
                  setState(() {
                    if (termsAgreedSelected == 0) {
                      termsAgreedSelected = 1;
                    } else {
                      termsAgreedSelected = 0;
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      termsAgreedSelected==1?Icons.radio_button_checked:Icons.radio_button_off,
                      size: size.height*0.02,
                      color: Color.fromRGBO(242, 104, 130, 1.0),
                    ),
                    SizedBox(width: size.width*0.02,),
                    Text(
                      AppLocalizations.of(context)!.termsAgreed,
                      style:  TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: size.height*0.014,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: size.width*0.65,
                child: ElevatedButton(
                  onPressed: () {
                    placeOrderPressed();
                  },
                  // ignore: prefer_const_constructors
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(242, 104, 130, 1.0)),
                  ),
                  child: Text(AppLocalizations.of(context)!.placeOrder,style: TextStyle(fontSize: size.height*0.016),),
                ),
              ),
            ),
          ],
        ),
      );
    }
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
      body: SingleChildScrollView(
        child: Column(
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
                : seeAllFlag == 0
                    ? SizedBox(
                        height: size.height * 0.93 - 120,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    TextButton(
                                      child: Text(
                                        '${AppLocalizations.of(context)!.seeAll} (${cartList.length} ${AppLocalizations.of(context)!.items})',
                                        style:  TextStyle(
                                          color:
                                              Color.fromRGBO(242, 104, 130, 1.0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height*0.018,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          seeAllFlag = 1;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Color.fromRGBO(230, 235, 239, 1.0),
                                thickness: 2.0,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 20, top: 20),
                                child: Text(
                                  AppLocalizations.of(context)!.howPick,
                                  style:  TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height*0.018,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.only(end: 10),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              deliverySelected = 1;
                                              pickupSelected = 0;
                                              orderTypeId = '25';
                                              munchSelected = -1;
                                            });
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: deliverySelected == 1
                                                ? const Color.fromRGBO(
                                                    242, 104, 130, 1.0)
                                                : Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .delivery,
                                            style: TextStyle(
                                              color: deliverySelected == 1
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: size.height*0.018,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.only(start: 10),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              deliverySelected = 0;
                                              pickupSelected = 1;
                                              orderTypeId = '15';
                                              addressSelected = -1;
                                            });
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: pickupSelected == 1
                                                ? const Color.fromRGBO(
                                                    242, 104, 130, 1.0)
                                                : Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .storePickup,
                                            style: TextStyle(
                                              color: pickupSelected == 1
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: size.height*0.018,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              deliverySelected == 1
                                  ? deliveryWidget()
                                  : pickupWidget(),
                              const Divider(
                                color: Color.fromRGBO(230, 235, 239, 1.0),
                                thickness: 2.0,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 20, top: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.timeSlots,
                                  style:  TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height*0.018,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              InkWell(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  height: size.height*0.05,
                                  width: size.width - 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            242, 104, 130, 1.0)),
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          dateForTimeSlotStr,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.height*0.018,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              timeSlotsList.isNotEmpty
                                  ? timeSlotsWidget()
                                  : const SizedBox(),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Divider(
                                  color: Color.fromRGBO(230, 235, 239, 1.0),
                                  thickness: 2.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.couponCode,
                                      style:  TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height*0.018,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          '0% OFF',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(width: 7),
                                         SizedBox(
                                          height: size.height*0.045,
                                          child: VerticalDivider(
                                            color: Color.fromRGBO(
                                                230, 235, 239, 1.0),
                                            thickness: 2.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width*0.2,
                                          child: TextButton(
                                            child: Text(
                                              AppLocalizations.of(context)!.add,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            onPressed: () {},
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Color.fromRGBO(230, 235, 239, 1.0),
                                thickness: 2.0,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .addPhotoOnCake,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height*0.018,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          '',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(width: 7),
                                         SizedBox(
                                          height: size.height*0.04,
                                          child: VerticalDivider(
                                            color: Color.fromRGBO(
                                                230, 235, 239, 1.0),
                                            thickness: 2.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width*0.2,
                                          child: TextButton(
                                            child: Text(
                                              AppLocalizations.of(context)!.add,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            onPressed: () {},
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 10, bottom: 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 60,
                                  height: size.height*0.135,
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
                                                controller: _orderNotesText,
                                                decoration: InputDecoration(
                                                  hintText: AppLocalizations.of(
                                                          context)!
                                                      .orderNotes,
                                                  //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                                  border: InputBorder.none,
                                                ),
                                                keyboardType:
                                                    TextInputType.multiline,
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
                              const Divider(
                                color: Color.fromRGBO(230, 235, 239, 1.0),
                                thickness: 2.0,
                              ),
                              choosePaymentWidget(),
                              paymentDetailsWidget(),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.93 - 120,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.orderDetails,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height*0.02,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    TextButton(
                                      child: Text(
                                        AppLocalizations.of(context)!.closeThis,
                                        style:  TextStyle(
                                          color:
                                              Color.fromRGBO(242, 104, 130, 1.0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height*0.018,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          seeAllFlag = 0;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Color.fromRGBO(230, 235, 239, 1.0),
                                thickness: 2.0,
                              ),
                              ListView.builder(
                                itemCount: cartList.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) =>
                                    Container(
                                  color: index == 0 ? Colors.white : Colors.white,
                                  height: 85,
                                  width: MediaQuery.of(context).size.width - 60,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, right: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(0.0),
                                              child: CachedNetworkImage(
                                                imageUrl: cartList[index]
                                                    ['Picture']['PicturePath'],
                                                //placeholder: (context, url) => const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 145,
                                                        child: Text(
                                                          cartList[index]
                                                              ['ProductName'],
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
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
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        cartList[index]['IsGiftCardApplied']
                                                                    .toString() ==
                                                                'false'
                                                            ? TextButton(
                                                                child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .delete,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            242,
                                                                            104,
                                                                            130,
                                                                            1.0),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: 12,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  selectedItem =
                                                                      index;
                                                                  deletePressed();
                                                                },
                                                              )
                                                            : const SizedBox(
                                                                width: 0,
                                                              ),
                                                        Text(
                                                          cartList[index]['IsGiftCardApplied']
                                                                      .toString() ==
                                                                  '0'
                                                              ? AppLocalizations
                                                                      .of(context)!
                                                                  .free
                                                              : '${cartList[index]['Price'].toString()} (${AppLocalizations.of(context)!.sar})',
                                                          style: const TextStyle(
                                                            color: Color.fromRGBO(
                                                                242,
                                                                104,
                                                                130,
                                                                1.0),
                                                            fontWeight:
                                                                FontWeight.normal,
                                                            fontSize: 12,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
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
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15)),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 15),
                                                    child: Center(
                                                      child: Text(
                                                        cartList[index]
                                                                ['Quantity']
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 30, right: 30),
                                        child: Divider(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            if(!isLoading)
            FooterCustom(
              '-1',
              openDrawerCustom: () {
                openDrawerCustom();
              },
            ),
          ],
        ),
      ),
    );
  }
}
