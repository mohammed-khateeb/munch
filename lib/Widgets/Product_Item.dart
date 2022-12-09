import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:munch/Item_Details_Screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:munch/MunchCake_Screen.dart';
import 'package:munch/GroupedItem_Screen.dart';
import 'AddToCart.dart';
import '../Services/ShowMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String oldPrice;
  final String picturePath;
  final bool isGroupProduct;
  final String source;

  ProductItem(
    this.id,
    this.name,
    this.price,
    this.oldPrice,
    this.picturePath,
    this.isGroupProduct,
    this.source,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget normalItemPriceWidget() {
      var arr = price.split('.');
      return Text(
        '${arr[0].toString()} (${AppLocalizations.of(context)!.sar})',
        style: TextStyle(
          color: Color.fromRGBO(49, 157, 92, 1.0),
          fontWeight: FontWeight.bold,
          fontSize: size.height*0.018,
        ),
        textAlign: TextAlign.center,
      );
    }

    Widget groupedItemPriceWidget() {
      var arr = price.split('.');
      return Text(
        'Starting from\n${arr[0].toString()} (${AppLocalizations.of(context)!.sar})',
        style:  TextStyle(
          color: Color.fromRGBO(49, 157, 92, 1.0),
          fontWeight: FontWeight.bold,
          fontSize: size.height*0.018,
        ),
        textAlign: TextAlign.center,
      );
    }

    Widget discountItemPriceWidget() {
      var arr = price.split('.');
      var arrOld = oldPrice.split('.');
      var saved = double.parse(oldPrice) - double.parse(price);
      var arrSaved = saved.toString().split('.');
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${arrOld[0].toString()} (${AppLocalizations.of(context)!.sar})',
                style:  TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height*0.015,
                    decoration: TextDecoration.lineThrough),
                textAlign: TextAlign.center,
              ),
              Text(
                '${arr[0].toString()} (${AppLocalizations.of(context)!.sar})',
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
            child: AddToCart(id, price),
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

    return GestureDetector(
      onTap: () {
        if (source == 'normal') {
          if (isGroupProduct) {
            Navigator.of(context).push(MaterialPageRoute<GroupedItemScreen>(
              builder: (BuildContext context) {
                return GroupedItemScreen(
                  itemId: id,
                  source: 'ecommerce',
                );
              },
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute<ItemDetailsScreen>(
              builder: (BuildContext context) {
                return ItemDetailsScreen(
                  itemId: id,
                );
              },
            ));
          }
        } else {
          if (isGroupProduct) {
            Navigator.of(context).push(MaterialPageRoute<GroupedItemScreen>(
              builder: (BuildContext context) {
                return GroupedItemScreen(
                  itemId: id,
                  source: 'occasion',
                );
              },
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute<MunchCakeScreen>(
              builder: (BuildContext context) {
                return MunchCakeScreen(
                  productId: id,
                );
              },
            ));
          }
        }
      },
      child: Container(
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: picturePath,
                //placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: size.height*0.15,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height*0.018,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              isGroupProduct
                  ? groupedItemPriceWidget()
                  : price == oldPrice
                      ? normalItemPriceWidget()
                      : discountItemPriceWidget(),

              OutlinedButton(
                onPressed: () {
                  if (isGroupProduct) {
                  } else {
                    if (source == 'normal') {
                      showAddToCartCustomDialog(context);
                    }
                    else{
                      showAddToCartCustomDialog(context);
                    }
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
                ),
                child: Text(
                  isGroupProduct
                      ? AppLocalizations.of(context)!.chooseSize
                      : AppLocalizations.of(context)!.addToCart,
                  style:  TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height*0.018,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
