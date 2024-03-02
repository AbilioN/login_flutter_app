import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage(Key key) : super(key: key);
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 240,
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Theme.of(context).primaryColorLight,
                      Theme.of(context).primaryColorDark,
                    ]),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                      blurRadius: 4,
                      color: Colors.black)
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Image(image: AssetImage('lib/ui/assets/logo.png')),
            ),
            Text(
              'Login'.toUpperCase(),
              textAlign: TextAlign.center,
              // style: Theme.of(context).textTheme.displayLarge,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            Form(
                child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                ElevatedButton(
                    onPressed: () {}, child: Text('Entrar'.toUpperCase())),
              ],
            ))
          ],
        ),
      ),
    );
    // throw UnimplementedError();
  }
}
