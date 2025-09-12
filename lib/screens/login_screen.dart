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
              bottom: 80,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    txtUser,
                    txtPwd,
                    IconButton(
                      onPressed: () {
                        isValidating = true;
                        setState(() {});
                        Future.delayed(Duration(milliseconds: 2000)).then(
                          (value) => Navigator.pushNamed(
                            context,
                            "/home",
                          ), //se usa para navegar entre pantallas con el nombre de las rutas
                        );
                        // Aquí puedes agregar la lógica del login
                        print('Botón presionado');
                      },
                      icon: Icon(
                        Icons.login,
                      ), // Corregido: así es como se define un icono
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context, "/register"); //Al presionar el boton nos manda a la pantalla de registro
                      },
                      child: const Text("¿No tienes cuenta?, Registrate"),
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 300,
              child: isValidating
                  ? Lottie.asset(
                      'assets/Loading 40 _ Paperplane.json',
                      height: 330,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
