import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Widgets/Screen_Header.dart';
import './models/ItemObj.dart';
import 'Widgets/Product_Item.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import 'Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsScreen extends StatefulWidget {
  //const ItemsScreen({Key? key, required this.catId}) : super(key: key);


  final String catId;
  // ignore: use_key_in_widget_constructors
  ItemsScreen({required this.catId});

  @override
  // ignore: no_logic_in_create_state
  State<ItemsScreen> createState() => _State(ItemsScreen);
}

class _State extends State<ItemsScreen> {
  _State(Type categoriesScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var itemsList = [];

  @override
  void initState() {
    super.initState();
    print('here in items');
    setState(() {
      isLoading = true;
    });
    getItems();
  }

  void getItems() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('langId'));
    print(widget.catId);
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryProductsAPI/${prefs.getString('langId')}/${widget.catId}/-1/-1/-1',
        '');
    List itemsData = await networkHelper.getData();
    print('itemsData = $itemsData');

    setState(() {
      for (var i = 0; i < itemsData.length; i++) {
        String path;
        try {
          path = itemsData[i]['lstPictures'][0]['PicturePath'];
        } catch (e) {
          print(e);
          path = 'tttt';
        }

        itemsList.add(ItemObj(
          itemsData[i]['Id'].toString(),
          itemsData[i]['Name'],
          itemsData[i]['Price'].toString(),
          itemsData[i]['OldPrice'].toString(),
          path,
          itemsData[i]['IsGroupProduct'],
        ));
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ScreenHeader('lib/assets/images/ic_search_test.png'),
          Expanded(
            child: isLoading
                ? Center(
                    child: Image.asset(
                      "lib/assets/images/MunchLoadingTransparent.gif",
                      height: 100.0,
                      width: 100.0,
                    ),
                  )
                : GridView(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
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
                        .toList()),
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
}
