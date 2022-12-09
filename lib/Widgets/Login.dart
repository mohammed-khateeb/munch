import 'package:flutter/material.dart';
import '../Services/CountryCodes.dart';
import '../Services/ShowMessage.dart';
import '../Services/Networking.dart';
import '../Services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _loginText = TextEditingController();
  final _passwordText = TextEditingController();
  final _searchText = TextEditingController();

  //bool _validate = false;
  var isLoading = false;

  String? cCode = CountryCodes[0]['phonecode'];
  String numberForLogin = '';
  bool showSms = false;

  getNumberForLogin() async {
    final prefs = await SharedPreferences.getInstance();
    numberForLogin = prefs.getString('numberForLogin')!;
    if (prefs.getString('smsSent') != null) showSms = true;
    setState(() {
      _loginText = TextEditingController(text: numberForLogin);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getNumberForLogin();
    });
  }

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
    loginBtn() async {
      if (_loginText.text.isEmpty || _passwordText.text.isEmpty) {
        ShowMessage showMessage = ShowMessage(
            AppLocalizations.of(context)!.warning,
            AppLocalizations.of(context)!.emailOrMobileEnter);
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
          '{"UserNameEmail":"$phoneNumber","Password":"${_passwordText.text}","OldGuestCustomerGuid":"","DeviceSourceType":"2","MobileTokenId":"ttt"}');
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
        await prefs.setString('emailLogin', phoneNumber);
        await prefs.setString('passwordLogin', _passwordText.text);
        await prefs.setString('FirstName', response['FirstName'].toString());
        await prefs.setString('MobileNumber', response['UserName'].toString());
        await prefs.setString('CardPin', response['CardPin'].toString());
        await prefs.setString('PayfortEmail', response['Email'].toString());
      } else if (response['CustomerId'].toString() == '0') {
        ShowMessage showMessage = ShowMessage(
            "Warning", "Your password or Mobile/Email is incorrect.");
        showMessage.showAlertDialog(context);

        setState(() {
          isLoading = false;
        });
        return;
      }

      setState(() {
        isLoading = false;
      });
      Navigator.of(context, rootNavigator: true).pop();
    }

    getNewPassword() async {
      final prefs = await SharedPreferences.getInstance();
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
          '$kbaseUrl/$kforgotPasswordAPI/',
          '{"UserNameOrEMail":"$phoneNumber","NotificationType":"2","language":"${prefs.getString('langId')}"}');
      var response = await networkHelper.postData();
      print(response);
      if (response['ForgotPasswordResult']['SuccessResponse'] == null) {
        ShowMessage showMessage = ShowMessage("Warning",
            response['ForgotPasswordResult']['ErrorResponse']['ErrorMessage']);
        showMessage.showAlertDialog(context);
      } else {
        ShowMessage showMessage = ShowMessage(
            "Warning", response['ForgotPasswordResult']['SuccessResponse']);
        showMessage.showAlertDialog(context);
      }
      setState(() {
        isLoading = false;
      });
    }

    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        height: 400,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(
                        width: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.welcomeBack,
                          ),
                        ),
                      ),
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
                  showSms
                      ? DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          child: Text(
                            AppLocalizations.of(context)!.smsSent,
                          ),
                        )
                      : const SizedBox(
                          height: 1,
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
                                controller: _passwordText,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.password,
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
                      onPressed: loginBtn,
                      child: Text(
                        AppLocalizations.of(context)!.login,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.getNewPassword,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: getNewPassword,
                    ),
                  ),
                ],
              ),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
