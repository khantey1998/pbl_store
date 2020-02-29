import 'package:flutter/material.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/models/content_management_system.dart';
import 'package:pbl_store/screens/content_management_view.dart';
class ContentManagementScreen extends StatefulWidget {
  @override
  _ContentManagementScreenState createState() => _ContentManagementScreenState();
}

class _ContentManagementScreenState extends State<ContentManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Setting",
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
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
          future: NetworkUtils.getContentManagementSystem(),
          builder: (BuildContext content, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              List<ContentManagementSystem> contentManagementSystems = snapshot.data;
              List<ContentManagementSystem> filtered = List();
              for(ContentManagementSystem c in contentManagementSystems){
                if(c.metaTitle != "About us"){
                  filtered.add(c);
                }
              }
              return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index){
                    return Card(
                      margin: const EdgeInsets.all(0.0),
                      child: ListTile(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContentManagementView(contentManagementSystem: filtered[index],)),
                          );
                        },
                        leading: Icon(Icons.subdirectory_arrow_right),
                        title: Text("${filtered[index].metaTitle}"),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  });
            }
            else{
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
