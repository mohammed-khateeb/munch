import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/ShowMessage.dart';
import '../Services/Networking.dart';
import '../Services/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _fullNameText = TextEditingController();
  final _emailText = TextEditingController();

  String numberForReg = '';
  var isLoading = false;

  getNumberForLogin() async {
    final prefs = await SharedPreferences.getInstance();
    numberForReg = prefs.getString('numberForReg')!;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getNumberForLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    registerBtn() async {
      if (_fullNameText.text.isEmpty) {
        ShowMessage showMessage = ShowMessage(
            AppLocalizations.of(context)!.warning,
            AppLocalizations.of(context)!.firstName);
        showMessage.showAlertDialog(context);
        return;
      }
      String email = _emailText.text;
      if (_emailText.text.isEmpty) {
        email = '$numberForReg@Munch.com';
      }

      setState(() {
        isLoading = true;
      });

      NetworkHelper networkHelper = NetworkHelper(
          '$kbaseUrl/$kregisterMunchBakeryCustomerAPI/',
          '{"UserName":"$numberForReg","Email":"$email","FirstName":"${_fullNameText.text}","LastName":"","DeviceSourceType":"2","MobileTokenId":"ttt","OldGuestCustomerGuid":""}');
      var response = await networkHelper.postData();
      print(response);
      if (response.toString() == '0' ||
          response.toString() == '1' ||
          response.toString() == '-1') {
        ShowMessage showMessage = ShowMessage(
            AppLocalizations.of(context)!.errorLabel,
            AppLocalizations.of(context)!.somethingWentWrong);
        showMessage.showAlertDialog(context);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('smsSent', '1');
        await prefs.setString('openLogin', '1');
        setState(() {
          isLoading = false;
        });
        Navigator.of(context, rootNavigator: true).pop();
      }
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
                : Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, right: 20),
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
                                    labelText:
                                        AppLocalizations.of(context)!.firstName,
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 30, right: 30, top: 0),
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
                                  controller: _emailText,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!
                                        .emailOptional,
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
                    TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.login,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('openLogin', '1');
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: registerBtn,
                        child: Text(
                          AppLocalizations.of(context)!.register,
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
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: const BorderSide(
                                        color: Color.fromRGBO(
                                            242, 104, 130, 1.0))))),
                      ),
                    ),
                  ])));
  }
}
