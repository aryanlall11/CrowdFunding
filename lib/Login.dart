import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/main/admin_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.4),
          child: Column(
            children: [
              ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1,
                    vertical:
                        defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(providers: [
                              ChangeNotifierProvider(
                                create: (context) => MenuController(),
                              ),
                            ], child: AdminScreen())),
                  );
                },
                icon: Icon(Icons.admin_panel_settings_outlined),
                label: Text("Admin"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1,
                    vertical:
                        defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(providers: [
                              ChangeNotifierProvider(
                                create: (context) => MenuController(),
                              ),
                            ], child: MainScreen())),
                  );
                },
                icon: Icon(Icons.person_outline_outlined),
                label: Text("Users"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
