import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walk_for_future/services/database.dart';
import 'package:walk_for_future/pages/home_page.dart';
import 'package:walk_for_future/widgets/loading.dart';
import 'package:walk_for_future/widgets/user.dart';

class EarnPrizesPage extends StatefulWidget {
  final int distance;
  final int stepCount;
  final double time;
  final int prizeCount;
  final UserFromFirebase user;

  const EarnPrizesPage(
      {Key key,
      @required this.distance,
      @required this.stepCount,
      @required this.time,
      this.user,
      @required this.prizeCount})
      : super(key: key);
  @override
  _EarnPrizesPageState createState() => _EarnPrizesPageState();
}

class _EarnPrizesPageState extends State<EarnPrizesPage> {
  bool isLoading = true;
  bool isEarning = false;
  UserData userData;
  int points;
  int setPrize = 0;
  final usersRef = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    getUserById();
  }

  getUserById() async {
    DocumentSnapshot doc = await usersRef.doc(widget.user.uid).get();
    userData = UserData.fromDocument(doc);
    if (userData.points != null) {
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    points = userData.points;
    setPrize = points + (widget.prizeCount);

        canEarn();
    //isLoading = true;
  }

  canEarn() async {
    if (widget.distance < 50 && widget.time > 0 && widget.stepCount < 50) {
      isEarning = true;
      //setPrize = points + widget.prizeCount;
      DocumentSnapshot doc = await usersRef.doc(widget.user.uid).get();
      userData = UserData.fromDocument(doc);
    if (userData != null) {
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
      await DatabaseService(uid: widget.user.uid)
          .updateUserData(userData.email, setPrize);
    }
  }

  Text canEarnPrizes() {
    if (widget.distance < 50 && widget.time > 0) {
      return Text(
        "Congrats you earned prize",
        style: TextStyle(fontSize: 24.0),
      );
    } else {
      return Text(
        "Sorry you did not earn a prize :( ",
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      );
    }
  }

  Icon canEarnPrizeIcon() {
    if (widget.distance < 50 && widget.time > 0) {
      return Icon(Icons.done_all, size: 200.0, color: Colors.green);
    } else {
      return Icon(
        Icons.clear,
        size: 200.0,
        color: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You earned ${widget.prizeCount} points :)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
                  canEarnPrizeIcon(),
                 /* Text("Distance Left : ${widget.distance}"),
                  //Text("Step Left : ${widget.stepCount}"),
                  Text("Time Left : ${widget.time}"),*/
                  canEarnPrizes(),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(user: widget.user)),
                      );
                    },
                    child: Text("Back To Home"),
                  )
                ],
              ),
            ),
          );
  }
}
