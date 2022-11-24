import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Item_Details_Screen.dart';
import '../Items_Screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../CustomCakeHome_Screen.dart';
import '../MunchCake_Screen.dart';
import '../GroupedItem_Screen.dart';

class MainSlider extends StatelessWidget {
  var sliderList = [];

  MainSlider(
    this.sliderList,
  );

  @override
  Widget build(BuildContext context) {
    print('sliderList length ${sliderList.length}');
    return SizedBox(
      height: 130,
      child: ListView.builder(
        itemCount: sliderList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => Container(
          height: 130,
          width: 370,
          margin: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: GestureDetector(
              onTap: () {
                if (sliderList[index]['EntityType'] == 1) {
                  Navigator.of(context)
                      .push(MaterialPageRoute<ItemDetailsScreen>(
                    builder: (BuildContext context) {
                      return ItemDetailsScreen(
                        itemId: sliderList[index]['EntityId'].toString(),
                      );
                    },
                  ));
                } else if (sliderList[index]['EntityType'] == 2) {
                  Navigator.of(context)
                      .push(MaterialPageRoute<ItemsScreen>(
                    builder: (BuildContext context) {
                      return ItemsScreen(
                        catId: sliderList[index]['EntityId'].toString(),
                      );
                    },
                  ));
                } else if (sliderList[index]['EntityType'] == 3) {
                  var url = sliderList[index]['LinkUrl'];
                  //if (canLaunch(url)) {
                  launch(url);
                  // } else {
                  //   // can't launch url
                  // }
                } else if (sliderList[index]['EntityType'] == 4) {
                  Navigator.of(context)
                      .push(MaterialPageRoute<CustomCakeHomeScreen>(
                    builder: (BuildContext context) {
                      return const CustomCakeHomeScreen();
                    },
                  ));
                } else if (sliderList[index]['EntityType'] == 5) {
                  Navigator.of(context).push(MaterialPageRoute<MunchCakeScreen>(
                    builder: (BuildContext context) {
                      return MunchCakeScreen(
                        productId: '-1',
                      );
                    },
                  ));
                } else if (sliderList[index]['EntityType'] == 6) {
                  Navigator.of(context)
                      .push(MaterialPageRoute<GroupedItemScreen>(
                    builder: (BuildContext context) {
                      return GroupedItemScreen(
                        itemId: '-1',
                        source: 'ecommerce',
                      );
                    },
                  ));
                } else if (sliderList[index]['EntityType'] == 7) {
                  Navigator.of(context)
                      .push(MaterialPageRoute<GroupedItemScreen>(
                    builder: (BuildContext context) {
                      return GroupedItemScreen(
                        itemId: '-1',
                        source: 'occasion',
                      );
                    },
                  ));
                }
              },
              child: CachedNetworkImage(
                imageUrl: sliderList[index]['picture']['PicturePath'],
                //placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
