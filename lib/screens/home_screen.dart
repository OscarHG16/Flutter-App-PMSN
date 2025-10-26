import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pmsn20252/utils/value_listener.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Principal"),
        actions: [
          ValueListenableBuilder(
            valueListenable: ValueListener.isDark,
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(
                  value ? Icons.sunny : Icons.nightlight,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  ValueListener.isDark.value = !value;
                },
              );
            },
          ),
        ],
      ),
       drawer: Drawer( 
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName : Text("Oscar Hurtado González", style: TextStyle(color: Colors.black),), 
                  accountEmail : Text("21030090@gmail.com", style: TextStyle(color: Colors.black)),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSr_cYTLuRbjx4b7mUHkY4QYqxi3WqJ6C-9Aw&s"),
                  ),
                  ),
                ListTile(
                  leading: Icon(Icons.movie, color: Colors.black,),
                  title: Text("List Movies", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                  subtitle: Text("Databse Movies", style: TextStyle(fontSize: 20,  color: Colors.black)),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                  onTap: () => Navigator.pushNamed(context, "/listdb"),
                ),
                ListTile(
                  leading: Icon(Symbols.travel_luggage_and_bags, color: Colors.black,),
                  title: Text("Travels", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                  subtitle: Text("Database Travels", style: TextStyle(fontSize: 20,  color: Colors.black)),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                  onTap: () => Navigator.pushNamed(context, "/figma1"),
                ),
                ListTile(
                  leading: Icon(Symbols.sports_esports, color: Colors.black,),
                  title: Text("PS5", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                  subtitle: Text("PlayStation Store", style: TextStyle(fontSize: 20,  color: Colors.black)),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                  onTap: () => Navigator.pushNamed(context, "/ps_store"),
                ),
                ListTile(
                  leading: Icon(Symbols.movie, color: Colors.black,),
                  title: Text("List Api Movies", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                  subtitle: Text("API", style: TextStyle(fontSize: 20,  color: Colors.black)),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                  onTap: () => Navigator.pushNamed(context, "/api"),
                ),
              ],
            ),
          ),
      body: BottomBar(
        curve: Curves.decelerate,
        borderRadius: BorderRadius.circular(500),
        showIcon: true,
        barColor: Colors.black,
        width: 500,
        // Aquí va el contenido desplazable
        body: (context, controller) => Container(), // Quitamos el ListView.builder
        // Aquí va el menú inferior
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Home")),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Buscar")),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, "/figma1");
              },
            ),
            IconButton(
              icon: const Icon(Icons.sports_soccer, color: Colors.white),
              onPressed: (){
                Navigator.pushNamed(context, "/players");
              },
            ),
          ],
        ),
      ),
    );
  }
}
