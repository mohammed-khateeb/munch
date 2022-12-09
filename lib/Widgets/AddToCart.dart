import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Services/ShowMessage.dart';
import '../Services/Networking.dart';
import '../Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AddToCart extends StatefulWidget {
  //const AddToCart({ Key? key }) : super(key: key);

  final String productId;
  final String price;

  AddToCart(
    this.productId,
    this.price,
  );

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  @override
  var counterArray = [];
  var selectedCount = '1';
  var isLoading = false;
  @override
  void initState() {
    super.initState();
    for (var i = 1; i < 100; i++) {
      counterArray.add(i.toString());
    }
  }

  addToCartBtn() async {
    print('$selectedCount ${widget.price} ${widget.productId}');

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
        '{"CustomerId":"-1","CustomerGuid":"$customerGuid","StoreId":"-1","Price":"${widget.price}","Quantity":"$selectedCount","ProductId":"${widget.productId}","MarkAsDeleted":"0","ShoppingCartId":"-1","OrderDate":"$formattedDate","CityId":"-1","DistrictId":"-1","ZoneId":"-1"}');
    var response = await networkHelper.postData();
    print(response);

    setState(() {
      isLoading = false;
    });
    print(response['IsInStock']);
    await prefs.setString('IsInStock', response['IsInStock'].toString());
    Navigator.pop(context,true);

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: SizedBox(
        height: 300,

        width: MediaQuery.of(context).size.width * 0.80,
        child: isLoading
            ? Center(
                child: Image.asset(
                  "lib/assets/images/MunchLoadingTransparent.gif",
                  height: 100.0,
                  width: 100.0,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      AppLocalizations.of(context)!.howMany,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 32,
                      onSelectedItemChanged: (int index) {
                        setState(
                          () {
                            selectedCount = counterArray[index];
                          },
                        );
                      },
                      children: List<Widget>.generate(
                        counterArray.length,
                        (int index) {
                          return Center(
                            child: Text(counterArray[index]),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        onPressed: addToCartBtn,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
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
                  ),
                ],
              ),
      ),
    );
  }
}
