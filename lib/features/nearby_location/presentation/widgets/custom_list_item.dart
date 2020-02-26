import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _Description extends StatelessWidget {
  _Description({
    Key key,
    this.title,
    this.address,
    this.distance,
    this.category,
    this.source,
    // this.readDuration,
  }) : super(key: key);

  final String title;
  final String address;
  final String distance;
  final String category;
  final String source;
  // final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  '$title',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                Text(
                  '$address',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Colors.black54,
                    // fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: ButtonTheme(
                    height: 30,
                    child: RaisedButton(
                      color: Color(0XFF242F3E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: (() {
                        _launchUrl(source);
                      }),
                      child: Text(
                        "Menuju Lokasi",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String src) async {
    if (await canLaunch(src)) {
      await launch(src);
    } else {
      throw 'Could not launch $src';
    }
  }
}

class CustomListItem extends StatelessWidget {
  CustomListItem({
    Key key,
    this.thumbnail,
    this.title,
    this.address,
    this.distance,
    this.category,
    this.source,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String address;
  final String distance;
  final String category;
  final String source;
  // final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 16,
      ),
      child: Container(
        height: 180,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.7,
              child: Stack(children: <Widget>[
                Positioned.fill(
                  child: thumbnail,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '$distance KM',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _Description(
                  title: title,
                  address: address,
                  distance: distance,
                  category: category,
                  source: source,
                  // readDuration: readDuration,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
