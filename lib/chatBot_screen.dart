//import 'dart:html';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'Widgets/Screen_Header.dart';
import 'Widgets/CustomDrawer.dart';
import 'Widgets/FooterCustom.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ChatBotScreen> createState() => _State(ChatBotScreen);
}

class _State extends State<ChatBotScreen> {
  _State(Type chatBotScreen);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isLoading = false;

  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
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
          ScreenHeader('lib/assets/images/arrow1.png'),
          isLoading
              ? Center(
                  child: Image.asset(
                    "lib/assets/images/MunchLoadingTransparent.gif",
                    height: 100.0,
                    width: 100.0,
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.93 - 120,
                  child: const WebView(
                    initialUrl:
                        'https://acdn.arabot.io/webcomponent-v6-demo/index.html?botid=777&env=1',
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
