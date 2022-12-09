import 'package:flutter/material.dart';
import 'package:munch/CustomCakeHome_Screen.dart';
import 'Localizations/app_language.dart';
import 'PushNotificationService/push_notification_services.dart';
import 'Widgets/Screen_Header.dart';
import 'Categories_Screen.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import 'Widgets/MainSlider.dart';
import 'Services/Networking.dart';
import 'Services/constants.dart';
import './Widgets/RecommendedItems.dart';
import 'Widgets/CheckLogin.dart';
import 'Widgets/Login.dart';
import 'Widgets/Register.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(appLanguage: appLanguage,));
}

Locale locale = const Locale('ar');

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;

  const MyApp({Key? key, required this.appLanguage}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? fcmToken;


  void initFirebaseMessaging() async {
    _messaging.getToken().then((token) {
      fcmToken = token;
      print("/////////////////$token");
      PushNotificationServices.fcmToken = fcmToken;

    });

    _messaging.onTokenRefresh.listen((newToken) {
      PushNotificationServices.fcmToken = fcmToken;
    });

    FirebaseMessaging.onBackgroundMessage(
        PushNotificationServices.firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      PushNotificationServices.showNotification(message);
    });

  }

  @override
  void initState() {
    PushNotificationServices.setUpLocalNotification();
    initFirebaseMessaging();

    super.initState();

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Locale locale = const Locale('ar', 'JO');


    return ChangeNotifierProvider<AppLanguage>(
        create: (_) => widget.appLanguage,
    child: Consumer<AppLanguage>(builder: (context,model, child){
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            locale: model.appLocal,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
              fontFamily: "Regular"
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page')
            // home: const CategoriesScreen());
            //home: const ItemsScreen())
            );
      }
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var isLoggedIn = false;
  var firstName = '';
  var slidersData = [];
  var recommendedData = [];

  //late Locale _locale;

  void getSliders() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('langId')==null){
      prefs.setString('langId',"1");
    }
    print("*******"+prefs.getString('token')!);
    if (prefs.getString('UserObject') != null) {
      setState(() {
        isLoggedIn = true;
        firstName = prefs.getString('FirstName')!;
      });
    } else {
      setState(() {
        isLoggedIn = false;
        firstName = '';
      });
    }
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryCMSAPI/4/${prefs.getString('langId')}/2',
        '');
    slidersData = await networkHelper.getData();
    //print('slidersData = $widget.slidersData');

    setState(() {
      isLoading = false;
    });
  }

  void getRecommended() async {
    final prefs = await SharedPreferences.getInstance();
    var customerGuid = '-1';
    if (prefs.getString('CustomerGuid') != null) {
      customerGuid = prefs.getString('CustomerGuid')!;
    }
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kgetMunchBakeryRecommendedProductsAPI/',
        '{"langId":"${prefs.getString('langId')}","CityId":"-1","DistrictId":"-1","ZoneId":"-1","CustomerGuid":"$customerGuid"}');
    var response = await networkHelper.postData();
    recommendedData =
        response['GetMunchBakeryRecommendedProductsResult'];
    //print('response = $response');
    print('recommendedData = ${recommendedData}');

    setState(() {
      isLoading = false;
    });
  }

  void updateLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('UserObject') != null) {
      print('emailLogin = ${prefs.getString('emailLogin')}');
      print('passwordLogin = ${prefs.getString('passwordLogin')}');

      var number = prefs.getString('emailLogin');
      var password = prefs.getString('passwordLogin');

      NetworkHelper networkHelper = NetworkHelper(
          '$kbaseUrl/$kvalidateMunchBakeryLoginAPI/',
          '{"UserNameEmail":"$number","Password":"$password","OldGuestCustomerGuid":"","DeviceSourceType":"2","MobileTokenId":"ttt"}');
      var response = await networkHelper.postData();
      print('res = $response');
      print(response['CustomerId']);
      if (response['CustomerId'].toString() != '0') {
        print('logged in');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('UserObject', '1');
        await prefs.setString('CustomerId', response['CustomerId'].toString());
        await prefs.setString(
            'CustomerGuid', response['CustomerGuid'].toString());
        await prefs.setString('token', response['token'].toString());
        await prefs.setString('emailLogin', number ?? '');
        await prefs.setString('passwordLogin', password ?? '');
        await prefs.setString('FirstName', response['FirstName'].toString());
        await prefs.setString('MobileNumber', response['UserName'].toString());
        await prefs.setString('CardPin', response['CardPin'].toString());
        await prefs.setString('PayfortEmail', response['Email'].toString());
      } else if (response['CustomerId'].toString() == '0') {
        setState(() {
          isLoading = false;
        });
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      getSliders();
      getRecommended();
      updateLogin();
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
      transitionDuration: const Duration(milliseconds: 700),
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

  closeDrawerCustom() async {
    _scaffoldKey.currentState!.openEndDrawer();
    final prefs = await SharedPreferences.getInstance();
    print('UserObject = ${prefs.getString('UserObject')}');
    if (prefs.getString('UserObject') == null) {
      setState(() {
        isLoggedIn = false;
        firstName = '';
      });
      openCheckLoginCustom();
    } else {
      setState(() {
        isLoggedIn = true;
        firstName = prefs.getString('FirstName')!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // List<String> sliderImages = [
    //   'https://liveapi.munchbakery.com/munchimages/0552468_free-delivery.jpeg',
    //   'https://liveapi.munchbakery.com/munchimages/0508005_cookies-1.jpeg'
    // ];

    Size size = MediaQuery.of(context).size;


    openDrawerCustom() {
      _scaffoldKey.currentState!.openDrawer();
    }


    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      key: _scaffoldKey,
      drawer: CustomDrawer(
        closeDrawerCustom: () {
          closeDrawerCustom();
        },
      ),
      body: isLoading
          ? Center(
              child: Image.asset(
                "lib/assets/images/MunchLoadingTransparent.gif",
                height: 100.0,
                width: 100.0,
              ),
            )
          : Column(
              children: [
                ScreenHeader('lib/assets/images/giftIcon.png'),
                SizedBox(
                  height: size.height * 0.93 - 120,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:  EdgeInsetsDirectional.only(top: 10, start: size.width*0.025),
                          child: Text(
                            '${AppLocalizations.of(context)!.hello} $firstName',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.018,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          margin:  EdgeInsetsDirectional.only(top: 10, start: size.width*0.025),
                          child: Text(
                            AppLocalizations.of(context)!.whatGonna,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: size.height*0.017,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute<CategoriesScreen>(
                                        builder: (BuildContext context) {
                                          return CategoriesScreen();
                                        },
                                      ));
                                    },
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'lib/assets/images/OrderFreshProducts.jpeg',
                                          width: size.width * 0.42,
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.only(
                                              start: 10.0, top: 15),
                                          child: SizedBox(
                                            width: size.width * 0.2,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .orderFreshProducts,
                                              style:  TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.height*0.018,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (isLoggedIn) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute<
                                                CustomCakeHomeScreen>(
                                          builder: (BuildContext context) {
                                            return const CustomCakeHomeScreen();
                                          },
                                        ));
                                      } else {
                                        openCheckLoginCustom();
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'lib/assets/images/OrderCustomCakes.jpeg',
                                          width: size.width * 0.42,
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.only(
                                              start: 10.0, top: 15),
                                          child: SizedBox(
                                            width: size.width*0.2,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .orderCustomCake,
                                              style:  TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.height*0.018,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        MainSlider(slidersData),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            AppLocalizations.of(context)!.recommendedForYou,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height*0.02,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        RecommendedItems(recommendedData),
                      ],
                    ),
                  ),
                ),
                FooterCustom(
                  '-1',
                  openDrawerCustom: () {
                    openDrawerCustom();
                  },
                ),
              ],
            ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
