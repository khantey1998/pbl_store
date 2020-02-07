import 'package:flutter/material.dart';
import 'package:pbl_store/models/product_model.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/models/category_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pbl_store/screens/product_detail.dart';

class ProductsByCategory extends StatefulWidget {
  final CategoryModel category;
  ProductsByCategory({Key key, @required this.category}) : super(key: key);
  @override
  _ProductsByCategoryState createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  String baseUrl = "http://3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@pblstore.com/api";
  _getRelatedProducts() async {
    List<ProductModel> filteredList = List();
    if (widget.category.associationModel.filterPs.length > 0) {
      for (int i = 0;
      i < widget.category.associationModel.filterPs.length;
      i++) {
        var res = await NetworkUtils.getSingleProduct(widget.category.associationModel.filterPs[i].id);
        filteredList.add(res);
      }
    }
    return filteredList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _getRelatedProducts(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            List<ProductModel> productList = snapshot.data;
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
                        padding: EdgeInsets.all(10.0),
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
                                '$baseUrl/images/products/${product.id.toString()}/${product.idDefaultImage}',
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
                              Text("\$${double.parse(product.price)}", style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
