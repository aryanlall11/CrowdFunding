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
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              height: 100,
              width: 100,
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: new AssetImage('assets/images/logo.png'),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.circular(80.0),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: size.height * 0.4,
              width: size.width * 0.4,
              // padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Log in your respective user role",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1,
                        vertical: defaultPadding /
                            (Responsive.isMobile(context) ? 2 : 1),
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
                    label: Text("Admin Panel"),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1,
                        vertical: defaultPadding /
                            (Responsive.isMobile(context) ? 2 : 1),
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
                    label: Text("User Window"),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: size.height * 0.2,
              width: size.width * 0.15,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Team"),
                    Divider(
                      color: Colors.grey,
                    ),
                    Text("Aryan Lall"),
                    Text("Ritiz Saini"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
