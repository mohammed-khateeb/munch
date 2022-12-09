import 'package:flutter/material.dart';
import 'package:munch/main.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<EditProfileScreen> createState() => _State(EditProfileScreen);
}

class _State extends State<EditProfileScreen> {
  _State(Type editProfileScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  // ignore: prefer_typing_uninitialized_variables
  var profileObj;
  final _fullNameText = TextEditingController();
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
      _fullNameText.text = profileObj['FirstName'];
    });
  }

  saveBtn() async {
    print('save');

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$kupdateCustomerProfileECommerceAPI/',
        '{"CustomerGuid":"${prefs.getString('CustomerGuid')}","UserName":"${profileObj['UserName']}","Email":"${profileObj['Email']}","FirstName":"${_fullNameText.text}"}');

    var response = await networkHelper.postData();
    print('response = $response');
    setState(() {
      isLoading = false;

      Navigator.of(context).push(MaterialPageRoute<MyHomePage>(
        builder: (BuildContext context) {
          return MyHomePage(
            title: '',
          );
        },
      ));
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
          ScreenHeader('lib/assets/images/arrow1.png'),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 30, right: 30, top: 0, bottom: 20),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(30.0)),
                        height: 55,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextField(
                                    controller: _fullNameText,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .firstName,
                                      //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                      border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: saveBtn,
                          child: Text(
                            AppLocalizations.of(context)!.save,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(242, 104, 130, 1.0)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              242, 104, 130, 1.0))))),
                        ),
                      ),
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
