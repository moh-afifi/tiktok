import 'package:flutter/material.dart';


Widget MyAppBar(){
  List<Tab> tabs = [
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Football',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Funny',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Animals',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Music',
          style: TextStyle(color: Colors.red),
        ),
      ),
    )
  ];
  return AppBar(
    backgroundColor: Colors.black,
    elevation: 0,
    bottom: TabBar(
        labelStyle: TextStyle(fontSize: 12),
        labelColor: Color(0xFF8D60FF),
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.white,
        ),
        tabs: tabs),
  );
}

