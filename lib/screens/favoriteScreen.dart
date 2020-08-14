import 'dart:async';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wowpaper/constants/colors.dart';
import 'package:wowpaper/functions/loadingAnimation.dart';
import 'package:wowpaper/functions/navigate.dart';
import 'package:wowpaper/functions/sharedPreferences.dart';
import 'package:wowpaper/screens/downloadScreen.dart';
import 'package:wowpaper/widgets/customText.dart';
import 'package:wowpaper/services/admobService.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Widget> cardWidget;
  final ams = AdmobService();

  Future getImages() async {
    List<Widget> widgetList = [];

    getItem(key: 'favorite').then((value) {
      if(value.length != 0){
        widgetList.insert(0, AdmobBanner(
          adUnitId: ams.getBannerAdId(),
          adSize: AdmobBannerSize(height: 170, width: 170, name: 'ads'),
        ));
      }

      value.forEach((e) {
        widgetList.add(
          GestureDetector(
            onTap: () {
              navigate(context: context, route: DownloadScreen(imagePath: e));
            },
            child: Card(
                child: Container(
                  width: 170,
                  height: 170,
                  color: primaryColor,
                  child: Image.network(
                    e,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress){
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
          )
        );
      });

    });


    print('Length ${widgetList.length}');


    cardWidget = widgetList;

    return cardWidget;
  }

  @override
  void initState() {
    super.initState();

    Admob.initialize(ams.getAdmobAppId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Favorites',

        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              setState(() {});
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 33,
            ),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: getImages(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              if(cardWidget.length != 0){
                return ListView(
                  children: <Widget>[
                    Wrap(
                      runSpacing: 10,
                      children: cardWidget,
                    ),
                  ],
                );
              }else{
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomText(
                        text: 'Nothing here',
                        size: 30,
                      ),
                      SizedBox(height: 20),
                      AdmobBanner(
                        adUnitId: ams.getBannerAdId(),
                        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                      )
                    ],
                  ),
                );
              }
            }else{
              return Center(
                child: loadingAnimation(radius: 100, size: 50),
              );
            }
          },
        ),
      ),
    );
  }
}
