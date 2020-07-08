import 'package:flutter/material.dart';
import 'package:pose_expert/UI/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearch = false;
  bool boy = true;
  bool girl = false;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'Get\n',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Ready To Pose',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                  child: GestureDetector(
                      onTap: () {
                        if (boy == false && girl == true) {
                          setState(() {
                            boy = true;
                            girl = false;
                          });
                        }
                      },
                      child: boy
                          ? maleTap()
                          : Image.asset(
                              "assets/gender/male.png",
                              height: 20,
                              width: 20,
                            )),
                ),
                GestureDetector(
                  onTap: () {
                    if (girl == false && boy == true) {
                      setState(() {
                        girl = true;
                        boy = false;
                      });
                    }
                  },
                  child: girl
                      ? femaleTap()
                      : Image.asset(
                          "assets/gender/female.png",
                          height: 23,
                          width: 23,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(
            0,
            10,
            0,
            0,
          ),
          child: boy ? boys : girls),
    );
  }

  var boys = ListView.builder(
      itemCount: 9,
      itemBuilder: (BuildContext contex, int index) {
        return Card(
          margin: const EdgeInsets.fromLTRB(8, 5, 8, 3),
          clipBehavior: Clip.hardEdge,
          elevation: 15,
          child: Image.asset("assets/models/boys/$index.jpg", fit: BoxFit.fill),
        );
      });

  var girls = ListView.builder(
      itemCount: 7,
      itemBuilder: (BuildContext contex, int index) {
        return Card(
          margin: const EdgeInsets.fromLTRB(8, 5, 8, 3),
          clipBehavior: Clip.hardEdge,
          elevation: 15,
          child:
              Image.asset("assets/models/girls/$index.jpg", fit: BoxFit.fill),
        );
      });

  Widget femaleTap() {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.green[300],
            spreadRadius: 2.5,
          )
        ],
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Image.asset(
        "assets/gender/female.png",
        height: 29,
        width: 29,
      ),
    );
  }

  Widget maleTap() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.green[300],
            spreadRadius: 2.5,
          )
        ],
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Image.asset(
        "assets/gender/male.png",
        height: 23.5,
        width: 23.5,
      ),
    );
  }
}

/*

 Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: TextField(
                keyboardType: TextInputType.text,
                controller: searchController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                      onTap: () {
                        searchController.text.isNotEmpty
                            ? Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Search(
                                      searchData: searchController.text,
                                    )))
                            : () {};
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      )),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(),
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: "Search ",
                  hintStyle: TextStyle(color: Colors.black),
                )),
          )

 */
