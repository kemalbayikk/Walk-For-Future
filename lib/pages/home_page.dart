import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walk_for_future/widgets/loading.dart';
import 'package:walk_for_future/pages/maps.dart';
import 'package:walk_for_future/widgets/user.dart';

class HomePage extends StatefulWidget {
  final UserFromFirebase user;

  const HomePage({Key key, this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  UserData userData;
  int points;
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
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        :Scaffold(
          backgroundColor: Color.fromRGBO(23, 63, 95, 1),
      body: Container(
        alignment: Alignment.center,
          child: Center(
          
        child: Column(

          children: [
            SizedBox(height: 50),
                Align(
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: Text("You Have $points Points So Far", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24.0),),
                  ),
                ),
                SizedBox(height: 250),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Center(
                    child: Text("Welcome To Walk For Future", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24.0),),
                  ),
                ),
          RaisedButton(
            child: Text("Please Select Location Where You Will Walk",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textDirection: TextDirection.ltr),
            color: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Maps(user: widget.user,)),
              );
            },
            ),
              ],
        ),
      )),
    );
  }
}
