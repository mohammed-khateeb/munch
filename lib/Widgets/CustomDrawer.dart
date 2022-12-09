import 'package:flutter/material.dart';
import 'package:munch/ContactUs_Screen.dart';
import 'package:munch/aboutus_screen.dart';
import 'package:munch/addresses_screen.dart';
import 'package:munch/myProfile_Screen.dart';
import 'package:munch/storeLocations_screen.dart';
import '../Categories_Screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../CustomCakeHome_Screen.dart';
import '../Localizations/app_language.dart';
import 'CheckLogin.dart';
import 'Login.dart';
import 'Register.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key, required this.closeDrawerCustom})
      : super(key: key);

  final Function() closeDrawerCustom;

  @override
  // ignore: no_logic_in_create_state
  State<CustomDrawer> createState() => _State(CustomDrawer);
}

class _State extends State<CustomDrawer> {
  _State(Type ordersScreen);

  bool isLoggedIn = false;
  Future<bool> getIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    print('UserObject = ${prefs.getString('UserObject')}');
    if (prefs.getString('UserObject') != null) {
      setState(() {
        isLoggedIn = true;
      });

      print('isLoggedIn if= $isLoggedIn');
      return true;
    } else {
      setState(() {
        isLoggedIn = false;
      });

      print('isLoggedIn else = $isLoggedIn');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getIsLoggedIn();
      print('isLoggedIn = $isLoggedIn');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var appLanguage = Provider.of<AppLanguage>(context);

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           SizedBox(
            height: size.height*0.13,
          ),
          SizedBox(
            width: size.width*0.25,
            child: Image.asset(
              'lib/assets/images/logo.png',
            ),
          ),
           SizedBox(
            height: size.height*0.04,
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.products,
              style:  TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.height*0.025,
              ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<CategoriesScreen>(
                builder: (BuildContext context) {
                  return CategoriesScreen();
                },
              ));
            },
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.customizedCake,
              style:  TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.height*0.025,
              ),
            ),
            onPressed: () {
              if (isLoggedIn) {
                Navigator.of(context)
                    .push(MaterialPageRoute<CustomCakeHomeScreen>(
                  builder: (BuildContext context) {
                    return const CustomCakeHomeScreen();
                  },
                ));
              } else {
                openCheckLoginCustom();
              }
            },
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.myAccount,
              style:  TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.height*0.025,
              ),
            ),
            onPressed: () {
              if(isLoggedIn) {
                Navigator.of(context).push(MaterialPageRoute<MyProfileScreen>(
                builder: (BuildContext context) {
                  return MyProfileScreen();
                },
              ));
              }
              else{
                openCheckLoginCustom();
              }
            },
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.myAddresses,
              style:  TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.height*0.025,
              ),
            ),
            onPressed: () {
              if(isLoggedIn) {
                Navigator.of(context).push(MaterialPageRoute<AddressesScreen>(
                  builder: (BuildContext context) {
                    return AddressesScreen();
                  },
                ));
              }
              else{
                openCheckLoginCustom();
              }
            },
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.storeLocations,
              style:  TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.height*0.025,
              ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<StoreLocationsScreen>(
                builder: (BuildContext context) {
                  return StoreLocationsScreen();
                },
              ));
            },
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.aboutUs,
              style:  TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.height*0.025,
              ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<AboutUsScreen>(
                builder: (BuildContext context) {
                  return AboutUsScreen();
                },
              ));
            },
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.contactUs,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.height*0.025,
              ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<ContactUsScreen>(
                builder: (BuildContext context) {
                  return ContactUsScreen();
                },
              ));
            },
          ),
          TextButton(
            child: Text(
              isLoggedIn
                  ? AppLocalizations.of(context)!.logout
                  : AppLocalizations.of(context)!.login,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.height*0.025,
              ),
            ),
            onPressed: () async {
              if(isLoggedIn) {
                widget.closeDrawerCustom();
                if (isLoggedIn) {
                  final prefs = await SharedPreferences.getInstance();
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
                }
              }
              else{
                openCheckLoginCustom();
              }
            },
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 150,
            child: OutlinedButton(
              onPressed: (){
                appLanguage.changeLanguage(Locale(Localizations.localeOf(context).languageCode=="en"?"ar":"en"));
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
              ),
              child: Text(
                AppLocalizations.of(context)!.changeLang,
                style:  TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: size.height*0.025,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  openCheckLoginCustom() {
    showCheckLoginCustomDialog(context);
  }

  void showCheckLoginCustomDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: CheckLogin(),
        );
      },
    ).then((value) async {
      print('dialog dismessed');
      final prefs = await SharedPreferences.getInstance();
      final String? loginStatus = prefs.getString('loginStatus');
      print('loginStatus = $loginStatus');
      if (loginStatus == '3') {
        openLoginCustom();
      } else if (loginStatus == '2') {
        openRegisterCustom();
      }
      prefs.setString('loginStatus', '-1');
    });
  }

  openLoginCustom() {
    showLoginCustomDialog(context);
  }

  openRegisterCustom() {
    showRegisterCustomDialog(context);
  }

  void showRegisterCustomDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return const Center(
          child: Register(),
        );
      },
    ).then((value) async {
      print('dialog Register dismessed');
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('openLogin') != null) openLoginCustom();
      await prefs.remove('openLogin');
      await prefs.remove('smsSent');
    });
  }


  void showLoginCustomDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return const Center(
          child: Login(),
        );
      },
    ).then((value) {
      print('dialog dismessed');
    });
  }

}
