import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.asset("assets/logo.png"),
            ),
            // Text(
            //   "NR Tech Solution",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 25),
            // ),
            // Divider(
            //   color: Colors.white,
            // ),
            Text(
              "Contact us: ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //  padding: const EdgeInsets.fromLTRB(135.0, 8, 8.0, 0),

                Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                //padding: const EdgeInsets.fromLTRB(10, 8, 8.0, 0),
                Flexible(
                  child: Text(
                    "7028502648",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.mail_outline,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    "nrtechsolution8@gmail.com",
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 17),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
