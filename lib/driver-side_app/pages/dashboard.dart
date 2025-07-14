
import 'package:failedtoconnect/driver-side_app/pages/payment.dart';
import 'package:failedtoconnect/driver-side_app/pages/profile.dart';
import 'package:failedtoconnect/driver-side_app/pages/trips.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> with SingleTickerProviderStateMixin
{
  TabController? controller;
  int indexSelected = 0;
  clickbar(int i)
  {
    setState(() {
      indexSelected = i;
      controller!.index = indexSelected;
    });
  }
  @override
  void initState(){
    super.initState();
    controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            home(),
            Payment(),
            trips(),
            Profile(),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.credit_card),
                label: "Payment"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_tree_outlined),
                label: "Trips"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "profile"
            )
          ],
          currentIndex: indexSelected,
         // backgroundColor: Colors.grey,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.purple,
          showSelectedLabels: true,
          selectedLabelStyle: TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          onTap: clickbar,
        ),
      ),
    );

  }
}
