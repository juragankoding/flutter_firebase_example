
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_example/binatang.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Firebase'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return WidgetListBinatang();
          }

          return WidgetNotification(
              message: "Tidak dapat mengkoneksikan dengan firebase !!");
        },
      ),
    );
  }
}

class ItemBinatang extends StatelessWidget {
  final Binatang binatang;
  const ItemBinatang({Key key, @required this.binatang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                this.binatang.nama,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  letterSpacing: 1.3,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                this.binatang.habitat,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 11,
                  letterSpacing: 0.3,
                ),
              )
            ],
          ),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              this.binatang.jumlah.toString(),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ))
        ],
      ),
    );
  }
}

class WidgetListBinatang extends StatelessWidget {
  const WidgetListBinatang({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference<Binatang> binatangs = FirebaseFirestore.instance
        .collection("binatang")
        .withConverter<Binatang>(
            fromFirestore: (snapshots, _) =>
                Binatang.fromJson(snapshots.data()),
            toFirestore: (binatang, _) => binatang.toJson());

    return StreamBuilder<QuerySnapshot<Binatang>>(
        stream: binatangs.snapshots(),
        builder: (contextStream, snapshotStream) {
          if (snapshotStream.connectionState == ConnectionState.active) {
            return ListView(
              children: List<Widget>.generate(
                  snapshotStream.data.size,
                  (index) => ItemBinatang(
                      binatang: snapshotStream.data.docs[index].data())),
            );
          }

          if (snapshotStream.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return WidgetNotification(
              message: "Terdapat kesalahan dalam pengambilan data");
        });
  }
}

class WidgetNotification extends StatelessWidget {
  final String message;

  const WidgetNotification({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(this.message),
        ],
      ),
    );
  }
}
