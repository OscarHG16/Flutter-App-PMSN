import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Color barcaBlue = Color.fromARGB(255, 15, 30, 85);
  bool isValidating = false;

  final _formKey = GlobalKey<FormState>();

  File? avatar; // Para guardar la imagen seleccionada
  final ImagePicker picker = ImagePicker();

  //METODOS
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        avatar = File(pickedFile.path);
      });
    }
  }


  //Funcion para el estilo de los campos y no estar repitiendo en cada uno el mismo estilo solo lo mandamos a llamar y le pasamos el parametro del texto que queremos que se visualize
  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      //Esta es la apariencia cuando no tocamos la caja
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.white70),
      ),
      //Esta es la apariencia cuando hacemos click en la caja
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.white, width: 2), //Width lo have mas gruesa la letra
      ),
      filled: true, //Esto le dice a flutter que la caja puede tener un fondo
      fillColor: Colors.transparent, //Aqui se controla el color del fondo
    );
  }

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
                      radius: 70,
                      backgroundColor: Colors.white24,
                      backgroundImage: avatar != null ? FileImage(avatar!) : null,
                      child: avatar == null
                        ? const Icon(Icons.person, size: 60, color: Colors.white70)
                        : null
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              //Boton para elegir el avatar
              Positioned(
                right: MediaQuery.of(context).size.width * 0.35,
                top: 70,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (modalContext) => Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text("Galería"),
                              onTap: () {
                                Navigator.pop(modalContext);
                                pickImage(ImageSource.gallery);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("Cámara"),
                              onTap: () {
                                Navigator.pop(modalContext);
                                pickImage(ImageSource.camera);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //Campo para el nombre
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ), //Con EdgeInsets.symmetric(horizontal: 30) le decimos que nos de 30 de espacio de lado derecho e izquierdo
                      child: TextFormField(
                        decoration: buildInputDecoration("Nombre completo"),
                        style: TextStyle(
                          color: Colors
                              .white, //Le damos color a las letras que estan en la caja
                        ),
                        validator: (value) {
                          if(value ==  null || value.isEmpty){
                            return "El nombre no puede estar vacio";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),

                    //Campo para la contraseña
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        obscureText: true, //Ocultamos la contraseña
                        decoration: buildInputDecoration("Contraseña"),
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return "La contraseña no puede estar vacia";
                          }
                          if (value.length < 6){
                            return "La contraseña debe tener minimo 6 caracteres";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),

                    //Campo para el correo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        decoration: buildInputDecoration("Correo"),
                        style: TextStyle(color: Colors.white),
                        
                      ),
                    ),
                  ],
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
