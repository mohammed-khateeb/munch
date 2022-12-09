import 'package:flutter/material.dart';
import '../Items_Screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  CategoryItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<ItemsScreen>(
          builder: (BuildContext context) {
            return ItemsScreen(
              catId: id,
            );
          },
        ));
      },
      child: Container(
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          // Image.network(
          //   imageUrl,
          //   width: 120,
          //   height: 120,
          //   fit: BoxFit.cover,
          // ),
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(
              color: Colors.transparent,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: size.height*0.018,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute<ItemsScreen>(
                  builder: (BuildContext context) {
                    return ItemsScreen(
                      catId: id,
                    );
                  },
                ));
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
              ),
              child: Text(
                AppLocalizations.of(context)!.buyNow,
                style:  TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: size.height*0.018,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
