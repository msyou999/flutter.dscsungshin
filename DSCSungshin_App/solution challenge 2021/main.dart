import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//앱 페이지
import 'event_page.dart';
import 'tip_page.dart';
import 'my_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firestore.instance
      .collection('userData')
      .document('ILMQl5nJoRBL7RlfLtrd').get().then((DocumentSnapshot ds){
        if( ds.data['firstrun'] == false ){
          Firestore.instance
              .collection('userData')
              .document('ILMQl5nJoRBL7RlfLtrd')
              .updateData({'firstrun': true});
          runApp(MaterialApp(home: initViewsample()));
        }
        else if(ds.data['firstrun']==true){
          runApp(MaterialApp(home: MyApp()));
        }
      });
  }



class initViewsample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Please choose an animal',
            style: TextStyle(color: Colors.green),
          ),
        ),
        body: initView());
  }
}

class initView extends StatefulWidget {
  @override
  _initViewState createState() => _initViewState();
}

class _initViewState extends State<initView> {
  final _valueList = ['Polar Bear', 'Elephant', 'Bengal tiger', 'Cheetah'];
  var _selectedValue = 'Polar Bear';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton(
                value: _selectedValue,
                items: _valueList.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                    if (value == 'Polar Bear') {
                      Firestore.instance
                          .collection('userData')
                          .document('ILMQl5nJoRBL7RlfLtrd')
                          .updateData({'animalNumber': 0});
                    } else if (value == 'Elephant') {
                      Firestore.instance
                          .collection('userData')
                          .document('ILMQl5nJoRBL7RlfLtrd')
                          .updateData({'animalNumber': 1});
                    } else if (value == 'Bengal tiger') {
                      Firestore.instance
                          .collection('userData')
                          .document('ILMQl5nJoRBL7RlfLtrd')
                          .updateData({'animalNumber': 2});
                    } else if (value == 'Cheetah') {
                      Firestore.instance
                          .collection('userData')
                          .document('ILMQl5nJoRBL7RlfLtrd')
                          .updateData({'animalNumber': 3});
                    }
                    else if (value == null){
                      Firestore.instance
                          .collection('userData')
                          .document('ILMQl5nJoRBL7RlfLtrd')
                          .updateData({'animalNumber': 0});
                    }
                  });
                },
              ),
              RaisedButton(
                child: Text('CHOICE!', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                color: Colors.lightGreen,
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
              ),
            ]),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        //하단 내비게이션바 배경색
        selectedItemColor: Colors.white,
        //하단 내비게이션바 선택된 아이콘색
        unselectedItemColor: Colors.white.withOpacity(.60),
        //선택되지 않은 아이콘색
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex,
        //현재 선택된 Index
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Event'),
            icon: Icon(Icons.watch),
          ),
          BottomNavigationBarItem(
            title: Text('Tips'),
            icon: Icon(Icons.book_rounded),
          ),
          BottomNavigationBarItem(
            title: Text('My Page'),
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  List _widgetOptions = [
    //각 함수 호출하여 화면 이동 -> 맡은 부분에 해당하는 함수에서 작업하시면 됩니다!
    Home(), //일단은 탭 순서대로 해놨어요! Home 함수만 해도 길이가 꽤 되니깐 ctrl+f로 함수 검색해서 찾아주세요
    Event(), //상단 appbar는 제가 통일하긴 했는데 그냥 생각나는 제목이 없어서 임의로 한거니깐 맡은 분들이 바꿔주세요
    Tips(),
    MyPage()
  ];
}

//선택한 동물 데이터
class Animal {
  int animalNumber; //동물 번호(0: 북극곰, 1: 코끼리, 2: 뱅갈호랑이, 3: 치타)

  Animal(this.animalNumber);
}

//챌린지 항목 데이터
class Challenge {
  String title; //챌린지 내용
  bool clear; //챌린지 클리어 여부
  int point; //챌린지에 부여된 행복 지수
  int iconNumber; //챌린지 아이콘

  Challenge(this.title, this.point, this.iconNumber, {this.clear = false});
}

