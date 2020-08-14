import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wowpaper/constants/colors.dart';
import 'package:wowpaper/constants/constants.dart';
import 'package:wowpaper/functions/loadingAnimation.dart';
import 'package:wowpaper/functions/navigate.dart';
import 'package:wowpaper/functions/request.dart';
import 'package:wowpaper/screens/favoriteScreen.dart';
import 'package:wowpaper/widgets/customText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:wowpaper/services/admobService.dart';

import 'categoryScreen.dart';
import 'downloadScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ams = AdmobService();

  List<Widget> imageWidgetList;
  List<Widget> drawerList;
  List<Widget> natureList;
  List<Widget> seaList;
  List<Widget> universeList;
  List<Widget> winterList;

  Future getImages() async {
    List<Widget> widgetList = [];
    var response = await request(url: '$url/data/');

    response['data'].forEach((e) {
      widgetList.add(GestureDetector(
        onTap: () {
          navigate(
              context: context, route: DownloadScreen(imagePath: e['path']));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: primaryColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: e['path'],
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress){
                  return loadingAnimation(size: 100, radius: 50);
                },
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
        ),
      ));
    });

    imageWidgetList = widgetList;

    return response;
  }

  Future getCategories() async {
    var response = await request(url: '$url/categories/');
    List<Widget> widgetList = [
      DrawerHeader(
        child: Center(
          child: CustomText(
            text: 'Menu',
            size: 30,
          ),
        ),
        decoration: BoxDecoration(color: primaryColor),
      )
    ];

    response['data'].forEach((e) {
      widgetList.add(ListTile(
        onTap: () {
          navigate(context: context, route: CategoryScreen(categoryInfo: e));
        },
        leading: CustomText(
          text: '${e['num']}  -',
          weight: FontWeight.bold,
          size: 25,
        ),
        title: CustomText(
          text: e['category'],
        ),
      ));
    });

    drawerList = widgetList;

    return response;
  }

  Future getNatureImages() async {
    var response = await request(url: '$url/data/category/?category_uuid=$natureCategory&limit=6');
    List<Widget> widgetList = [];

    response['data'].forEach((e) {
      widgetList.add(
          GestureDetector(
            onTap: (){
              navigate(context: context, route: DownloadScreen(imagePath: e['path']));
            },
            child: Card(
              child: Container(
                width: 170,
                height: 170,
                color: primaryColor,
                child: CachedNetworkImage(
                  imageUrl: e['path'],
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress){
                    return loadingAnimation(size: 100, radius: 50);
                  },
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),

            ),
          ));
    });



    natureList = widgetList;

    return response;
  }
  Future getSeaImages() async {
    var response = await request(url: '$url/data/category/?category_uuid=$seaCategory&limit=6');
    List<Widget> widgetList = [];

    response['data'].forEach((e) {
      widgetList.add(
          GestureDetector(
            onTap: (){
              navigate(context: context, route: DownloadScreen(imagePath: e['path']));
            },
            child: Card(
              child: Container(
                width: 170,
                height: 170,
                color: primaryColor,
                child: CachedNetworkImage(
                  imageUrl: e['path'],
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress){
                    return loadingAnimation(size: 100, radius: 50);
                  },
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),

            ),
          ));
    });



    seaList = widgetList;

    return response;
  }
  Future getUniverseImages() async {
    var response = await request(url: '$url/data/category/?category_uuid=$universeCategory&limit=6');
    List<Widget> widgetList = [];

    response['data'].forEach((e) {
      widgetList.add(
          GestureDetector(
            onTap: (){
              navigate(context: context, route: DownloadScreen(imagePath: e['path']));
            },
            child: Card(
              child: Container(
                width: 170,
                height: 170,
                color: primaryColor,
                child: CachedNetworkImage(
                  imageUrl: e['path'],
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress){
                    return loadingAnimation(size: 100, radius: 50);
                  },
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),

            ),
          ));
    });



    universeList = widgetList;

    return response;
  }
  Future getWinterImages() async {
    var response = await request(url: '$url/data/category/?category_uuid=$winterCategory&limit=6');
    List<Widget> widgetList = [];

    response['data'].forEach((e) {
      widgetList.add(
          GestureDetector(
            onTap: (){
              navigate(context: context, route: DownloadScreen(imagePath: e['path']));
            },
            child: Card(
              child: Container(
                width: 170,
                height: 170,
                color: primaryColor,
                child: CachedNetworkImage(
                  imageUrl: e['path'],
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress){
                    return loadingAnimation(size: 100, radius: 50);
                  },
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),

            ),
          ));
    });



    winterList = widgetList;

    return response;
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
        title: Center(
          child: CustomText(
            text: 'Wowpaper',
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              navigate(context: context, route: FavoriteScreen());
            },
            icon: Icon(
              Icons.favorite,
            ),
            iconSize: 30,
          ),
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: getCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(children: drawerList);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 12),
            CustomText(
              text: 'Recently added',
              align: TextAlign.center,
              size: 22,
            ),
            SizedBox(height: 10),
            Container(
              height: 400,
              child: FutureBuilder(
                future: getImages(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: imageWidgetList,
                    );
                  } else {
                    return Center(
                      child: loadingAnimation(size: 100, radius: 50.0),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            AdmobBanner(
              adUnitId: ams.getBannerAdId(),
              adSize: AdmobBannerSize.FULL_BANNER,
            ),
            SizedBox(height: 20),
            CustomText(text: 'Nature', align: TextAlign.center, size: 20),
            SizedBox(height: 10),
            Container(
              child: FutureBuilder(
                future: getNatureImages(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Wrap(
                      children: natureList,
                    );
                  }else{
                    return loadingAnimation(size: 100, radius: 50.0);
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            CustomText(text: 'Sea', align: TextAlign.center, size: 20),
            SizedBox(height: 10),
            Container(
              child: FutureBuilder(
                future: getSeaImages(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Wrap(
                      children: seaList,
                    );
                  }else{
                    return loadingAnimation(size: 100, radius: 50.0);
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            CustomText(text: 'Universe', align: TextAlign.center, size: 20),
            SizedBox(height: 10),
            Container(
              child: FutureBuilder(
                future: getUniverseImages(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Wrap(
                      children: universeList,
                    );
                  }else{
                    return loadingAnimation(size: 100, radius: 50.0);
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            CustomText(text: 'Winter', align: TextAlign.center, size: 20),
            SizedBox(height: 10),
            Container(
              child: FutureBuilder(
                future: getWinterImages(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Wrap(
                      children: winterList,
                    );
                  }else{
                    return loadingAnimation(size: 100, radius: 50.0);
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            AdmobBanner(
              adUnitId: ams.getBannerAdId(),
              adSize: AdmobBannerSize.FULL_BANNER,
            ),
          ],
        ),
      ),
    );
  }

}
