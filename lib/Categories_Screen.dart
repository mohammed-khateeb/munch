import 'package:flutter/material.dart';
import 'Widgets/Screen_Header.dart';
import './models/CategoryObj.dart';
import 'Widgets/Category_Item.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({Key? key}) : super(key: key);


  @override
  // ignore: no_logic_in_create_state
  State<CategoriesScreen> createState() => _State(CategoriesScreen);
}

class _State extends State<CategoriesScreen> {
  _State(Type categoriesScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var catsList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getCategories();
  }

  void getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryCategoriesAPI/${prefs.getString('langId')}',
        '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    List catsData = await networkHelper.getData();

    setState(() {
      for (var i = 0; i < catsData.length; i++) {
        catsList.add(CategoryObj(
          catsData[i]['Id'].toString(),
          catsData[i]['CatName'],
          catsData[i]['picture'] != null
              ? catsData[i]['picture']['PicturePath']
              : '',
        ));
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

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
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    children: catsList
                        .map((catData) => CategoryItem(
                            catData.id, catData.title, catData.imageUrl))
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
