import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_for_future/services/auth_service.dart';
import 'package:walk_for_future/pages/home_page.dart';
import 'package:walk_for_future/pages/register_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends  State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {

    AuthService _auth;
    _auth = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 63, 95, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 130,),
            Text("WALK FOR FUTURE",style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color:Color.fromRGBO(246, 213, 92, 1),),),
            SizedBox(height: 20,),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.blue,
                    )),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 20),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Email',
                    hintText: 'Enter valid email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.blue,
                    )),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 20),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(246, 213, 92, 1), borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  dynamic result = await context
                      .read<AuthService>()
                      .signInWith(
                          emailController.text.trim(),
                          passwordController.text.trim());
                  if (result != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(user: result)));
                    
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            MaterialButton(
              child: Text('New User? Create Account', style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
            ),
          ],
        ),
      ),
    );
  }


}
