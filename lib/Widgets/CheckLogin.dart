import 'package:flutter/material.dart';
import '../Services/CountryCodes.dart';
import '../Services/ShowMessage.dart';
import '../Services/Networking.dart';
import '../Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckLogin extends StatefulWidget {
  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  //Login({Key? key}) : super(key: key);
  final _loginText = TextEditingController();

  final _searchText = TextEditingController();

  //bool _validate = false;
  var isLoading = false;

  String? cCode = CountryCodes[0]['phonecode'];

  // ignore: non_constant_identifier_names
  Widget Bottom_Countries_Sheet_Widget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromRGBO(232, 231, 232, 1.0)),
                borderRadius: BorderRadius.circular(10.0)),
            height: 60,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: _searchText,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.searchPlaceHolder,
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: CountryCodes.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 20),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromRGBO(232, 231, 232, 1.0)),
                          borderRadius: BorderRadius.circular(10.0)),
                      height: 60,
                      child: GestureDetector(
                        onTap: () {
                          print(CountryCodes[index]['enName']);

                          setState(() {
                            cCode = CountryCodes[index]['phonecode'];
                          });
                          Navigator.pop(context);
                        },
                        child: ListTile(
                          title: Text(
                            CountryCodes[index]['enName'] ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          // leading: CachedNetworkImage(
                          //   imageUrl: CountryCodes[index]['picture']
                          //       ['PicturePath'],
                          //   //placeholder: (context, url) => const CircularProgressIndicator(),
                          //   errorWidget: (context, url, error) =>
                          //       const Icon(Icons.error),
                          //   width: double.infinity,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ));
                }),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromRGBO(232, 231, 232, 1.0)),
                borderRadius: BorderRadius.circular(10.0)),
            height: 60,
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names

    continueBtn() async {
      if (_loginText.text.isEmpty) {
        ShowMessage showMessage = ShowMessage(
            AppLocalizations.of(context)!.warning,
            AppLocalizations.of(context)!.mobileEnter);
        showMessage.showAlertDialog(context);
        return;
      }
      if (_loginText.text.length < 9) {
        ShowMessage showMessage = ShowMessage(
            AppLocalizations.of(context)!.warning,
            AppLocalizations.of(context)!.numberValidation);
        showMessage.showAlertDialog(context);
        return;
      }
      setState(() {
        isLoading = true;
      });
      String phoneNumber = _loginText.text;
      if (phoneNumber[0] == '0') {
        phoneNumber = phoneNumber.substring(1);
      }
      phoneNumber = '+$cCode$phoneNumber';
      NetworkHelper networkHelper = NetworkHelper(
          '$kbaseUrl/$kvalidateMunchBakeryLoginAPI/',
          '{"UserNameEmail":"$phoneNumber","Password":"","OldGuestCustomerGuid":"","DeviceSourceType":"2","MobileTokenId":"ttt"}');
      var response = await networkHelper.postData();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loginStatus', response['LoginStatus'].toString());
      await prefs.setString('numberForLogin', _loginText.text);
      await prefs.setString('numberForReg', phoneNumber);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context, rootNavigator: true).pop();
    }

    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        height: 350,
        width: MediaQuery.of(context).size.width * 0.80,
        child: isLoading
            ? Center(
                child: Image.asset(
                  "lib/assets/images/MunchLoadingTransparent.gif",
                  height: 100.0,
                  width: 100.0,
                ),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: const SizedBox(
                              //width: 55,
                              child: Icon(
                            Icons.close,
                            size: 35,
                          )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.welcomeBack,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 30, right: 30, top: 20, bottom: 20),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(30.0)),
                    height: 55,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('country');
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (BuildContext context) {
                                return Bottom_Countries_Sheet_Widget();
                              },
                            );
                          },
                          child: Row(
                            children: [
                              DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text('+$cCode'),
                                  )),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 15,
                                child: Image.asset(
                                  'lib/assets/images/dropDownArrow.png',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: VerticalDivider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                              controller: _loginText,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.phone,
                                //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: continueBtn,
                      child: Text(
                        AppLocalizations.of(context)!.continueTxt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(242, 104, 130, 1.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              242, 104, 130, 1.0))))),
                    ),
                  )
                ],
              ),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
