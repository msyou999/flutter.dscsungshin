import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//정보&팁 페이지
class Tips extends StatefulWidget {
  @override
  _TipsState createState() => _TipsState();
}

//팁 클래스 선언 (DB에 사용할 필드)
class TipsInfo {
  String id;
  String title;
  String thumbnail;
  String main_img;

  TipsInfo(this.id, this.title, this.thumbnail, this.main_img);
}

class _TipsState extends State<Tips> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Tips',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              StreamBuilder<QuerySnapshot> (
                stream: Firestore.instance.collection('Tips').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final documents = snapshot.data.documents;
                  return Column(
                    children: documents.map((doc) => _buildItemWidget(doc)).toList(),
                  );
                },
              ),
              SizedBox( height: 30,),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget (DocumentSnapshot doc) {
    final tips = TipsInfo(doc['id'], doc['title'], doc['thumbnail'], doc['main_img']);
    var tipsId = tips.id;

    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => TipsDetail(tipsId: tipsId,))
      ),
      child: Column(
        children: <Widget>[
          Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      tips.thumbnail),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
        ],
      ),
    );
  }
}

//Tips 상세페이지
class TipsDetail extends StatefulWidget {
  final String tipsId;

  TipsDetail({@required this.tipsId});

  @override
  _TipsDetailState createState() => _TipsDetailState(tipsId: tipsId);
}



class _TipsDetailState extends State<TipsDetail> {

  var tipsId;
  _TipsDetailState({@required this.tipsId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Tips Detail',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: Firestore.instance.collection('Tips').document(tipsId).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData == false) {
                  return CircularProgressIndicator();
                }
                var tips = snapshot.data;
                return Center(
                  child: Column(
                    children: <Widget>[
                      Image.network(tips['main_img']),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
