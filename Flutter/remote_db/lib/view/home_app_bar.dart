import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 5, top: 25, right: 0, bottom: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.sort,
              size: 30,
              color: Color(0xFF4C53A5),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: Text(
              "RemoteDB",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
