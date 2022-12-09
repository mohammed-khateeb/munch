// ignore: file_names
import 'package:flutter/material.dart';
import 'package:munch/search_screen.dart';
import '../main.dart';
import '../Cart_Screen.dart';
import 'dart:math' as math;

class ScreenHeader extends StatelessWidget {
  final String iconPath;
  final bool inSearchScreen;

  const ScreenHeader(this.iconPath, {this.inSearchScreen = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      height: size.height*0.13,
      child: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: size.width*0.05, top: size.height*0.015),
                  child: GestureDetector(
                    onTap: () {
                      if (iconPath == 'lib/assets/images/arrow1.png') {
                        Navigator.of(context).pop();
                      }
                      else if(iconPath == 'lib/assets/images/ic_search_test.png'&&!inSearchScreen){
                        Navigator.of(context).push(
                            MaterialPageRoute<
                                SearchScreen>(
                              builder:
                                  (BuildContext context) {
                                return const SearchScreen();
                              },
                            ));
                      }
                    },
                    child: SizedBox(
                      height:  size.height*0.025,
                      child: Transform.rotate(
                        angle:Localizations.localeOf(context).languageCode=="ar"&&iconPath == 'lib/assets/images/arrow1.png'?math.pi: 0,
                        child: Image.asset(
                          iconPath,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.only(end: size.width*0.05, top: size.height*0.015),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute<CartScreen>(
                        builder: (BuildContext context) {
                          return const CartScreen();
                        },
                      ));
                    },
                    child: Row(
                      children: [
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(12.5),
                        //   child: Container(
                        //     width: 25,
                        //     height: 25,
                        //     color: const Color.fromRGBO(242, 104, 130, 1.0),
                        //     child: const Center(
                        //       child: Text(
                        //         '0',
                        //         style: TextStyle(
                        //           backgroundColor: Color.fromRGBO(242, 104, 130, 1.0),
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 16,
                        //         ),
                        //         textAlign: TextAlign.center,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        SizedBox(
                          height: size.height*0.025,
                          child: Image.asset(
                            'lib/assets/images/Icon_Cart.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding:  EdgeInsets.only(top: size.height*0.035),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute<MyHomePage>(
                    builder: (BuildContext context) {
                      return MyHomePage(
                        title: '',
                      );
                    },
                  ));
                },
                child: SizedBox(
                  width: size.width*0.13,
                  child: Image.asset(
                    'lib/assets/images/logo.png',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
