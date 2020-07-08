import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:connectivity/connectivity.dart';

class OnlinePosts extends StatefulWidget {
  @override
  _OnlinePostsState createState() => _OnlinePostsState();
}

class _OnlinePostsState extends State<OnlinePosts> {
  List<DocumentSnapshot> mensPosts = <DocumentSnapshot>[];
  List<DocumentSnapshot> womensPosts = <DocumentSnapshot>[];
  GlobalKey<OfflineBuilderState> _key = GlobalKey<OfflineBuilderState>();
  bool boy = true;
  bool girl = false;

  @override
  void initState() {
    getMensPosts();
    getWomensPosts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(color: Colors.black,fontFamily:"muli"),
              ),
            ),
          );
        } else {
          return child;
        }
      },
      builder: (BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: 'Get your\n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Favourite Poses Online',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
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
                child: boy ? mensList() : womensList()));
      },
    );
  }

/*


 
*/

  Widget mensList() {
    return mensPosts.length == 0
        ? Center(
            child: Text(
            "Sorry No Boys Posts",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30),
          ))
        : ListView.builder(
            itemCount: mensPosts.length,
            itemBuilder: (BuildContext contex, int index) {
              final imageurl = mensPosts[index].data['imageURL'];
              print("LEngth: ${mensPosts.length}");
              return Card(
                margin: const EdgeInsets.fromLTRB(8, 5, 8, 3),
                clipBehavior: Clip.hardEdge,
                elevation: 15,
                child: CachedNetworkImage(
                  placeholder: (context, imageurl) {
                    return SpinKitDualRing(color: Colors.orangeAccent);
                  },
                  errorWidget: (context, imageurl, error) {
                    return Icon(Icons.error);
                  },
                  imageUrl: imageurl,
                ),
              );
            });
  }

  Widget womensList() {
    return womensPosts.length <= 0
        ? Center(
            child: Text(
            "Sorry No Girls Posts",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30),
          ))
        : ListView.builder(
            itemCount: womensPosts.length,
            itemBuilder: (BuildContext contex, int index) {
              final imageurl = womensPosts[index].data['imageURL'];
              return Card(
                  margin: const EdgeInsets.fromLTRB(8, 5, 8, 3),
                  clipBehavior: Clip.hardEdge,
                  elevation: 15,
                  child: CachedNetworkImage(
                    placeholder: (context, imageurl) {
                      return SpinKitFadingCircle(color: Colors.orangeAccent);
                    },
                    errorWidget: (context, imageurl, error) {
                      return Icon(Icons.error);
                    },
                    imageUrl: imageurl,
                  ));
            });
  }

  getMensPosts() async {
    Firestore firestore = Firestore.instance;
    try {
      await firestore
          .collection("posts")
          .where('type', isEqualTo: 'Boys')
          .getDocuments()
          .then((snaps) {
        setState(() {
          mensPosts = snaps.documents;
        });
        print("Mens Length" + mensPosts.length.toString());
      });
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  getWomensPosts() async {
    Firestore firestore = Firestore.instance;
    try {
      await firestore
          .collection("posts")
          .where('type', isEqualTo: 'Girls')
          .getDocuments()
          .then((snaps) {
        setState(() {
          womensPosts = snaps.documents;
        });

        print("Womens Length" + womensPosts.length.toString());
      });
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  Widget femaleTap() {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.orange[300],
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
            color: Colors.orange[300],
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
