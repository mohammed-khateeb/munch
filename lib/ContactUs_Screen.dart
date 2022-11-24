import 'package:flutter/material.dart';
import 'package:munch/chatBot_screen.dart';
import 'Services/ShowMessage.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './Services/Networking.dart';
import 'Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ContactUsScreen> createState() => _State(ContactUsScreen);
}

class _State extends State<ContactUsScreen> {
  _State(Type ordersScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameText = TextEditingController();
  final _emailText = TextEditingController();
  final _mobileText = TextEditingController();
  final _messageText = TextEditingController();
  var isLoading = false;

  submitBtn() async {
    if (_nameText.text.isEmpty ||
        _emailText.text.isEmpty ||
        _mobileText.text.isEmpty ||
        _messageText.text.isEmpty) {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.warning,
          AppLocalizations.of(context)!.fillAll);
      showMessage.showAlertDialog(context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper(
        '$kbaseUrl/$ksendContactUsMunchBakeryAPI/',
        '{"Body":"${_messageText.text}","Mobile":"${_mobileText.text}","Email":"${_emailText.text}","FirstName":"${_nameText.text}"}');

    var response = await networkHelper.postData();
    print('response = $response');
    setState(() {
      isLoading = false;
    });
    if (response == true) {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.successfullTitle,
          AppLocalizations.of(context)!.sentSuccessfully);
      showMessage.showAlertDialog(context);
      return;
    } else {
      ShowMessage showMessage = ShowMessage(
          AppLocalizations.of(context)!.errorLabel,
          AppLocalizations.of(context)!.unknownError);
      showMessage.showAlertDialog(context);
      return;
    }
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.93 - 120,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            child: Text(
                              AppLocalizations.of(context)!.contactUs,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 30, right: 30, top: 0, bottom: 20),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0)),
                            height: 40,
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextField(
                                        controller: _nameText,
                                        decoration: InputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!.name,
                                          //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                          border: InputBorder.none,
                                        ),
                                        keyboardType:
                                            TextInputType.visiblePassword,
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
                          Container(
                            margin: const EdgeInsets.only(
                                left: 30, right: 30, top: 0, bottom: 20),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0)),
                            height: 40,
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextField(
                                        controller: _emailText,
                                        decoration: InputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!.email,
                                          //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                          border: InputBorder.none,
                                        ),
                                        keyboardType:
                                            TextInputType.visiblePassword,
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
                          Container(
                            margin: const EdgeInsets.only(
                                left: 30, right: 30, top: 0, bottom: 20),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0)),
                            height: 40,
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextField(
                                        controller: _mobileText,
                                        decoration: InputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!.phone,
                                          //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                          border: InputBorder.none,
                                        ),
                                        keyboardType:
                                            TextInputType.visiblePassword,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 0, bottom: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 60,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: _messageText,
                                            decoration: InputDecoration(
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .message,
                                              //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                              border: InputBorder.none,
                                            ),
                                            keyboardType: TextInputType.multiline,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 0, bottom: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 60,
                              height: 50,
                              // margin:
                              //     const EdgeInsets.only(left: 30, right: 30),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: ElevatedButton(
                                  onPressed: submitBtn,
                                  // ignore: prefer_const_constructors
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromRGBO(242, 104, 130, 1.0)),
                                  ),
                                  child:
                                      Text(AppLocalizations.of(context)!.submit),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 0, bottom: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 60,
                              height: 50,
                              // margin:
                              //     const EdgeInsets.only(left: 30, right: 30),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    var url = 'https://wa.me/966920015010';
                                    launch(url);
                                  },
                                  // ignore: prefer_const_constructors
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromRGBO(242, 104, 130, 1.0)),
                                  ),
                                  child: Text(
                                      AppLocalizations.of(context)!.whatsapp),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 0, bottom: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 60,
                              height: 50,
                              // margin:
                              //     const EdgeInsets.only(left: 30, right: 30),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute<ChatBotScreen>(
                                      builder: (BuildContext context) {
                                        return ChatBotScreen();
                                      },
                                    ));
                                  },
                                  // ignore: prefer_const_constructors
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromRGBO(242, 104, 130, 1.0)),
                                  ),
                                  child: Text(
                                      AppLocalizations.of(context)!.startChat),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
    );
  }
}
