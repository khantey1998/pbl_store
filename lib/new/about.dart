import 'package:flutter/material.dart';
class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();

}
class _AboutUsState extends State<AboutUs>
    with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40.0,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "About Us",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
            children:[
              Image.asset(
                'images/AboutUs.png',
                width: 500,
                height: 250,
                fit: BoxFit.cover,
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child:  Text(
                  "OUR COMPANY",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),

                ),

              ),
              Container(
                margin: const EdgeInsets.only(left: 8,right: 8,top: 8),
                padding: const EdgeInsets.all(8.0),
                child:  Text("we have undertaken many projects of various scopes and sizes. All of our technical experts are the most experienced in their field,safety and environmental aspect by brand refinement with solutions based on our core capabilities to connect with a long-term and innovative approach to fit our customers’ needs."),
              ),
              _buildAboutUsWidgets(),


            ],


          ),
        ],
      ),

    );


  }
  _buildAboutUsWidgets() {
    TabController tabController = new TabController(length: 3, vsync: this);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.equalizer,
                      color: Colors.black,
                    ),
                    Text(
                      "Mission",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.visibility,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 3.0,
                    ),
                    Text(
                      "Vission",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.playlist_add_check,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 3.0,
                    ),
                    Text(
                      "What We Do",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            height: 200,
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                Text(
                  "Our mission is to provide our customers, our stockholders, with the greatest values in acquiring products, and provide the very best in quality, safety and services for our employee, based on only-one spirit.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Our vision is to be the leading construction company delivering the betterment of lifestyle, health, satisfaction, and conveniences through construction solutions and material selection.Our vision is to be the leading construction company, not only providing construction solution and materials, but creating a betterment of life through those processes.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Concrete Solution,Waterproofing Solution,Roofing Solution,Sealing and Bonding Solution,Flooring Solution,Concrete Compression solution,Drilling and Tunneling solution,Industrial and Home power tools supplier,Storage and Handling equipment supplier",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}