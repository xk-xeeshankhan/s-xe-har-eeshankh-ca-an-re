import 'package:flutter/material.dart';
import 'package:sharecare/Model/resource.dart';

class Resource extends StatefulWidget {
  _ResourceState createState() => _ResourceState();
}

class _ResourceState extends State<Resource> {
  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    return _displayRow();
  }

  _displayRow() {
    return ListView.separated(
      itemCount: resourceListAll.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                _detailNavigation(resourceListAll[index]);
              },
              leading: Image(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.fill,
                height: 60.0,
                width: 80.0,
              ),
              title: Text(
                resourceListAll[index].name,
                style: TextStyle(
                  fontSize: 18.0,
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
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.details),
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                    color: Colors.red,
                  ),
                ),
              ],
            )
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(
            height: 1.0,
            color: Colors.grey,
          ),
    );
  }

  _detailNavigation(resource) {}
}
