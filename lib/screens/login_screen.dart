import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pmsn20252/firebase/fire_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController conUser = TextEditingController();
  TextEditingController conPwd = TextEditingController();
  bool isValidating = false;
  FireAuth? fireAuth;

  @override
  void initState() {
    super.initState();
    fireAuth = FireAuth();
  }

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
                      onPressed: () async {
                        if(conUser.text.isEmpty || conPwd.text.isEmpty){ //Se revisa si los campos estan vacios 
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Favor de llenar ambos campos"),
                            backgroundColor: Colors.orange,
                            )
                          );
                          return;
                        }
                        setState(() {
                          isValidating = true;
                        });
                        //Colocaremos todos los casos de uso que se puedan presnetar
                        try{
                          //Caso 1 es que intentamos iniciar sesion 
                          final user = await fireAuth!.signInWithEmailAndPassword(
                            conUser.text,
                            conPwd.text
                            );

                            if(user != null){
                              Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Correo o contraseña incorrectos"),
                                backgroundColor: Colors.red,
                              )
                              );
                            }
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erro ${e.toString()}"),
                            backgroundColor: Colors.red,
                            )
                          );
                        }finally{
                          setState(() {
                            isValidating = false;
                          });
                        }
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
                      onPressed: () async {
                        setState(() {
                          isValidating = true;
                        });
                        await Future.delayed(const Duration(milliseconds: 1000)).then(
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
