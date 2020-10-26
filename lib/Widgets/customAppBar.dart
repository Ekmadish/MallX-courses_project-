import 'package:flutter/material.dart';
import 'package:malX/Config/config.dart';
import 'package:malX/Counters/cartitemcounter.dart';
import 'package:malX/Store/cart.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.grey, Colors.green],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        centerTitle: true,
        title: Text(
          'MallX',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontFamily: 'Signatra'),
        ),
        bottom: bottom,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.push(context, route);
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.grey,
                ),
              ),
              Positioned(
                child: Stack(
                  children: [
                    Icon(
                      Icons.brightness_1,
                      size: 20,
                      color: Colors.red,
                    ),
                    Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 6.5,
                        child: Consumer<CartItemCounter>(
                            builder: (context, counter, _) {
                          return Text(
                            (EcommerceApp.sharedPreferences
                                        .getStringList(
                                            EcommerceApp.userCartList)
                                        .length -
                                    1)
                                .toString(),
                            // counter.count.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          );
                        })),
                  ],
                ),
              ),
            ],
          ),
        ]);
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
