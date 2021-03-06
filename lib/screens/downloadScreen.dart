import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wowpaper/constants/colors.dart';
import 'package:wowpaper/functions/loadingAnimation.dart';
import 'package:wowpaper/functions/setFavorite.dart';
import 'package:wowpaper/functions/sharedPreferences.dart';
import 'package:wowpaper/widgets/customCircleButton.dart';
import 'package:wowpaper/widgets/customText.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:wowpaper/services/admobService.dart';

class DownloadScreen extends StatefulWidget {
  final String imagePath;

  DownloadScreen({this.imagePath});

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final ams = AdmobService();
  List<String> favoriteImageList = [];
  Color whiteColor = Color(0xffFFFFFF);
  Color redColor = Color(0xffCE4B4B);
  bool favorite = false;

  @override
  void initState() {
    super.initState();

    getItem(key: 'favorite').then((value) {
      if(value != null){
        favoriteImageList = value;
        if(favoriteImageList.contains(widget.imagePath)){
          setState(() {
            favorite = true;
          });
        }
      }

    });

    Admob.initialize(ams.getAdmobAppId());

  }

  @override
  void dispose() {
    super.dispose();

    setItem(key: 'favorite', value: favoriteImageList);
  }

  void downloadImage({path}) async {
    try{
      var imageId = await ImageDownloader.downloadImage(
          path,
          destination: AndroidDestinationType.directoryPictures
      );

      if(imageId == null) return;

      var imgPath = await ImageDownloader.findPath(imageId);
      await ImageDownloader.open(imgPath);

    }on PlatformException catch(e){
      print(e);
    }
  }

  void showDialog({context}) async {
    ProgressDialog dialog = ProgressDialog(context);

    dialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
      showLogs: true,
    );

    dialog.style(
      progressWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      ),
      message: 'Downloading image',
      messageTextStyle: TextStyle(
        fontFamily: 'Saira',
        color: primaryColor,
        fontSize: 17
      ),
    );

    await dialog.show();

    Future.delayed(Duration(seconds: 10), (){
      dialog.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Back',
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
                  child: Image.network(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress){
                      if (loadingProgress == null) return child;
                      return loadingAnimation(size: 100, radius: 50);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomCircleButton(
                  onTap: (){
                    downloadImage(path: widget.imagePath);
                    showDialog(context: context);
                  },
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
