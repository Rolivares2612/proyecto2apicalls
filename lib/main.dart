import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Wikipedia search API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getSunData() async {
    var response = await http.get(Uri.parse("https://ghibliapi.herokuapp.com/species"));

    var jsonData = jsonDecode(response.body);

    List<Sun> suns = [];

    for (var u in jsonData) {
      Sun sunrises = Sun(u["id"], u["name"], u["classification"], u["eye_colors"], u["hair_colors"]);
      suns.add(sunrises);
    }
    return suns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyecto 2: API CALLS'),
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
            future: getSunData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(child: Text('Cargando: ')),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(snapshot.data[i].name),
                        subtitle: Text(snapshot.data[i].classification),
                        trailing: Text(snapshot.data[i].hair_colors),
                      );
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}

class Sun {
  final String id, name, classification, eye_colors, hair_colors;
  Sun(this.id, this.name, this.classification, this.eye_colors, this.hair_colors);
}
