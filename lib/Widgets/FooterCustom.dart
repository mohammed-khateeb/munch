import 'package:flutter/material.dart';
import '../Categories_Screen.dart';
import '../Orders_Screen.dart';
import '../SaveVeryMunch_Screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:munch/Widgets/Login.dart';
import 'package:munch/Widgets/Register.dart';
import 'package:munch/Widgets/CheckLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FooterCustom extends StatefulWidget {
  final String activeIndex;
  final Function() openDrawerCustom;

  FooterCustom(this.activeIndex, {Key? key, required this.openDrawerCustom})
      : super(key: key);

  @override
  State<FooterCustom> createState() => _FooterCustomState();
}

class _FooterCustomState extends State<FooterCustom> {
  //const FooterCustom(activeIndex, {Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
  }

  checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('UserObject') != null) {
      setState(() {
        isLoggedIn = true;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
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

  openLoginCustom() {
    showLoginCustomDialog(context);
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

  openRegisterCustom() {
    showRegisterCustomDialog(context);
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

  openCheckLoginCustom() {
    showCheckLoginCustomDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    String productsImage;
    Color productsColor;
    if (widget.activeIndex == '0') {
      productsImage = 'lib/assets/images/productsTabIconActive.png';
      productsColor = const Color.fromRGBO(242, 104, 130, 1.0);
    } else {
      productsImage = 'lib/assets/images/productsTabIcon.png';
      productsColor = Colors.grey;
    }

    String ordersImage;
    Color ordersColor;
    if (widget.activeIndex == '1') {
      ordersImage = 'lib/assets/images/orderTabIconActive.png';
      ordersColor = const Color.fromRGBO(242, 104, 130, 1.0);
    } else {
      ordersImage = 'lib/assets/images/ordersTabIcon.png';
      ordersColor = Colors.grey;
    }

    String saveVeryMunchImage;
    Color saveVeryMunchColor;
    if (widget.activeIndex == '2') {
      saveVeryMunchImage = 'lib/assets/images/giftTabIconActive.png';
      saveVeryMunchColor = const Color.fromRGBO(242, 104, 130, 1.0);
    } else {
      saveVeryMunchImage = 'lib/assets/images/giftTabIcon.png';
      saveVeryMunchColor = Colors.grey;
    }

    return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute<CategoriesScreen>(
                    builder: (BuildContext context) {
                      return CategoriesScreen();
                    },
                  ));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.07,
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset(
                            productsImage,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(AppLocalizations.of(context)!.products,
                              style: TextStyle(
                                color: productsColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              )),
                        ),
                      ],
                    )),
              ),
              GestureDetector(
                onTap: () {
                  if (isLoggedIn) {
                    Navigator.of(context)
                        .push(MaterialPageRoute<OrdersScreen>(
                      builder: (BuildContext context) {
                        return OrdersScreen();
                      },
                    ));
                  } else {
                    openCheckLoginCustom();
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.07,
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset(
                            ordersImage,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(AppLocalizations.of(context)!.orders,
                              style: TextStyle(
                                color: ordersColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              )),
                        ),
                      ],
                    )),
              ),
              GestureDetector(
                onTap: () {
                  if (isLoggedIn) {
                    Navigator.of(context)
                        .push(MaterialPageRoute<SaveVeryMunchScreen>(
                      builder: (BuildContext context) {
                        return SaveVeryMunchScreen();
                      },
                    ));
                  } else {
                    openCheckLoginCustom();
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.07,
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset(
                            saveVeryMunchImage,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(AppLocalizations.of(context)!.munchBunch,
                              style: TextStyle(
                                color: saveVeryMunchColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 11.5,
                              )),
                        ),
                      ],
                    )),
              ),
              GestureDetector(
                onTap: widget.openDrawerCustom,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.07,
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset(
                            'lib/assets/images/moreTabIcon.png',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(AppLocalizations.of(context)!.more,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              )),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
