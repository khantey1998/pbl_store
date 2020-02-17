import 'package:flutter/material.dart';

class HelpCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Help Center",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              Card(
                elevation: 1,
                margin: const EdgeInsets.all(0.5),
                borderOnForeground: true,
                child: ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Address :'),
                  subtitle: Text(
                      "#88, St. 271, Sangkat Tek Tla, Khhan Sen Sok, Phnom Penh."),
                ),
              ),
              Card(
                elevation: 1,
                margin: const EdgeInsets.all(0.5),
                borderOnForeground: true,
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email: '),
                  subtitle: Text("info@pblstore.com"),
                ),
              ),
              Card(
                elevation: 1,
                margin: const EdgeInsets.all(0.5),
                borderOnForeground: true,
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Phone: '),
                  subtitle: Text("(+855) 95 888 488"),
                ),
              ),
              Card(
                elevation: 1,
                margin: const EdgeInsets.all(0.5),
                borderOnForeground: true,
                child: ListTile(
                  leading: Icon(Icons.timer),
                  title: Text('Open Time:'),
                  subtitle: Text(" 8:00AM - 6:00PM"),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text("© 2019 PBLStore."),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
