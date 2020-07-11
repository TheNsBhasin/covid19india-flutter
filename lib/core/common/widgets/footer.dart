import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 32),
          Text(
            "We stand with everyone fighting on the frontlines",
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: Theme.of(context).primaryColor,
            ),
            child: RichText(
                text: TextSpan(
                    text: 'COVID19',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[200]),
                    children: [
                  TextSpan(
                      text: 'IN',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent)),
                  TextSpan(
                      text: 'D',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  TextSpan(
                      text: 'IA',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent)),
                ])),
          ),
          SizedBox(height: 32),
          FlatButton.icon(
            onPressed: _launchURL,
            padding: const EdgeInsets.all(8.0),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            color: Colors.black,
            icon: FaIcon(
              FontAwesomeIcons.github,
              color: Colors.white,
            ),
            label: Text("Open Sourced on GitHub",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _launchURL() async {
    const url = 'https://github.com/TheNsBhasin/covid19india-flutter';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
