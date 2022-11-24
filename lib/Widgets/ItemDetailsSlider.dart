import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:munch/FullImages_Screen.dart';

class ItemDetailsSlider extends StatelessWidget {
  var itemSliderList = [];

  ItemDetailsSlider(
    this.itemSliderList,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height*0.18,
      child: ListView.builder(
        itemCount: itemSliderList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => Container(
          width: size.width,
          margin: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: GestureDetector(
              onTap: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute<SimplePhotoViewPage>(
                //   builder: (BuildContext context) {
                //     return SimplePhotoViewPage(
                //         itemSliderList[index]['PicturePath']);
                //   },
                // ));
              },
              child: CachedNetworkImage(
                imageUrl: itemSliderList[index]['PicturePath'],
                //placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
