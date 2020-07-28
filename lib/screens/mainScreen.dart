import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wowpaper/constants/colors.dart';
import 'package:wowpaper/constants/constants.dart';
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

  Future getImages() async {
    List<Widget> widgetList = [];
    var response = await request(url: '$url/data/');

    response['data'].forEach((e) {
      widgetList.add(
        GestureDetector(
          onTap: (){
            navigate(context: context, route: DownloadScreen(imagePath: e['path']));
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
      ),
        )
      );
    });

    imageWidgetList = widgetList;

    return response;
  }

  Future getCategories() async {
    var response = await request(url: '$url/categories/');
    List<Widget> widgetList = [DrawerHeader(
      child: Center(
        child: CustomText(
          text: 'Menu',
          size: 30,
        ),
      ),
      decoration: BoxDecoration(
          color: primaryColor
      ),
    )];

    response['data'].forEach((e) {
      widgetList.add(
          ListTile(
            onTap: (){
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
          )
      );
    });

    drawerList = widgetList;

    return response;

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
            onPressed: (){},
            icon: Icon(
              Icons.help,
            ),
            iconSize: 30,
          ),
          IconButton(
            onPressed: (){
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
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView(
                  children: drawerList
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 12),
            CustomText(
              text: 'Adicionados recentemente',
              align: TextAlign.center,
              size: 22,
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: getImages(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: imageWidgetList,
                    );
                  }else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
