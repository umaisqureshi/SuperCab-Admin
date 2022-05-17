import 'package:flutter/material.dart';
import 'package:supercab_admin/UIScreen/Services.dart';
import 'package:supercab_admin/Utils/ReorderDateTime.dart';
import 'package:supercab_admin/Utils/constants.dart';
import 'package:supercab_admin/Utils/firebaseCredentials.dart';
import 'package:supercab_admin/Utils/model/PromoCodeModel.dart';


class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width / 1.5,
      child: Drawer(
        child: Container(
          color: yellow,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Container(
                  height: 30,
                  width: 20,
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 1.5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black)),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/users'),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.supervised_user_circle_sharp),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "All Users",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/post'),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/icons/promotion.png',
                          height: 20,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Text(
                          "Create Post",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () async
                    {
                      Navigator.of(context).pop(null);
                      Navigator.of(context).push(PromoCodeDataModal());
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.code,size: 20,),
                        SizedBox(
                          width: 18,
                        ),
                        Text(
                          "Promo Code",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () async
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Services()));
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.code,size: 20,),
                        SizedBox(
                          width: 18,
                        ),
                        Text(
                          "Services",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () {
                      FirebaseCredentials().auth.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/signIn', (route) => false);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.logout, color: Colors.black),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Log Out',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
