import 'dart:convert';
import 'dart:math';
import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pose_expert/util.dart' as util;
import 'package:url_launcher/url_launcher.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  dynamic data;
  bool isSearching = false;
  var pagecount = Random();
  String message = "Search Your Pose";
  int i = 1;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("Scroll Total Page: " + data['total_pages'].toString());
        getSearchData(
            totalPage: data['total_pages'], message: searchController.text);
      }
    });
    super.initState();
  }

  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(data.toString());
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text(
                "Oops, \n\nNow we are Offline!\nPlease connect to Internet",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        } else {
          return child;
        }
      },
      builder: (BuildContext context) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                (isSearching)
                    ? Center(child: SpinKitFadingFour(color: Colors.purple))
                    : (data == null)
                        ? Center(
                            child: Text(message),
                          )
                        : photoViewer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.0),
                          spreadRadius: 5,
                        ),
                      ]),
                  margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: ListTile(
                    title: TextField(
                        keyboardType: TextInputType.text,
                        controller: searchController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                          fillColor: Colors.grey.shade200,
                          hintText: "Search EX: mens model,girls model",
                          hintStyle: TextStyle(color: Colors.black),
                        )),
                    trailing: Container(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              isSearching = true;
                            });
                            searchController.text.isNotEmpty
                                ? getSearchData(
                                    message: searchController.text,
                                    totalPage: 1)
                                : () {};
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getSearchData({String message, int totalPage}) async {
    var data1;
    String apiUrl =
        "https://api.unsplash.com/search/photos/?client_id=${util.accessKey}&query=${message.replaceAll(" ", "+")}&per_page=20&order_by=latest&page=${pagecount.nextInt(totalPage > 5 ? totalPage : 1)}";

    await http.get(apiUrl).then((response) {
      if (response.statusCode == 200) {
        data1 = json.decode(response.body);
        if (data1['results'].length == 0) {
          setState(() {
            message = "no data found";
            print("TotalPages: " + message);
            isSearching = false;
          });
        } else {
          setState(() {
            data = data1;
            isSearching = false;
            print("TotalPages: " + data['total_pages'].toString());
          });
        }
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
                height: 500,
                color: Color(Random().nextInt(0xffffffff)),
                child: CupertinoActivityIndicator(),
              ),
              fadeInDuration: Duration(seconds: 2),
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
