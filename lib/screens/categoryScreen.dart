import 'package:flutter/material.dart';
import 'package:wowpaper/constants/colors.dart';
import 'package:wowpaper/constants/constants.dart';
import 'package:wowpaper/functions/navigate.dart';
import 'package:wowpaper/functions/request.dart';
import 'package:wowpaper/screens/downloadScreen.dart';
import 'package:wowpaper/widgets/customText.dart';

class CategoryScreen extends StatefulWidget {
  final categoryInfo;

  CategoryScreen({this.categoryInfo});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Widget> cardWidget;

  Future getImages() async {
    List<Widget> widgetList = [];
    var response = await request(url: '$url/data/category/?category_uuid=${widget.categoryInfo['uuid']}');

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

    cardWidget = widgetList;

    return response;
  }

  @override
  void initState() {
    super.initState();

    getImages();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: '${widget.categoryInfo['category']}',
        ),
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
