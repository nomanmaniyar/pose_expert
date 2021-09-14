import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pose_expert/UI/search.dart';
// import 'dart:wasm';
import 'package:pose_expert/util.dart' as util;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'aboutPage.dart';

// import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// import 'package:infinite_listview/infinite_listview.dart';
// import 'package:material_search/material_search.dart';
//https://unsplash.com/napi/photos/Q14J2k8VE3U/related

var pagecount = new Random();

class Unsplash extends StatefulWidget {
  @override
  _UnsplashState createState() => _UnsplashState();
}

class _UnsplashState extends State<Unsplash> {
  bool isSearch = false, isData = true;
  dynamic data;
  int i = 1;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    data = null;
    if (isData) {
      getData(totalPage: 600);
      isData = false;
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("IN SCROLL Total Pages: " + data['total_pages'].toString());
        getData(totalPage: data['total_pages']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Photos By Unsplash",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Stack(
        children: <Widget>[
          (data == null)
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : photoViewer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future getData({int totalPage}) async {
    String apiUrl =
        "https://api.unsplash.com/search/photos/?client_id=${util.accessKey}&order_by=latest&query=mens-model&per_page=20&page=${pagecount.nextInt(totalPage > 100 ? totalPage : 50)}";

    await http.get(apiUrl).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          print("Total Pages: " + data['total_pages'].toString());
        });
      } else if (json.decode(response.body).toString() ==
          "Rate Limit Exceeded") {
        setState(() {
          data = "Server is Busy\nTry after few Minutes";
        });
      } else {
        print("Status Code Error : ${response.statusCode}");
      }
    });
  }

  Widget photoViewer() {
    return ListView.builder(
        controller: scrollController,
        itemCount: data['results'].length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == data['results'].length) {
            return CupertinoActivityIndicator();
          }
          return ListTile(
            onTap: () {},
            // subtitle: Text("ID: " + data['results'][index]['id']),
            subtitle: Row(
              children: <Widget>[
                Text("Photo by "),
                GestureDetector(
                  child: Text(
                    data['results'][index]['user']['first_name'],
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: Text("Pose Expert"),
                          content: Text("You Want to go " +
                              data['results'][index]['user']['name'] +
                              " Profile Page on Unslash."),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FlatButton(
                              child: Text("Go"),
                              onPressed: () {
                                _launchURL(data['results'][index]['user']
                                        ['links']['html'] +
                                    "?utm_source=poseexpert&utm_medium=referral");
                              },
                            ),
                            FlatButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Text(" on "),
                GestureDetector(
                  child: Text(
                    "Unsplash",
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: Text("Pose Expert"),
                          content: Text("You Want to go the Unslash Page."),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FlatButton(
                              child: Text("Go"),
                              onPressed: () {
                                _launchURL(
                                    "https://unsplash.com?utm_source=poseexpert&utm_medium=referral");
                              },
                            ),
                            FlatButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),

            title: CachedNetworkImage(
              imageUrl: "${data['results'][index]['urls']['small']}",
              placeholder: (context, url) => Container(
                height: 400,
                color: Color(Random().nextInt(0xffffffff)),
                child: CupertinoActivityIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.broken_image),
            ),
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// Container(
//   height: 100,
//   padding: EdgeInsets.fromLTRB(10, 35, 10, 35),
//   color: Colors.yellowAccent,
//   child: TextField(
//     cursorColor: Colors.black,
//     decoration: InputDecoration(
//       hintText: "Search",
//       hintStyle: TextStyle(inherit: true),
// focusedBorder: OutlineInputBorder(
//   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//   borderSide: BorderSide(color: Colors.black),
// ),
// enabledBorder: OutlineInputBorder(
//   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//   borderSide: BorderSide(color: Colors.black),
// ),
//     ),
//   ),
// ),
