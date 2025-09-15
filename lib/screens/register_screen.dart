import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Color barcaBlue = Color.fromARGB(255, 15, 30, 85);
  bool isValidating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, //Al sacar el teclado podemos hacer scroll para visualizar toda la pantalla
      backgroundColor: barcaBlue,
      body: SafeArea(
        child: SingleChildScrollView( //Sirve para dar scroll al sacar el teclado y visualizemos todo el contenido
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset("assets/Logo-Barcelona.png", height: 180),
              ),
              const SizedBox(height: 12),
              const Text(
                "Registro",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              //Apartado para el avatar
              Stack(
                children: [
                  //Circulo que mostrara el avatar elegido
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.person, //Icono de usuario
                        size: 60,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              //Boton para elegir el avatar
              Positioned(
                right:
                    MediaQuery.of(context).size.width *
                    0.35, //Se mueve para el centro
                top: 70,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //Campo para el nombre
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ), //Con EdgeInsets.symmetric(horizontal: 30) le decimos que nos de 30 de espacio de lado derecho e izquierdo
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Nombre completo",
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      //Esta es la apariencia cuando no tocamos la caja
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //Esta es la apariencia cuando tocamos la caja
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2, //Width lo have mas gruesa la letra
                      ),
                    ),
                    filled:
                        true, //Esto le dice a flutter que la caja puede tener un fondo
                    fillColor: Colors
                        .transparent, //Aqui se controla el color del fondo
                  ),
                  style: TextStyle(
                    color: Colors
                        .white, //Le damos color a las letras que estan en la caja
                  ),
                ),
              ),
              const SizedBox(height: 15),

              //Campo para la contraseña
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  obscureText: true, //Ocultamos la contraseña
                  decoration: InputDecoration(
                    hintText: "Contraseña",
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),

              //Campo para el correo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Correo",
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),

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
                    horizontal: InspectorButton.buttonSize,
                    vertical: 13,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isValidating = true;
                  });
                  Future.delayed(
                    const Duration(milliseconds: 1000),
                  ).then((value) => Navigator.pushNamed(context, "/login"));
                },
                child: const Text(
                  "Registrarse",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),

              TextButton(
                onPressed: () {
                  setState(() {
                    isValidating = true;
                  });
                  Future.delayed(
                    const Duration(milliseconds: 1000),
                  ).then((value) => Navigator.pushNamed(context, "/login"));
                },
                child: const Text(
                  "¿Ya tienes cuenta? Inicia sesión",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
