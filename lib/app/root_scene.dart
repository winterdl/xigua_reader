import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xigua_read/app/sq_color.dart';
import 'package:xigua_read/app/user_manager.dart';
import 'package:xigua_read/base/structure/base_view.dart';
import 'package:xigua_read/base/structure/base_view_model.dart';
import 'package:xigua_read/bookshelf/bookshelf_scene.dart';
import 'package:xigua_read/home/home_scene.dart';
import 'package:xigua_read/me/me_scene.dart';
import 'package:xigua_read/utility/event_bus.dart';

import '../global.dart';
import 'constant.dart';

class RootScene extends BaseStatefulView {
  @override
  BaseStatefulViewState<BaseStatefulView<BaseViewModel>, BaseViewModel> buildState() {
    return RootSceneState();
  }

}

class RootSceneState extends BaseStatefulViewState<RootScene, BaseViewModel>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  bool isFinishSetup = false;
  List<Image> _tabImages = [
    Image.asset('img/tab_bookshelf_n.png'),
    Image.asset('img/tab_bookstore_n.png'),
    Image.asset('img/tab_me_n.png'),
  ];

  List<Image> _tabSelectedImages = [
    Image.asset('img/tab_bookshelf_p.png'),
    Image.asset('img/tab_bookstore_p.png'),
    Image.asset('img/tab_me_p.png'),
  ];

  @override
  void initState() {
    super.initState();

    // 开始
    setupApp();

    eventBus.on(EventUserLogin, (arg) {
      setState(() {});
    });

    eventBus.on(EventUserLogout, (arg) {
      setState(() {});
    });

    eventBus.on(EventToggleTabBarIndex, (arg) {
      setState(() {
        _tabIndex = arg;
      });
    });

  }

  @override
  void dispose() {
    eventBus.off(EventUserLogin);
  }

  setupApp() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isFinishSetup = true;
    });
  }

  Image getTabIcon(int index) {
    if (index == _tabIndex) {
      return _tabSelectedImages[index];
    } else {
      return _tabImages[index];
    }
  }

  @override
  Widget buildView(BuildContext context, BaseViewModel viewModel) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("测试"),
//      ),
      body: IndexedStack(
        children: [
          BookshelfScene(),
          HomeScene(),
          MeScene(),
        ],
        index: _tabIndex,

      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: SQColor.primary,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: getTabIcon(0), title: Text('书架')),
          BottomNavigationBarItem(icon: getTabIcon(1), title: Text('书城')),
          BottomNavigationBarItem(icon: getTabIcon(2), title: Text('我的')),
        ],
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },

      ),
    );
  }

  @override
  BaseViewModel buildViewModel(BuildContext context) {
    // TODO: implement buildViewModel
    return null;
  }

  @override
  void initData() {
    // TODO: implement initData
  }

  @override
  void loadData(BuildContext context, BaseViewModel viewModel) {
    // TODO: implement loadData
  }
}

