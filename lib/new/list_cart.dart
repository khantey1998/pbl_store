import 'package:flutter/material.dart';

// This app is a stateful, it tracks the user's current choice.
class ListCart extends StatefulWidget {
  @override
  _ListCartState createState() => _ListCartState();
}
class _ListCartState extends State<ListCart> {
  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Cart (1)",
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
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Card(
              borderOnForeground: true,
              margin: const EdgeInsets.all(0.5),
              elevation: 1.0,
              shape: Border(left: BorderSide(color: Colors.blue, width: 4)),
//              color: Colors.white70,
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: '',
                  ),
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
                              padding: EdgeInsets.all(10.0),
                              child:    Column(
                                children: <Widget>[
                                  Text(
                                    "Free Shipping",
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],

                              ),

                            ),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  new FloatingActionButton(
                                    onPressed: () {},
                                    mini: true ,
                                    child: new Icon(
                                        const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                                        color: Colors.black),
                                    backgroundColor: Colors.white70,
                                  ),
                                  new Text('1', style: new TextStyle(fontSize: 18.0,color: Colors.blue)),
                                  new FloatingActionButton(
                                    onPressed: () {},
                                    child: new Icon(Icons.add, color: Colors.black,),
                                    mini: true ,
                                    backgroundColor: Colors.white70,

                                  ),


                                ],
                              ),
                            ),
                          ],
                        )

                      ],
                    ),

                  ),

                ],


              ),
            ),
            Card(
              elevation: 1.0,
              child: Column(
                children: <Widget>[
                  Container(
                    child: ListTile(
                      title: Text(
                        "Secured Information Signing Up",
                      ),
                      leading: Icon(Icons.check_box),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text(
                        " Free Delivery for Phnom Penh",
                      ),
                      leading: Icon(Icons.directions_car),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text(
                        " 30-day Payback Warranty",
                      ),
                      leading: Icon(Icons.compare_arrows),
                    ),
                  ),
                ],
              )
            ),
            Container(
              padding:EdgeInsets.all(20.0) ,
              child: Text(
                "More to Love",
                style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black26,
                      width: 0.5,
                    ),

                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/plastocrete-plastocrete-n.jpg',
                        width: 150,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Text("Plastocrete"),
                      Text(
                        "US \$7.8",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),


                    ],
                  ),



                ),
                Container(
                  padding:EdgeInsets.all(10.0) ,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black26,
                      width: 0.5,
                    ),

                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                          'images/plastiment-r.jpg',
                          width: 150,
                          height: 200,
                          fit: BoxFit.fill
                      ),
                      Text("Plastiment R"),
                      Text(
                          "US \$81.00",
                          style: TextStyle(fontWeight: FontWeight.bold),
                      ),


                    ],
                  ),
                ),

              ],

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black26,
                      width: 0.5,
                    ),

                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/plastocrete-plastocrete-n.jpg',
                        width: 150,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Text("Plastocrete"),
                      Text(
                        "US \$7.8",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),


                    ],
                  ),



                ),
                Container(
                  padding:EdgeInsets.all(10.0) ,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black26,
                      width: 0.5,
                    ),

                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                          'images/plastiment-r.jpg',
                          width: 150,
                          height: 200,
                          fit: BoxFit.fill
                      ),
                      Text("Plastiment R"),
                      Text(
                        "US \$81.00",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                ),

              ],

            ),
          ],


        ),
      ),
    );
  }
  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.white,
              elevation: 0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                        value: 1,
                        groupValue: null,
                        onChanged: null
                    ),
                    Text("All"),
                  ],
                ),

              ),
            ),
             
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.white,
              elevation: 0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Total : US \$20",
                      style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: RaisedButton(
              onPressed: () {},
              color: Color(0xff01A0C7),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "CHECKOUT (1)",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
  const Choice(icon: Icons.clear),
  const Choice(icon: Icons.delete),

];

