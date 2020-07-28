import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wowpaper/constants/colors.dart';
import 'package:wowpaper/functions/navigate.dart';
import 'package:wowpaper/functions/sharedPreferences.dart';
import 'package:wowpaper/screens/downloadScreen.dart';
import 'package:wowpaper/widgets/customText.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Widget> cardWidget;

  Future getImages() async {
    List<Widget> widgetList = [];

    getItem(key: 'favorite').then((value) {

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

    cardWidget = widgetList;

    return cardWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Favoritos',

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
                    )
                  ],
                );
              }else{
                return Center(
                  child: CustomText(
                    text: 'Nada aqui',
                    size: 30,
                  ),
                );
              }
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
