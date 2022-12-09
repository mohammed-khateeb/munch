import 'package:flutter/material.dart';
import 'package:munch/change_password_screen.dart';
import 'package:munch/editProfile_screen.dart';
import 'package:munch/main.dart';
import 'Localizations/app_language.dart';
import 'Widgets/Screen_Header.dart';
import './models/CategoryObj.dart';
import 'package:provider/provider.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<MyProfileScreen> createState() => _State(MyProfileScreen);
}

class _State extends State<MyProfileScreen> {
  _State(Type myProfileScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  // ignore: prefer_typing_uninitialized_variables
  var profileObj;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getProfile();
  }

  void getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetCustomerProfileAPI/${prefs.getString('CustomerGuid')}',
        '');
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    profileObj = await networkHelper.getData();
    print('profileObj = $profileObj');
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var appLanguage = Provider.of<AppLanguage>(context);

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
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/images/profileIcon.png",
                        height: size.height*0.1,
                        width: size.height*0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)!.welcomeBackProfile,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.018,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          profileObj['FirstName'],
                          style:  TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.02,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          profileObj['UserName'],
                          style:  TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.02,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          profileObj['Email'],
                          style:  TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.02,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width*0.4,
                              height: size.height*0.045,
                              // margin:
                              //     const EdgeInsets.only(left: 30, right: 30),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute<EditProfileScreen>(
                                      builder: (BuildContext context) {
                                        return EditProfileScreen();
                                      },
                                    ));
                                  },
                                  // ignore: prefer_const_constructors
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromRGBO(
                                                242, 104, 130, 1.0)),
                                  ),
                                  child: Text(AppLocalizations.of(context)!
                                      .editProfile,style: TextStyle(fontSize: size.height*0.016),),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: size.width*0.33,
                              height: size.height*0.045,
                              child: OutlinedButton(
                                onPressed: (){
                                  appLanguage.changeLanguage(Locale(Localizations.localeOf(context).languageCode=="en"?"ar":"en"));
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.changeLang,
                                  style:  TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height*0.02,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: size.width*0.65,
                            height: size.height*0.045,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute<ChangePasswordScreen>(
                                  builder: (BuildContext context) {
                                    return ChangePasswordScreen();
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
                                AppLocalizations.of(context)!.changePassword,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.018,
                                ),
                              ),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: size.width*0.65,
                            height: size.height*0.045,
                            child: OutlinedButton(
                              onPressed: () async {
                                print('here');
                                final prefs =
                                    await SharedPreferences.getInstance();
                                NetworkHelper networkHelper = NetworkHelper(
                                    '$kbaseUrl/$kdeleteCustomerAPI/',
                                    '{"CustomerGuid":"${prefs.getString('CustomerGuid')}","langId":"${prefs.getString('langId')}"}');

                                var response = await networkHelper.postData();
                                print('response = $response');
                                setState(() {
                                  isLoading = false;
                                });

                                await prefs.remove('UserObject');
                                await prefs.remove('CustomerId');
                                await prefs.remove('CustomerGuid');
                                await prefs.remove('token');
                                await prefs.remove('emailLogin');
                                await prefs.remove('passwordLogin');
                                await prefs.remove('FirstName');
                                await prefs.remove('MobileNumber');
                                await prefs.remove('CardPin');
                                await prefs.remove('PayfortEmail');

                                Navigator.of(context).push(
                                    MaterialPageRoute<MyHomePage>(
                                  builder: (BuildContext context) {
                                    return MyHomePage(
                                      title: '',
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
                                AppLocalizations.of(context)!.deleteAccount,
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.018,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
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