//행복 지수 데이터
class Happiness {
  int point; //행복지수
  Happiness(this.point);
}

//하루가 지났는지 확인하고, 챌린지 및 행복지수 리셋을 위한 데이터
class UpdateDay {
  bool update = false;
  int count = 6;
  DateTime dt;
  bool display = false;

  UpdateDay({this.dt});
}

UpdateDay updateDay = new UpdateDay();


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //웃는 동물 사진 리스트
  var happyAnimalList = [
    'assets/happyAnimal0.png',
    'assets/happyAnimal1.png',
    'assets/happyAnimal2.png',
    'assets/happyAnimal3.png'
  ];

  //우는 동물 사진 리스트
  var sadAnimalList = [
    'assets/sadAnimal0.png',
    'assets/sadAnimal1.png',
    'assets/sadAnimal2.png',
    'assets/sadAnimal3.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Green Day',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            StreamBuilder<QuerySnapshot>(
              //행복지수, 동물 그림
              stream: Firestore.instance.collection('userData').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final document = snapshot.data.documents.first;
                return _buildItemWidget(document);
              },
            ),
            RaisedButton(
              // Week Challenge 버튼
              child: Text('Daily Challenge',
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              color: Colors.lightGreen,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WeekChallengePage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  //행복 지수, 동물 그림 버튼 위젯
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final happiness = Happiness(doc['point']);
    final animal = Animal(doc['animalNumber']);

    var now = new DateTime.now();
    updateDay.dt = new DateTime.fromMillisecondsSinceEpoch(
        doc['updateTime'].seconds * 1000);

    //하루가 지났을 경우, 날짜 변경 시간을 다음 날로 업데이트
    if (now.isAfter(updateDay.dt)) {
      //한 달이 지났을 경우(월이 달라질 경우) 메인 페이지 챌린지 횟수, 이벤트 횟수 초기화
      if (now.month != updateDay.dt.month) {
        Firestore.instance
            .collection('userData')
            .document(doc.documentID)
            .updateData({'monthlyCount': 0});
        Firestore.instance
            .collection('userData')
            .document(doc.documentID)
            .updateData({'monthlyCountE': 0});
      }
      Firestore.instance
          .collection('userData')
          .document(doc.documentID)
          .updateData({'point': 0});
      var up = doc['updateTime'].seconds + 86400;
      Firestore.instance
          .collection('userData')
          .document(doc.documentID)
          .updateData({'updateTime': Timestamp(up, 0)});
      Firestore.instance
          .collection('userData')
          .document(doc.documentID)
          .updateData({'updateTime': Timestamp(up, 0)});

      //후에 challenge 화면 불러올 때 초기화 해야함을 표시
      updateDay.update = true;
    }

    if (happiness.point < 100) {
      //행복지수가 100 미만일 때 슬픈 동물 사진 보이기
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 250,
              ),
              Text('Happiness: ${happiness.point}',
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
            ],
          ),
          Image.asset(
            sadAnimalList[animal.animalNumber],
            height: 400,
            width: 300,
          ),
        ],
      );
    } else {
      //행복지수가 100 이상일 때 행복한 동물 사진 보이기
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 250,
              ),
              Text('Happiness: ${happiness.point}',
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
            ],
          ),
          Image.asset(
            happyAnimalList[animal.animalNumber],
            height: 400,
            width: 300,
          ),
        ],
      );
    }
  }
}

class WeekChallengePage extends StatefulWidget {
  @override
  _WeekChallengePageState createState() => _WeekChallengePageState();
}

