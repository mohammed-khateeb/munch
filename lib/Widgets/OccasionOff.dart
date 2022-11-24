import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../ContactUs_Screen.dart';

class OccasionOff extends StatelessWidget {
  // const OccasionOff({Key? key}) : super(key: key);

  final String occasionOffTxt;

  OccasionOff(this.occasionOffTxt);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.93 - 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(occasionOffTxt,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center),
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.clickHereContact,
                style: const TextStyle(
                  color: Color.fromRGBO(242, 104, 130, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute<ContactUsScreen>(
                  builder: (BuildContext context) {
                    return const ContactUsScreen();
                  },
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
