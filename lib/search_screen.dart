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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  //const ItemsScreen({Key? key, required this.catId}) : super(key: key);
  // ignore: use_key_in_widget_constructors
  const SearchScreen();

  @override
  // ignore: no_logic_in_create_state
  State<SearchScreen> createState() => _State(SearchScreen);
}

class _State extends State<SearchScreen> {
  _State(Type categoriesScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var itemsList = [];

  @override
  void initState() {
    super.initState();
    print('here in items');

  }

  void getItems(String searchWord) async {
    setState(() {
      isLoading = true;
      itemsList = [];
    });
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kLiveBaseUrl/$ksearchProductsMunchBakeryAPI/',
        '{"langId":"${prefs.getString('langId')}","SearchKey":"${searchWord}"}');

    var response = await networkHelper.postData();
    print('itemsData = ${response["SearchProductsMunchBakeryResult"]}');

    setState(() {
      for (var i = 0; i < response["SearchProductsMunchBakeryResult"].length; i++) {
        String path;
        try {
          path = response["SearchProductsMunchBakeryResult"][i]['lstPictures'][0]['PicturePath'];
        } catch (e) {
          print(e);
          path = 'tttt';
        }


        itemsList.add(ItemObj(
          response["SearchProductsMunchBakeryResult"][i]['Id'].toString(),
          response["SearchProductsMunchBakeryResult"][i]['Name'],
          response["SearchProductsMunchBakeryResult"][i]['Price'].toString(),
          response["SearchProductsMunchBakeryResult"][i]['OldPrice'].toString(),
          path,
          response["SearchProductsMunchBakeryResult"][i]['IsGroupProduct'],
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
          const ScreenHeader('lib/assets/images/ic_search_test.png',inSearchScreen: true,),
          Container(
            margin: const EdgeInsets.only(
                left: 30, right: 30, top: 40, bottom: 20),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(30.0)),
            height: size.height*0.05,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 10),
                  width: 25,
                  child: Image.asset(
                    'lib/assets/images/ic_search_test.png',
                    color: const Color.fromRGBO(
                        242, 104, 130, 1.0),
                  ),
                ),
                Expanded(
                  child: TextField(
                    onSubmitted: (str){
                      getItems(str);
                    },
                      decoration: InputDecoration(
                        hintText:
                        AppLocalizations.of(context)!
                            .searchForProducts,
                        //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        border: InputBorder.none,
                      ),
                      keyboardType:
                      TextInputType.visiblePassword,
                      style:  TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height*0.018,
                      )),
                ),

              ],
            ),
          ),
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

        ],
      ),
    );
  }
}
