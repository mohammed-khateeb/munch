import 'package:flutter/material.dart';
import 'package:munch/main.dart';
import 'Services/ShowMessage.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class AboutUsScreen extends StatefulWidget {
  AboutUsScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<AboutUsScreen> createState() => _State(AboutUsScreen);
}

class _State extends State<AboutUsScreen> {
  _State(Type aboutUsScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  // ignore: prefer_typing_uninitialized_variables

  var dataObj;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      getData();
    });
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryCMSAPI/5/${prefs.getString('langId')}', '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    List response = await networkHelper.getData();
    if (response.isNotEmpty) {
      dataObj = response[0];
    }
    print('response = $response');
    setState(() {
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
          ScreenHeader('lib/assets/images/giftIcon.png'),
          Expanded(
            child: isLoading
                ? Center(
                    child: Image.asset(
                      "lib/assets/images/MunchLoadingTransparent.gif",
                      height: 100.0,
                      width: 100.0,
                    ),
                  )
                : Stack(children: [
                    Image.asset(
                      "lib/assets/images/Mobile_Image_Big.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 50, horizontal: 30),
                              child: Text(
                                AppLocalizations.of(context)!.howDidIt,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                dataObj['Title'],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: SizedBox(
                              width: 250,
                              height: 40,
                              child: OutlinedButton(
                                onPressed: () {
                                  var url = dataObj['LinkUrl'];
                                  launch(url);
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.companyProfile,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ]),
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
