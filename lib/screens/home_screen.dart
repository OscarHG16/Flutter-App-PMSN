import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
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
                  accountName : Text("Oscar Hurtado González"), 
                  accountEmail : Text("21030090@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/b/b4/Lionel-Messi-Argentina-2022-FIFA-World-Cup_%28cropped%29.jpg"),
                  ),
                  ),
                ListTile(
                  leading: Icon(Icons.social_distance_rounded),
                  title: Text("List Movies"),
                  subtitle: Text("Databse Movies"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, "/listdb"),
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
