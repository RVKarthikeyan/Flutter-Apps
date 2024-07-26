import 'package:flutter/material.dart';

import 'my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          //header
          const Padding(
            padding: EdgeInsets.only(top: 80),
            child: Text(
              "TNEA 2024 STATS",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          //Summary
          MyListTile(
            text: 'Summary',
            icon: Icons.summarize,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/summary_page.dart');
            },
          ),
          const SizedBox(
            height: 10,
          ),

          //Boardwise Registrations
          MyListTile(
            text: 'Boardwise Registrations',
            icon: Icons.book,
            onTap: () {},
          ),
          const SizedBox(
            height: 10,
          ),

          //Payments Category
          MyListTile(
            text: 'Payments-Category',
            icon: Icons.currency_rupee,
            onTap: () {},
          ),
          const SizedBox(
            height: 10,
          ),

          //District-Wise
          MyListTile(
            text: 'District-wise',
            icon: Icons.location_city,
            onTap: () {},
          ),
          const SizedBox(
            height: 10,
          ),

          //Gender-Wise
          MyListTile(
            text: 'Gender-wise',
            icon: Icons.male,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/gender_wise_page');
            },
          ),
          const SizedBox(
            height: 10,
          ),

          //Community-wise
          MyListTile(
            text: 'Community-wise',
            icon: Icons.people,
            onTap: () {},
          ),
          const SizedBox(
            height: 10,
          ),

          //Government School
          MyListTile(
            text: 'Government School',
            icon: Icons.school,
            onTap: () {},
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
