import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.green));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  TabController controller;
  bool floating = true;
  bool pinned = true;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    controller.addListener(() {
      if (mounted) {
        setState(() {
          floating = controller.index != 2;
          pinned = controller.index != 2;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (_, innerBoxScrolled) {
              return [
                SliverAppBar(
                  floating: !floating,
                  pinned: !pinned,
                  title: Text('Danny'),
                  centerTitle: true,
                ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: floating,
                  delegate: _SliverPersistentHeaderDelegate(
                    TabBar(
                      controller: controller,
                      tabs: [
                        Tab(child: Text('CHAT', style: TextStyle(color: Colors.black))),
                        Tab(child: Text('STATUS', style: TextStyle(color: Colors.black))),
                        Tab(child: Text('CALLS', style: TextStyle(color: Colors.black))),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: controller,
              children: [
                ...List<Widget>.generate(
                  2,
                  (_) => ListView.separated(
                    itemCount: 50,
                    itemBuilder: (_, i) => _Item('$i'),
                    separatorBuilder: (_, __) => const Divider(),
                  ),
                ),
                Center(child: Text('No call history')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverPersistentHeaderDelegate(this._tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.transparent, child: _tabBar);
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _Item extends StatelessWidget {
  final String title;

  const _Item(this.title);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Professor', style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Hello engineer Danny'),
      leading: CircleAvatar(),
    );
  }
}
