import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_for_future/services/auth_service.dart';
import 'package:walk_for_future/pages/home_page.dart';

final DateTime timestamp = DateTime.now();

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email;
  String _password;
  final TextEditingController controller = TextEditingController();
  AuthService _auth;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 63, 95, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 130,),
            Text("REGISTER",style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color:Color.fromRGBO(246, 213, 92, 1),),),
            SizedBox(height: 50,),
            Text("WALK FOR FUTURE",style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color:Color.fromRGBO(246, 213, 92, 1),),),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.blue,
                    )),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 20),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.blue,
                    )),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 20),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: MaterialButton(
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () async {

                    dynamic result = await context
                        .read<AuthService>()
                        .registerWith(
                            _email.trim(),
                            _password.trim(),);
                    if (result != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(user: result)));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
