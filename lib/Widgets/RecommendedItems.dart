import 'package:flutter/material.dart';
import 'package:munch/Item_Details_Screen.dart';
import 'package:munch/Items_Screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/ShowMessage.dart';
import 'AddToCart.dart';

class RecommendedItems extends StatelessWidget {
  var recommendedList = [];

  RecommendedItems(this.recommendedList);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget normalItemPriceWidget(int index) {
      //var arr = recommendedList[index]['Price'].split('.');
      return Text(
        '${recommendedList[index]['Price'].toString()} (${AppLocalizations.of(context)!.sar})',
        style:  TextStyle(
          color: Color.fromRGBO(49, 157, 92, 1.0),
          fontWeight: FontWeight.bold,
          fontSize: size.height*0.02,
        ),
        textAlign: TextAlign.center,
      );
    }

    Widget groupedItemPriceWidget(int index) {
      //var arr = recommendedList[index]['Price'].split('.');
      return Text(
        'Starting from\n${recommendedList[index]['Price'].toString()} (${AppLocalizations.of(context)!.sar})',
        style:  TextStyle(
          color: Color.fromRGBO(49, 157, 92, 1.0),
          fontWeight: FontWeight.bold,
          fontSize: size.height*0.017,
        ),
        textAlign: TextAlign.center,
      );
    }

    Widget discountItemPriceWidget(int index) {
      // var arr = recommendedList[index]['Price'].split('.');
      // var arrOld = recommendedList[index]['OldPrice'].split('.');
      var saved = double.parse(recommendedList[index]['OldPrice'].toString()) -
          double.parse(recommendedList[index]['Price'].toString());
      //var arrSaved = saved.toString().split('.');
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${recommendedList[index]['OldPrice'].toString()} (${AppLocalizations.of(context)!.sar})',
                style:  TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height*0.014,
                    decoration: TextDecoration.lineThrough),
                textAlign: TextAlign.center,
              ),
              Text(
                '${recommendedList[index]['Price'].toString()} (${AppLocalizations.of(context)!.sar})',
                style:  TextStyle(
                  color: Color.fromRGBO(49, 157, 92, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: size.height*0.014,
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
                fontSize: size.height*0.014,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    bool getIsGroupedProduct(int index) {
      return recommendedList[index]['IsGroupProduct'];
    }

    bool getIsCategory(int index) {
      return recommendedList[index]['IsCategory'];
    }

    return SizedBox(
      height: size.height*0.27,
      child: ListView.builder(
        itemCount: recommendedList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            if (getIsCategory(index)) {
              Navigator.of(context).push(MaterialPageRoute<ItemsScreen>(
                builder: (BuildContext context) {
                  return ItemsScreen(
                    catId: recommendedList[index]['Id'].toString(),
                  );
                },
              ));
            } else {
              Navigator.of(context).push(MaterialPageRoute<ItemDetailsScreen>(
                builder: (BuildContext context) {
                  return ItemDetailsScreen(
                    itemId: recommendedList[index]['Id'].toString(),
                  );
                },
              ));
            }
          },
          child: getIsCategory(index)
              ? Container(
                  height: size.height*0.27,
                  width: size.width*0.32,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedNetworkImage(
                          imageUrl: recommendedList[index]['lstPictures'][0]
                              ['PicturePath'],
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(
                            color: Colors.transparent,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            recommendedList[index]['Name'],
                            style:  TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.016,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute<ItemsScreen>(
                              builder: (BuildContext context) {
                                return ItemsScreen(
                                  catId: recommendedList[index]['Id'].toString(),
                                );
                              },
                            ));
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0))),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.buyNow,
                            style:  TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.016,
                            ),
                          ),
                        ),
                      ]),
                )
              : Container(
                  height: size.height*0.27,
                  width: size.width*0.32,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImage(
                        imageUrl: recommendedList[index]['lstPictures'][0]
                            ['PicturePath'],
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(
                          color: Colors.transparent,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          recommendedList[index]['Name'],
                          style:  TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.016,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (getIsGroupedProduct(index))
                        groupedItemPriceWidget(index)
                      else
                        recommendedList[index]['Price'] ==
                                recommendedList[index]['OldPrice']
                            ? normalItemPriceWidget(index)
                            : discountItemPriceWidget(index),
                      OutlinedButton(
                        onPressed: (){
                          showAddToCartCustomDialog(context, index);
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.addToCart,
                          style:  TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.016,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void showAddToCartCustomDialog(BuildContext context,int index) async {
    await showGeneralDialog(
      context: context,
      barrierLabel: "",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: AddToCart(recommendedList[index]["Id"].toString(), recommendedList[index]["Price"].toString()),
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
