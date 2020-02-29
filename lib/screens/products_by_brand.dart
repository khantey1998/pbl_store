import 'package:flutter/material.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/models/manufacturer_model.dart';
import 'package:pbl_store/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pbl_store/screens/product_detail.dart';

class ProductsByBrand extends StatefulWidget {
  final ManufacturerModel manufacturerModel;
  ProductsByBrand({Key key, @required this.manufacturerModel})
      : super(key: key);

  @override
  _ProductsByBrandState createState() => _ProductsByBrandState();
}

class _ProductsByBrandState extends State<ProductsByBrand> {
  String baseUrl = "https://3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@pblstore.com/api";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text("${widget.manufacturerModel.name}", style: TextStyle(color: Colors.black),),

      ),
      body: FutureBuilder(
        future: NetworkUtils.getAllProducts(),
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          if (snapShot.hasData) {
            List<ProductModel> productList = List();
            List<ProductModel> productListFiltered = List();
            productList = snapShot.data;
            for (ProductModel p in productList) {
              if (int.parse(p.idManufacturer) ==
                  int.parse(widget.manufacturerModel.id)) {
                productListFiltered.add(p);
              }
            }
            if (productListFiltered.length > 0) {
              return Padding(
                padding: EdgeInsets.all(4),
                child: StaggeredGridView.count(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  padding: EdgeInsets.all(2),
                  children: productListFiltered.map((product) {
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: product,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  staggeredTiles: snapShot.data
                      .map<StaggeredTile>((_) => StaggeredTile.fit(2))
                      .toList(),
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 4.0,
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: Text("No product for this brand"),
                ),
              );
            }
          } else {
            return Container(
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
