import 'package:flutter/material.dart';

// This app is a stateful, it tracks the user's current choice.
class ListOrder extends StatefulWidget {
  @override
  _ListOrderState createState() => _ListOrderState();
}
class _ListOrderState extends State<ListOrder> {
  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final  comFirmOrderRecieveButon= Material(
      elevation: 1.0,
      borderRadius: BorderRadius.circular(1.0),
      color: Colors.red,
      child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text(
          "Comfirm Order Recieve".toUpperCase(),style: TextStyle(color: Colors.white,),
          textAlign: TextAlign.center,
        ),
      ),

    );
    final  statusButon= Material(
      elevation: 1.0,
      borderRadius: BorderRadius.circular(1.0),
      color: Color(0xffffcccc),
      child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text(
          "Processing in progress".toUpperCase(),style: TextStyle(color: Colors.redAccent,),
          textAlign: TextAlign.center,
        ),
      ),

    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "My Orders",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              choices[0].icon,
              size: 25.0,
              color: Colors.grey,
            ),
            onPressed: () {
              _select(choices[0]);
            },

          ),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(choices[1].icon),
              color: Colors.grey,
              onPressed: () {
                _select(choices[1]);
              },
            ),

          ],

        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black26,
                  width: 0.5,
                ),
              ),
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Order ID: "),
                        Text("LDJIGBAJT",style: TextStyle(fontWeight: FontWeight.bold),),
                      ],

                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Order Date: "),
                        Text("10/07/2019",style: TextStyle(fontWeight: FontWeight.bold),),
                      ],

                    ),
                  ),
                  Card(
                    borderOnForeground: true,
                    margin: const EdgeInsets.all(0.5),
                    elevation: 0.0,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/waste-bin-with-cover-120lit.jpg',
                          fit: BoxFit.fitHeight,
                          width: 100,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Card(
                                elevation: 0.0,
                                borderOnForeground: false,
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: ListTile(
                                  title: Text('Waste Bin with Cover 120lit',style: TextStyle(fontSize: 16.0,),),
                                  subtitle:Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        "US \$20",
                                        style: TextStyle(fontSize: 14.0, color: Colors.black,fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        "US \$33",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        "30% Off",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.red,
                                        ),
                                      ),

                                    ],

                                  ),



                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(Icons.print,color: Colors.blue,),
                                  ),
                                ],
                              )

                            ],
                          ),

                        ),

                      ],


                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Quantity: "),
                        Text("1",style: TextStyle(fontWeight: FontWeight.bold),),
                      ],

                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Total Amount: "),
                        Text("US \$20",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,),),
                      ],

                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        statusButon,
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        comFirmOrderRecieveButon,
                      ],
                    ),
                  )
                ],
              ),
            ),

          ],


        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(icon: Icons.arrow_back),
  const Choice(icon: Icons.search),

];

