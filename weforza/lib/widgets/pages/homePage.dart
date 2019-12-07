import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberLoader.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/widgets/pages/memberList/memberListPage.dart';
import 'package:weforza/widgets/pages/rideList/rideListPage.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/generated/i18n.dart';

///This [Widget] represents the app landing page.
///It allows navigating between [RideListPage] and [MemberListPage].
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState(InjectionContainer.get<IMemberRepository>());
}

///This is the [State] class for [HomePage].
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin implements PlatformAwareWidget, MemberLoader {
  _HomePageState(this._memberRepository): assert(_memberRepository != null);

  final IMemberRepository _memberRepository;

  ///The selected index.
  int _selectedIndex = 0;
  
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    memberFuture = _memberRepository.getAllMembers();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [RideListPage(this),MemberListPage(this)],
        controller: _pageController,
        onPageChanged: (page){
          setState(() {_selectedIndex = page; });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index){
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 300),curve: Curves.easeInOut);
        },
        items: [
          BottomNavigationBarItem(
            title: Text(S.of(context).HomePageRidesTab),
            icon: Icon(Icons.directions_bike),
          ),
          BottomNavigationBarItem(
            title: Text(S.of(context).HomePageMembersTab),
            icon: Icon(Icons.people),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              children: [RideListPage(this),MemberListPage(this)],
              controller: _pageController,
              onPageChanged: (page){
                setState(() {_selectedIndex = page; });
              },
            ),
          ),
          CupertinoTabBar(
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.directions_bike)),
              BottomNavigationBarItem(icon: Icon(Icons.people)),
            ],
            onTap: (index){
              _pageController.animateToPage(index, duration: const Duration(milliseconds: 300),curve: Curves.easeInOut);
            },
          )
        ],
      )
    );
  }

  @override
  Future<List<Member>> memberFuture;
}