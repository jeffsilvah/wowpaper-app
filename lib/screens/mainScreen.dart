import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wowpaper/constants/colors.dart';
import 'package:wowpaper/constants/constants.dart';
import 'package:wowpaper/functions/loadingAnimation.dart';
import 'package:wowpaper/functions/navigate.dart';
import 'package:wowpaper/functions/request.dart';
import 'package:wowpaper/screens/favoriteScreen.dart';
import 'package:wowpaper/widgets/customText.dart';

import 'categoryScreen.dart';
import 'downloadScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> imageWidgetList;
  List<Widget> drawerList;
  List<Widget> category1 = [Container()];
  List<Widget> category2 = [Container()];
  List<Widget> category3 = [Container()];
  List<Widget> category4 = [Container()];

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
              child: Image.network(
                e['path'],
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return loadingAnimation(size: 200, radius: 100.0);
                },
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

  Future getImageByCategory({categoryUuid, List list, limit}) async {
    var response = await request(
        url: '$url/data/category/?category_uuid=$categoryUuid&limit=$limit');
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
                child: Image.network(
                  e['path'],
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
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
          ));
    });

    return widgetList;
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
            SizedBox(height: 30),
            buildFutureBuilder(
                limit: 6, list: category1, text: 'Nature', uuid: category1Uuid),
            SizedBox(height: 30),
            buildFutureBuilder(
                limit: 6, list: category2, text: 'Sea', uuid: category2Uuid),
            SizedBox(height: 30),
            buildFutureBuilder(
                limit: 6,
                list: category3,
                text: 'Universe',
                uuid: category3Uuid),
            SizedBox(height: 30),
            buildFutureBuilder(
                limit: 6, list: category4, text: 'Winter', uuid: category4Uuid),
          ],
        ),
      ),
    );
  }

  FutureBuilder buildFutureBuilder({uuid, list, text, limit}) {
    return FutureBuilder(
      future: getImageByCategory(categoryUuid: uuid, list: list, limit: limit),
      builder: (context, snapshot) {
        getImageByCategory(categoryUuid: uuid, list: list, limit: limit)
            .then((value) {
          list = value;
        });

        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  navigate(
                    context: context,
                    route: CategoryScreen(categoryInfo: {
                      'uuid': uuid,
                      'category': text
                    })
                  );
                },
                child: CustomText(
                  text: text,
                  size: 19,
                ),
              ),
              SizedBox(height: 5),
              Wrap(
                children: list,
              ),
            ],
          );
        } else {
          return loadingAnimation(size: 50, radius: 25);
        }
      },
    );
  }
}
