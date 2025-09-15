import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController conUser = TextEditingController();
  TextEditingController conPwd = TextEditingController();
  bool isValidating = false;

  @override
  Widget build(BuildContext context) {
    final txtUser = TextField(
      keyboardType: TextInputType.emailAddress,
      controller: conUser,
      decoration: InputDecoration(hintText: "Correo Electrónico"),
    );

    final txtPwd = TextField(
      obscureText: true,
      controller: conPwd,
      decoration: InputDecoration(hintText: "Contraseña"),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(
          context,
        ).size.height, //Hacer responsiva la pantalla
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/BarcelonaLogo.jpeg"),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 65,
              child: Text(
                "FC BARCELONA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  height: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height * 0.23,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    txtUser,
                    txtPwd,
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 158, 27, 27),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Bordes redondeados
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 13,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isValidating = true;
                        });
                        Future.delayed(const Duration(milliseconds: 2000)).then(
                          (value) => Navigator.pushNamed(context, "/home"),
                        );
                      },
                      child: const Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                       ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 24, 27, 192),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Bordes redondeados
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 13,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isValidating = true;
                        });
                        Future.delayed(const Duration(milliseconds: 2000)).then(
                          (value) => Navigator.pushNamed(context, "/register"),
                        );
                      },
                      child: const Text(
                        "Registrarse!",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                       ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 300,
              child: isValidating
                  ? Lottie.asset(
                      'assets/Insider-loading.json',
                      height: 330,
                      width: 430
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
