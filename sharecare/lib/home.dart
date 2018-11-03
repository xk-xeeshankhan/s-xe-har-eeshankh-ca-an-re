import 'package:flutter/material.dart';
import 'package:sharecare/logout.dart';
import 'package:sharecare/order.dart';
import 'package:sharecare/resource.dart';
import 'package:sharecare/setting.dart';
import 'homeLayout/screen.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _bottomCurrentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 4);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: _bodySelection(),
      floatingActionButton: _floatButtonNewResource(),
      
    );
  }

  _floatButtonNewResource(){
    if(_bottomCurrentIndex==0){
      return FloatingActionButton(
        onPressed: (){
          _floatingButtonPressed();
        },
        child: Icon(Icons.add),
      );
    }
    return null;
  }

  _floatingButtonPressed(){
    Navigator.of(context).pushNamed('/newresource');
  }

  _bodySelection(){
    print(_bottomCurrentIndex);
    if(_bottomCurrentIndex==0){
      return _homeLayout();
    }else if(_bottomCurrentIndex==1){
      return Resource();
    }
    else if(_bottomCurrentIndex==2){
      return Order();
    }
    else if(_bottomCurrentIndex==3){
      return Setting();
    }
    else if(_bottomCurrentIndex==4){
      return Logout();
    }
    
  }

  _homeLayout(){
    //thing to remember the _tabController.index didnt get change we need to perform setState so we have
    //done the task directly by passing the index value else can create method change _tabController.index and then call Screen
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        Screen(0),
        Screen(1),
        Screen(2),
        Screen(3),
        
      ],
      
    );
  }

  _appBar() {
    return AppBar(
      title: Text(
        "Share & Care",
        style: TextStyle(color: Colors.white),
      ),
      elevation: 0.7,
      bottom: _bottomTabs(),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
    
  }

  _bottomTabs() {
    //home screen then display tabbar
    if (_bottomCurrentIndex == 0) {
      return TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        tabs: <Widget>[
          Tab(
            text: "SELL",
          ),
          Tab(
            text: "BID",
          ),
          Tab(
            text: "RENT",
          ),
          Tab(
            text: "DONATE",
          ),
        ],
      );
    }
    //else return null
    return null;
  }

  _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _bottomCurrentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _bottomNavigationBarTab,
      fixedColor: Colors.red,
      items: [
        BottomNavigationBarItem(title: Text("Home"), icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            title: Text("Resources"), icon: Icon(Icons.apps)),
        BottomNavigationBarItem(
            title: Text("Order"), icon: Icon(Icons.view_list)),
        BottomNavigationBarItem(
            title: Text("Setting"), icon: Icon(Icons.settings)),
        BottomNavigationBarItem(
            title: Text("Logout"), icon: Icon(Icons.power_settings_new)),
      ],
    );
  }

  _bottomNavigationBarTab(int index) {
    setState(() {
      _bottomCurrentIndex = index;
    });
  }

}
