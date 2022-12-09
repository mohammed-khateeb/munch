import 'package:flutter/material.dart';
import 'package:munch/search_screen.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Services/Networking.dart';
import 'Services/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Widgets/OccasionOff.dart';
import 'MunchCake_Screen.dart';
import 'Widgets/Product_Item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCakeHomeScreen extends StatefulWidget {
  const CustomCakeHomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<CustomCakeHomeScreen> createState() => _State(CustomCakeHomeScreen);
}

class _State extends State<CustomCakeHomeScreen> {
  _State(Type ordersScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isLoading = false;
  var occasionOff = '';
  var occasionOffFlag = false;
  var itemsList = [];
  var customImageStr = '';

  void getItems() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchCakeProductsHomePageAPI/',
        '{"langId":"${prefs.getString('langId')}","CityId":"-1","DistrictId":"-1","ZoneId":"-1","SearchKey":""}');
    var response = await networkHelper.postData();
    print(response);
    for (var i = 0;
        i < response['GetMunchCakeProductsHomePageResult'].length;
        i++) {
      if (response['GetMunchCakeProductsHomePageResult'][i]
              ['IsCustomizeCake'] ==
          false) {
        itemsList.add(response['GetMunchCakeProductsHomePageResult'][i]);
      } else {
        try {
          customImageStr = response['GetMunchCakeProductsHomePageResult'][i]
              ['lstPictures'][0]['PicturePath'];
        } catch (e) {
          customImageStr = '';
        }
      }
    }
    //itemsList = response['GetMunchCakeProductsHomePageResult'];
    setState(() {
      isLoading = false;
    });
  }

  void getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetInfoTextMunchCakeAPI/',
        '{"langId":"${prefs.getString('langId')}"}');
    var response = await networkHelper.postData();
    List resList = response['GetInfoTextMunchCakeResult'];
    for (var i = 0; i < resList.length; i++) {
      //print(resList[i]['Name']);
      if (resList[i]['Name'] == 'OccasionOff') {
        occasionOff = resList[i]['Description'];
      }
    }
    //print(occasionOff);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      getItems();
      getInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    openDrawerCustom() {
      _scaffoldKey.currentState!.openDrawer();
    }
    Size size = MediaQuery.of(context).size;


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
          ScreenHeader('lib/assets/images/arrow1.png'),
          isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.93 - 120,
                  child: Image.asset(
                    "lib/assets/images/MunchLoadingTransparent.gif",
                    height: 100.0,
                    width: 100.0,
                  ),
                )
              : occasionOffFlag
                  ? OccasionOff(occasionOff)
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.93 - 120,
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
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
                                    onTap: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute<
                                              SearchScreen>(
                                            builder:
                                                (BuildContext context) {
                                              return const SearchScreen();
                                            },
                                          ));
                                    },
                                      readOnly: true,
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
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.93 - 220,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0,
                                ),
                                itemCount: itemsList.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  print(index);
                                  if (index == 0) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute<MunchCakeScreen>(
                                          builder: (BuildContext context) {
                                            return MunchCakeScreen(
                                              productId: '-1',
                                            );
                                          },
                                        ));
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: CachedNetworkImage(
                                                imageUrl: customImageStr,
                                                //placeholder: (context, url) => const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                height: size.height*0.15,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .makeOwnCake,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.height*0.018,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            OutlinedButton(
                                              onPressed: null,
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0))),
                                              ),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .startMaking,
                                                style:  TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.height*0.017,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    String path;
                                    try {
                                      path = itemsList[index - 1]['lstPictures']
                                          [0]['PicturePath'];
                                    } catch (e) {
                                      print(e);
                                      path = 'tttt';
                                    }
                                    return ProductItem(
                                        itemsList[index - 1]['Id'].toString(),
                                        itemsList[index - 1]['Name'],
                                        itemsList[index - 1]['Price']
                                            .toString(),
                                        itemsList[index - 1]['OldPrice']
                                            .toString(),
                                        path,
                                        itemsList[index - 1]['IsGroupProduct'],
                                        'custom');
                                  }
                                }),
                          )
                        ],
                      )),
                    ),
          FooterCustom(
            '-1',
            openDrawerCustom: () {
              openDrawerCustom();
            },
          ),
        ],
      ),
    );
  }
}
