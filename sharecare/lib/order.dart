import 'package:flutter/material.dart';
import 'package:sharecare/Model/resource.dart';

class Order extends StatefulWidget {
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return ListView.separated(
      itemCount: resourceListAll.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: 200.0,
              ),
              ListTile(
                title: Text(
                  resourceListAll[index].name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      Expanded(
                        child: Text(
                          resourceListAll[index].status,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          resourceListAll[index].price.toString(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
            height: 1.0,
            color: Colors.grey,
          ),
    );
  }
}
