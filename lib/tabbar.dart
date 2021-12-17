import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTabbar extends StatefulWidget {
  @override
  _MyTabbar createState() => _MyTabbar();
}

class _MyTabbar extends State<MyTabbar> with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final views = List.generate(
      3,
      (index) => Scaffold(
        appBar: AppBar(
          title: Text("View ${index + 1}"),
        ),
        body: Center(
          child: Text(
            "${index + 1}",
            style: TextStyle(fontSize: 50),
          ),
        ),
      ),
    );

    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          _wrap(
            context,
            DefaultTabController(length: views.length, child: _child1(views)),
          ),
          _wrap(
            context,
            DefaultTabController(length: views.length, child: _child2(views)),
          ),
          _wrap(
            context,
            DefaultTabController(
              length: views.length,
              child: _child3(context, views, _tabBar1()),
            ),
          ),
          _wrap(
            context,
            DefaultTabController(
              length: views.length,
              child: _child3(context, views, _tabBar2()),
            ),
          ),
          _wrap(
            context,
            DefaultTabController(
              length: views.length,
              child: _child3(context, views, _tabBar3()),
            ),
          ),
          _wrap(
            context,
            DefaultTabController(
              length: views.length,
              child: _child4(context, views, _tabBar3()),
            ),
          ),
          _wrap(
            context,
            _child5(context, views),
          ),
        ],
      ),
    ));
  }

  Widget _wrap(BuildContext context, Widget widget) {
    return Container(
      child: widget,
      padding: const EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _child1(List<Widget> views) {
    return Scaffold(
      body: TabBarView(
        children: views,
      ),
      appBar: AppBar(
        title: const Text("App Title"),
        bottom: _tabBar1(),
      ),
    );
  }

  Widget _child2(List<Widget> views) {
    return Scaffold(
      body: TabBarView(
        children: views,
      ),
      appBar: AppBar(
        bottom: _tabBar1(),
      ),
    );
  }

  Widget _child3(BuildContext context, List<Widget> views, TabBar tabBar) {
    return Scaffold(
      body: TabBarView(
        children: views,
      ),
      appBar: PreferredSize(
        preferredSize: tabBar.preferredSize,
        child: Card(
          elevation: 5.0,
          color: Theme.of(context).primaryColor,
          child: tabBar,
        ),
      ),
    );
  }

  Widget _child4(BuildContext context, List<Widget> views, TabBar tabBar) {
    return Scaffold(
      body: TabBarView(
        children: views,
      ),
      appBar: PreferredSize(
        preferredSize: tabBar.preferredSize,
        child: tabBar,
      ),
    );
  }

  Widget _child5(BuildContext context, List<Widget> views) {
    return Scaffold(
      body: TabBarView(
        controller: _controller,
        children: views,
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: _tabPageSelectogSelector(),
      ),
    );
  }

  TabBar _tabBar1() {
    return const TabBar(
      tabs: [
        Text("View 1"),
        Text("View 2"),
        Text("View 3"),
      ],
      indicatorWeight: 5.0,
    );
  }

  TabBar _tabBar2() {
    return TabBar(
      tabs: [
        SizedBox.shrink(),
        SizedBox.shrink(),
        SizedBox.shrink(),
      ],
      indicatorWeight: 5.0,
      automaticIndicatorColorAdjustment: true,
      indicatorColor: Colors.black,
    );
  }

  TabBar _tabBar3() {
    return TabBar(
      tabs: [
        for (int i = 0; i < 3; i++)
          Container(
            child: Text("View ${i + 1}"),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey,
            ),
          )
      ],
      labelColor: Colors.red,
      unselectedLabelColor: Colors.lightBlue,
      indicatorColor: Colors.blue,
    );
  }

  Widget _tabPageSelectogSelector() {
    return Center(
      child: TabPageSelector(
        controller: _controller,
        color: Colors.grey,
        selectedColor: Colors.purple,
        indicatorSize: 20,
      ),
    );
  }

  // TabBar _tabBar4(BuildContext context) {
  //   // return TabBar(
  //   //   tabs: [
  //   //     for (int i = 0; i < 3; i++)
  //   //       Container(
  //   //         child: SizedBox.shrink(),
  //   //         // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //   //         height: 10,
  //   //         width: 50,
  //   //         decoration: BoxDecoration(
  //   //           borderRadius: BorderRadius.circular(10),
  //   //           color: Colors.grey,
  //   //         ),
  //   //       )
  //   //   ],
  //   //   // indicator: BoxDecoration(
  //   //   //   borderRadius: BorderRadius.circular(10),
  //   //   //   backgroundBlendMode: BlendMode.clear,
  //   //   //   color: Colors.black,
  //   //   // ),
  //   // );
  //   final controller = DefaultTabController.of(context);
  //   if (controller == null) {
  //     throw Exception("no default tab controller");
  //   }

  //   return TabBar(
  //     tabs: [
  //       for (int i = 0; i < 3; i++)
  //         AnimatedBuilder(
  //           animation: controller.animation!,
  //           builder: (context, widget) {
  //             return Container(
  //               child: Text("View ${i + 1}"),
  //               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(12),
  //                 color: controller.index == i ? Colors.black : Colors.grey,
  //               ),
  //             );
  //           },
  //         )
  //     ],
  //   );
  // }
}
