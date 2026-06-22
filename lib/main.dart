import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
// import 'screens/calender_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '메인 일기',
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 42, 159, 165),
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        scaffoldBackgroundColor: Colors.white,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 86, 209, 191), // 파란 배경
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48), // 전체 너비, 높이 48
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  // final String title;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    MainScreen(),
    // CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: '메뉴 열기',
          ),
        ),
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Text(
                  '메뉴',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),

              _DrawerMenuItem(
                icon: Icons.book_outlined,
                label: '메인',
                isSelected: _selectedIndex == 0,
                onTap: () {
                  setState(() => _selectedIndex = 0); //
                  Navigator.of(context).pop();
                },
              ),

              //_DrawerMenuItem(
              //  icon: Icons.calendar_month_outlined,
              //  label: '캘린더',
              //  isSelected: _selectedIndex == 1,
              //  onTap: () {
              //    setState(() => _selectedIndex = 1);
              //    Navigator.of(context).pop();
              //  },
              //),
            ],
          ),
        ),
      ),

      body: IndexedStack(index: _selectedIndex, children: _screens),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 선택 여부에 따라 색상 분기
    final color = isSelected ? const Color(0xFF2979FF) : Colors.black54;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? const Color(0xFF2979FF) : Colors.black87,
        ),
      ),
      tileColor: isSelected ? const Color(0xFFE3EEFF) : null, // 선택 시 옅은 파란 배경
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      onTap: onTap,
    );
  }
}
