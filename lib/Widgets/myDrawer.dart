import 'package:flutter/material.dart';
import 'package:malX/Address/addAddress.dart';
import 'package:malX/Authentication/authenication.dart';
import 'package:malX/Config/config.dart';
import 'package:malX/Orders/myOrders.dart';
import 'package:malX/Store/Search.dart';
import 'package:malX/Store/cart.dart';
import 'package:malX/Store/storehome.dart';
import 'package:malX/Widgets/theme.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget with ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeNotifire(),
      child: Consumer(builder: (context, ThemeNotifire notifire, child) {
        return Drawer(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.grey, Colors.green],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(60.0),
                      ),
                      elevation: 8.0,
                      child: Container(
                        height: 160.0,
                        width: 160.0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userAvatarUrl),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userName),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35.0,
                          fontFamily: "Signator"),
                    ),
                    Consumer<ThemeNotifire>(
                      builder: (context, ThemeNotifire notifire, child) =>
                          IconButton(
                              icon: notifire.darkTheme
                                  ? Icon(Icons.wb_sunny)
                                  : Icon(Icons.nights_stay),
                              onPressed: () {
                                notifire.ToggleTheme();
                              }),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                padding: EdgeInsets.only(top: 1.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.grey, Colors.green],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Home",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => StoreHome());
                        Navigator.push(context, route);
                      },
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.white,
                      thickness: 6.0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.reorder,
                        color: Colors.white,
                      ),
                      title: Text(
                        "My Orders",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => MyOrders());
                        Navigator.push(context, route);
                      },
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.white,
                      thickness: 6.0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      title: Text(
                        "My Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => CartPage());
                        Navigator.push(context, route);
                      },
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.white,
                      thickness: 6.0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Search",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => SearchProduct());
                        Navigator.push(context, route);
                      },
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.white,
                      thickness: 6.0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.add_location,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Add New Address",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => AddAddress());
                        Navigator.push(context, route);
                      },
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.white,
                      thickness: 6.0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        EcommerceApp.auth.signOut().then((value) {
                          Route route = MaterialPageRoute(
                              builder: (c) => AuthenticScreen());
                          Navigator.pushReplacement(context, route);
                        });
                      },
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.white,
                      thickness: 6.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
