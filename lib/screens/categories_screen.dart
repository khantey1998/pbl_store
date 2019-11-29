import 'package:flutter/material.dart';
import 'package:pbl_store/models/category_model.dart';
import 'package:pbl_store/utils/network_utils.dart';

class CategoryScreen extends StatefulWidget {
  @override
  CategoryState createState() {
    return CategoryState();
  }
}

class CategoryState extends State<CategoryScreen> {
  List<CategoryModel> categories;
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
        title: Image.asset(
          "assets/logo.jpg",
          width: 200,
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
            categories = snapshot.data;
            var cats = categories
                .where((cat) => cat.id != "2" && cat.id != "1")
                .toList();
            print(cats.length);
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    color: Colors.grey,
                  ),
              padding: EdgeInsets.all(0),
              itemCount: cats.length,
              itemBuilder: (context, index) {
                return ListTile(
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
