import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage(Key key) : super(key: key);
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Image(image: AssetImage('lib/ui/assets/logo.png')),
            ),
            Text('Login'.toUpperCase()),
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
