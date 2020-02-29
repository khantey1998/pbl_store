import 'package:flutter/material.dart';
import 'package:pbl_store/models/content_management_system.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
class ContentManagementView extends StatefulWidget {
  final ContentManagementSystem contentManagementSystem;
  ContentManagementView({Key key, @required this.contentManagementSystem}) : super(key: key);
  @override
  _ContentManagementViewState createState() => _ContentManagementViewState();
}

class _ContentManagementViewState extends State<ContentManagementView> {

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          "${widget.contentManagementSystem.metaTitle}",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Color(0xff333366),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Html(
              onLinkTap: (url){
                _launchURL(url);
              },
              data: """${widget.contentManagementSystem.content}""",),
          ],
        ),
      ),
    );
  }
}
