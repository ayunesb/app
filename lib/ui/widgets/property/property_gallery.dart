import 'package:flutter/material.dart';
import 'package:paradigm_mex/models/image.dart';

class PropertyGallery extends StatelessWidget {
  final PropertyImageList imageList;
  const PropertyGallery(this.imageList) : super();

  @override
  Widget build(BuildContext context) {
    double imageDimension = (MediaQuery.of(context).size.width - 4 / 3) - 4;

    List<Widget> images = [];

    for (int i = 0; i < imageList.list.length; i++) {
      PropertyImage img = imageList.list[i];

      images.add(Container(
          height: imageDimension,
          //margin: EdgeInsets. all(10),
          child: InkWell(
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PropertyImageView(imageList, initialPage: i)),
                    )
                  },
              child: Image.network(img.url!,
                  fit: BoxFit.cover,
                  height: imageDimension,
                  width: imageDimension))));
    }
    ;

    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 4.0),
          child: Row(
            children: <Widget>[
              IconButton(
                splashColor: Colors.black,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Text(
                  'All Photos',
                  textAlign: TextAlign.left,
                  style: ThemeData.light().textTheme.headline1?.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          )),
      Expanded(
          child: GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images,
      )),
    ])));
  }
}

class ImageRow extends StatelessWidget {
  static const imageHeight = 250.0;
  static const imageWidth = 84.0;
  static const padding = 4.0;
  late final PropertyImageList images;

  ImageRow({PropertyImageList? images}) : super() {
    this.images = images ?? PropertyImageList([]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    String imageUrl = this.images.list[0].url!;
    //String imageUrl = 'assets/images/defaultProperty.png';
    return Image.network(imageUrl,
        fit: BoxFit.cover, height: imageHeight, width: width);
  }
}

class PropertyImageView extends StatelessWidget {
  final PropertyImageList imageList;
  late PageController _controller;
  final int initialPage;

  PropertyImageView(this.imageList, {this.initialPage = 0}) : super() {
    _controller = PageController(initialPage: initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Column(children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        color: Colors.white,
                        splashColor: Colors.black,
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                  Expanded(
                      child: PageView.builder(
                          itemCount: imageList.list.length,
                          controller: _controller,
                          pageSnapping: true,
                          itemBuilder: (context, pagePosition) {
                            return Container(
                                height: double.infinity,
                                child: Image.network(
                                    imageList.list[pagePosition].url!,
                                    height: double.infinity,
                                    width: double.infinity));
                          }))
                ]))));
  }
}
