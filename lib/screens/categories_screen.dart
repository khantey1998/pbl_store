import 'package:flutter/material.dart';
import 'package:pbl_store/models/category_model.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/screens/products_by_category.dart';
import 'package:pbl_store/models/cat_id.dart';

class CategoryScreen extends StatefulWidget {
  @override
  CategoryState createState() {
    return CategoryState();
  }
}

class CategoryState extends State<CategoryScreen> {
  List<CategoryID> categories = List();
  @override
  void initState() {
    super.initState();
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
          "All Categories",
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
      body: FutureBuilder(
        future: NetworkUtils.getAllCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            if(snapshot.data == "RequestTimeOut"){
              return Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text("Request Time Out"),

                    ],
                  ),
                ),
              );
            }
            if(snapshot.data == "NetworkError"){
              return Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text("Network Error"),

                    ],
                  ),
                ),
              );
            }
            categories = snapshot.data;
            var cats = categories
                .where((cat) => cat.id != "2" && cat.id != "1")
                .toList();
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
              padding: EdgeInsets.all(0),
              itemCount: cats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsByCategory(
                          categoryID: cats[index],
                        ),
                      ),
                    );
                  },
                  title: Text(cats[index].name),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
