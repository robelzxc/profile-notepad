import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:final_project/api/api.dart';
import 'package:final_project/forms/note_form_page.dart';
import 'package:final_project/forms/user_form_page.dart';
import 'package:final_project/screens/home_page.dart';
import 'package:final_project/screens/note_page.dart';
import 'logout_page.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';


class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NotePageState();
}

class _NotePageState extends State<NavigationPage> {
  int _currentIndex = 0;
  var userData;

  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          children: const [
            NotePage(),
            ProfilePage(),
            LogoutPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index){
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(icon: Icon(Icons.note), title: Text('Notes')),
          BottomNavyBarItem(icon: Icon(Icons.photo_camera_front_sharp), title: Text('Profile')),
          BottomNavyBarItem(icon: Icon(Icons.arrow_forward_ios_sharp), title: Text('Logout')),
      ],),
    );
  }
}
