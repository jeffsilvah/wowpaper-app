import 'package:flutter/material.dart';
import 'package:wowpaper/constants/colors.dart';
import 'package:wowpaper/functions/navigate.dart';
import 'package:wowpaper/functions/setFavorite.dart';
import 'package:wowpaper/functions/sharedPreferences.dart';
import 'package:wowpaper/screens/mainScreen.dart';
import 'package:wowpaper/widgets/customCircleButton.dart';
import 'package:wowpaper/widgets/customText.dart';

class DownloadScreen extends StatefulWidget {
  final String imagePath;

  DownloadScreen({this.imagePath});

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<String> favoriteImageList = [];
  Color whiteColor = Color(0xffFFFFFF);
  Color redColor = Color(0xffCE4B4B);
  bool favorite = false;

  @override
  void initState() {
    super.initState();

    getItem(key: 'favorite').then((value) {
      favoriteImageList = value;
      if(favoriteImageList.contains(widget.imagePath)){
        setState(() {
          favorite = true;
        });
      }
    });

  }

  @override
  void dispose() {
    super.dispose();

    setItem(key: 'favorite', value: favoriteImageList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Voltar',
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Card(
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(widget.imagePath, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomCircleButton(
                  onTap: (){},
                  iconSize: 35,
                  icon: Icons.get_app,
                  blurColor: primaryColor,
                  circleColor: primaryColor,
                  circleRadius: 35,
                  iconColor: Colors.white,
                ),
                CustomCircleButton(
                  onTap: (){
                    setState(() {
                      favorite = !favorite;
                      favoriteImageList = setFavorite(list: favoriteImageList, path: widget.imagePath);
                    });
                  },
                  iconSize: 35,
                  icon: Icons.favorite,
                  blurColor: primaryColor,
                  circleColor: primaryColor,
                  circleRadius: 35,
                  iconColor: !favorite ? whiteColor : redColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