//데일리 챌린지 페이지
class _WeekChallengePageState extends State<WeekChallengePage> {
  //챌린지별 아이콘 리스트
  var iconList = [
    Icon(Icons.clear),
    Icon(Icons.access_alarm),
    Icon(Icons.airport_shuttle),
    Icon(Icons.wb_incandescent_outlined),
    Icon(Icons.wash_outlined),
    Icon(Icons.delete)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Daily Challenge',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: StreamBuilder<QuerySnapshot>(
              //유저데이터
                stream: Firestore.instance.collection('userData').snapshots(),
                builder: (context, snapshot1) {
                  if (!snapshot1.hasData) {
                    return CircularProgressIndicator();
                  }
                  return StreamBuilder<QuerySnapshot>(
                    //챌린지 데이터
                    stream:
                    Firestore.instance.collection('challenge').snapshots(),
                    builder: (context, snapshot2) {
                      if (!snapshot2.hasData) {
                        return CircularProgressIndicator();
                      }
                      final userDocument = snapshot1.data.documents.first;
                      final challengeDocuments = snapshot2.data.documents;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: challengeDocuments
                              .map((doc) => _buildItemWidget(doc, userDocument))
                              .toList(),
                        ),
                      );
                    },
                  );
                })),
      ),
    );
  }

  //챌린지 항목 위젯
  Widget _buildItemWidget(DocumentSnapshot doc, DocumentSnapshot doc2) {
    final challenge = Challenge(doc['title'], doc['point'], doc['iconNumber'],
        clear: doc['clear']);

    //하루가 지났을 경우, 챌린지의 clear를 false로 초기화
    if (updateDay.update) {
      updateDay.count--;
      if (updateDay.count == 0) {
        updateDay.update = false;
        updateDay.count = 6;
      }
      Firestore.instance
          .collection('challenge')
          .document(doc.documentID)
          .updateData({'clear': false});
      challenge.clear = doc['clear'];
    }

    //챌린지를 클리어 했다고 'ok'를 누를 경우 실행하는 함수
    clearChallenge() {
      // 챌린지 클리어 여부, 행복지수, 월별 챌린지 클리어 개수 갱신
      Firestore.instance
          .collection('challenge')
          .document(doc.documentID)
          .updateData({'clear': !doc['clear']});
      var point = doc2['point'];
      Firestore.instance
          .collection('userData')
          .document(doc2.documentID)
          .updateData({'point': point + doc['point']});
      Firestore.instance
          .collection('userData')
          .document(doc2.documentID)
          .updateData({'monthlyCount': 1 + doc2['monthlyCount']});
      Navigator.of(context).pop();
    }

    //클리어 여부에 따른 챌린지 화면 + 클릭 시 액션
    if (challenge.clear)
      //챌린지 클리어한 경우
      return InkWell(
          onTap: () {
            //클릭 시 액션
            var now = new DateTime.now();
            if (now.isAfter(updateDay.dt)) {
              //클릭했을 때 하루가 지난 경우
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('The day has been changed!'),
                        content: Text('Tap \'OK\' and return to Home screen.'),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()));
                              })
                        ]);
                  });
            } else {
              //클릭했을 때 하루가 지나지 않은 경우
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('You\'ve already completed this challenge!'),
                        content: Text('TAP \'OK\' and close this message.'),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ]);
                  });
            }
          },
          child: Padding(
            //챌린지 클리어 시 챌린지 화면
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      iconList[doc['iconNumber']],
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                          '${challenge.title}',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        'assets/challengeClear.png',
                        height: 60,
                        width: 60,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ));
    else {
      //챌린지 클리어하지 않은 경우
      return InkWell(
        onTap: () {
          //클릭 시 액션
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  //실수로 클릭 방지용 재확인
                  title: Text('Did you clear your challenges?'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('If you did it, tap \'OK\'. If not, tap \'CANCEL\''),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          var now = new DateTime.now();
                          if (now.isAfter(updateDay.dt)) {
                            //클릭했을 때 하루가 지난 경우
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text('The day has been changed!'),
                                      content: Text('TAP \'OK\' and return to Home screen.'),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyApp()));
                                            })
                                      ]);
                                });
                          } else {
                            //클릭했을 때 하루가 지나지 않은 경우
                            clearChallenge();
                          }
                        },
                        child: Text('OK')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('CANCEL')),
                  ],
                );
              });
        },
        child: Padding(
          //챌린지 클리어 하지 않았을 시 챌린지 화면
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    iconList[doc['iconNumber']],
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        '${challenge.title}',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Icons.tag_faces),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Happiness\n${challenge.point}+',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
    }
  }
}
