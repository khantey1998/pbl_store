import 'package:flutter/material.dart';
import 'package:pbl_store/models/product_model.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/models/category_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pbl_store/screens/product_detail.dart';
import 'package:pbl_store/models/cat_id.dart';

class ProductsByCategory extends StatefulWidget {
  final CategoryID categoryID;
  ProductsByCategory({Key key, @required this.categoryID}) : super(key: key);
  @override
  _ProductsByCategoryState createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  String baseUrl = "https://3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@pblstore.com/api";

  _getCategory(String categoryID) async {
    return await NetworkUtils.getOneCategory(categoryID);
  }

  _getRelatedProducts(CategoryModel categoryModel) async {
    List<ProductModel> filteredList = List();
    if (categoryModel.associationModel.filterPs.length > 0) {
      for (int i = 0; i < categoryModel.associationModel.filterPs.length; i++) {
        ProductModel res = await NetworkUtils.getSingleProduct(
            categoryModel.associationModel.filterPs[i].id);
        filteredList.add(res);
      }
    }
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        leading: Icon(Icons.arrow_back, color: Colors.black,),
        title: Text("${widget.categoryID.name}", style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: _getCategory(widget.categoryID.id),
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          if (snapShot.hasData) {
            CategoryModel category = snapShot.data;
            return FutureBuilder(
              future: _getRelatedProducts(category),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<ProductModel> productList = snapshot.data;
                  if(productList.length >0){
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: StaggeredGridView.count(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          padding: EdgeInsets.all(2),
                          children:
                          (productList.toList()..shuffle()).map((product) {
                            return Container(

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black26,
                                    width: 0.5,
                                  ),
                                ),
                                child: GestureDetector(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        imageUrl:
                                        '$baseUrl/images/products/${product.id.toString()}/${product.idDefaultImage}/small_default',
                                        placeholder: (context, url) =>
                                            Image.asset('assets/p.png'),
                                        width: 150,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(product.name),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "\$${double.parse(product.price)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailPage(
                                                  product: product,
                                                )));
                                  },
                                ));
                          }).toList(),
                          staggeredTiles: snapshot.data
                              .map<StaggeredTile>((_) => StaggeredTile.fit(2))
                              .toList(),
                          mainAxisSpacing: 3.0,
                          crossAxisSpacing: 4.0,
                        ),
                      ),
                    );
                  }
                  else{
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text("No Products For This Category"),
                      ),
                    );
                  }
                  
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            return Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
