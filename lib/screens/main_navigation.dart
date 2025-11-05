import 'package:flutter/material.dart';
import 'Home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentPageIndex = 0;

  late final PageController _pageController =
      PageController(initialPage: currentPageIndex);

  final List<Widget> pages = const [
    HomeScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavSelected(int index) {
    if (index == currentPageIndex) return; // No hacer nada si ya está en esa pestaña

    setState(() => currentPageIndex = index);

    if (_pageController.hasClients) {
      // 👇 Si el salto es mayor a 1, hacemos jumpToPage para evitar pasar por la intermedia
      if ((index - _pageController.page!.round()).abs() > 1) {
        _pageController.jumpToPage(index);
      } else {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

 @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      if (currentPageIndex != 0) {
        // Si no estamos en Home, navegamos a Home en vez de salir
        setState(() {
          currentPageIndex = 0;
          _pageController.jumpToPage(0);
        });
        return false; // Evitamos que se cierre la app
      }
      // Si ya estamos en Home, sí dejamos que se cierre
      return true;
    },
    child: Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: _onNavSelected,
        indicatorColor: const Color(0xFFA38350),
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2, color: Colors.white),
            label: 'Pedidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.white),
            label: 'Perfil',
          ),
        ],
      ),
    ),
  );
}
}