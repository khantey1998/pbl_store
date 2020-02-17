import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:pbl_store/screens/product_detail.dart';
import 'package:pbl_store/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pbl_store/screens/categories_screen.dart';
import 'package:pbl_store/screens/manufacturers_screen.dart';
import 'package:pbl_store/utils/network_utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> powerToolList;
  List<ProductModel> waterproofList;
  List<ProductModel> industrySupplyList;
  List<ProductModel> productList;
  String baseUrl = "http://3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@pblstore.com/api";
  var isLoading = false;

  @override
  void initState() {
    productList = List();
    powerToolList = List();
    waterproofList = List();
    industrySupplyList = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: FutureBuilder(
        future: NetworkUtils.getAllProducts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            productList = snapshot.data;
            for (ProductModel i in productList) {
              for (var j in i.associations.categories) {
                if (j.id == "4") {
                  powerToolList.add(i);
                } else if (j.id == "3") {
                  waterproofList.add(i);
                } else if (j.id == "5") {
                  industrySupplyList.add(i);
                }
              }
            }
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      height: 200,
                      child: Carousel(
                        images: [
                          Image.asset("assets/slide1.png"),
                          Image.asset("assets/slide2.png"),
                          Image.asset("assets/slide3.png"),
                          Image.asset("assets/slide4.png"),
                          Image.asset("assets/slide5.jpg")
                        ],
                        borderRadius: true,
                        radius: Radius.circular(5),
                        boxFit: BoxFit.scaleDown,
                        dotSize: 4.0,
                        dotIncreaseSize: 2,
                        dotSpacing: 15.0,
                        dotColor: Color(0xff333366),
                        indicatorBgPadding: 5.0,
                        dotBgColor: Colors.lightBlueAccent.withOpacity(0.2),
                        moveIndicatorFromBottom: 180.0,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryScreen()),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                                radius: 25,
                                child: Icon(
                                  Icons.list,
                                  size: 30,
                                ),
                                backgroundColor: Color(0xff009900)),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManufacturerScreen()),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 25,
                              child: Icon(
                                Icons.widgets,
                                size: 30,
                              ),
                              backgroundColor: Color(0xff00b200),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Brands",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 25,
                            child: Icon(
                              Icons.work,
                              size: 30,
                            ),
                            backgroundColor: Colors.blueAccent,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "New Arrived",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 25,
                            child: Icon(
                              Icons.access_alarm,
                              size: 30,
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Hot Deals",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/featured.png",
                            ),
                            fit: BoxFit.cover),
                        border: Border.all(
                            width: 1,
                            color: Colors.transparent,
                            style: BorderStyle.solid),),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "FEATURED PRODUCTS",
                          style: TextStyle(
                              color: Color(0xff333366),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 130,
                          child: ListView.builder(
                            itemCount: productList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '$baseUrl/images/products/${productList[index].id.toString()}/${productList[index].idDefaultImage}',
                                    placeholder: (context, url) =>
                                        Image.asset('assets/p.png'),
                                    fit: BoxFit.fitHeight,
                                    width: 130,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(
                                        product: productList[index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/bg2.jpg",
                            ),
                            fit: BoxFit.cover),
                        border: Border.all(
                            width: 1,
                            color: Colors.transparent,
                            style: BorderStyle.solid)),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "POWERTOOLS",
                          style: TextStyle(
                              color: Color(0xff333366),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 130,
                          child: ListView.builder(
                            itemCount: powerToolList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '$baseUrl/images/products/${powerToolList[index].id.toString()}/${powerToolList[index].idDefaultImage}',
                                    placeholder: (context, url) =>
                                        Image.asset('assets/p.png'),
                                    fit: BoxFit.fitHeight,
                                    width: 130,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailPage(
                                                product: powerToolList[index],
                                              )));
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/slide4.png",
                            ),
                            fit: BoxFit.cover),
                        border: Border.all(
                            width: 1,
                            color: Colors.transparent,
                            style: BorderStyle.solid)),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "WATERPROOF",
                          style: TextStyle(
                              color: Color(0xff333366),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 130,
                          child: ListView.builder(
                            itemCount: waterproofList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailPage(
                                                product: waterproofList[index],
                                              )));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '$baseUrl/images/products/${waterproofList[index].id.toString()}/${waterproofList[index].idDefaultImage}',
                                    placeholder: (context, url) =>
                                        Image.asset('assets/p.png'),
                                    fit: BoxFit.fitHeight,
                                    width: 130,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/industrial-supply.png",
                            ),
                            fit: BoxFit.cover),
                        border: Border.all(
                            width: 1,
                            color: Colors.transparent,
                            style: BorderStyle.solid)),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "INDUSTRIAL SUPPLY",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 130,
                          child: ListView.builder(
                            itemCount: industrySupplyList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailPage(
                                                product: waterproofList[index],
                                              )));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '$baseUrl/images/products/${industrySupplyList[index].id.toString()}/${industrySupplyList[index].idDefaultImage}',
                                    placeholder: (context, url) =>
                                        Image.asset('assets/p.png'),
                                    fit: BoxFit.fitHeight,
                                    width: 130,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "MORE YOU MAY LIKE",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),

                  Padding(
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
                  )
//          GridView.count(
//            physics: ScrollPhysics(),
//            shrinkWrap: true,
//            childAspectRatio: 0.65,
//            crossAxisCount: 2,
//            crossAxisSpacing: 2,
//            mainAxisSpacing: 2,
//            children: productList.map((product){
//              return Container(
//                padding: EdgeInsets.all(10.0),
//                decoration: BoxDecoration(
//                  border: Border.all(
//                    color: Colors.black26,
//                    width: 0.5,
//                  ),
//                ),
//                child: GestureDetector(
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
////                    Image.asset(
////                      'assets/photo2.jpg',
////                      width: 150,
////                      height: 200,
////                      fit: BoxFit.cover,
////                    ),
////                    FadeInImage(
////                      image: NetworkImage('$baseUrl/images/products/${product.id.toString()}/${product.idDefaultImage}', scale: 0.01),
////                      placeholder: AssetImage('assets/product.jpg'),
////                    ),
////
//                      CachedNetworkImage(
//                        imageUrl: '$baseUrl/images/products/${product.id.toString()}/${product.idDefaultImage}',
//                        placeholder: (context, url)=> Image.asset('assets/product.jpg'),
//                        height: 200,
//                        width: 150,
//                        fit: BoxFit.fitHeight,
//                      ),
//                      SizedBox(height: 10,),
//                      Text(product.name),
//                      Text(product.price),
//                    ],
//                  ),
//                  onTap: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => ProductDetailPage(product: product,)));
//                  },
//                )
//              );
//            }).toList(),
//          ),
                ],
              ),
            );
          } else {
            return Container(
                padding: EdgeInsets.all(50),
                child: Center(
                  child: CircularProgressIndicator(),
                ),);
          }
        },
      ),
    ));
  }
}
