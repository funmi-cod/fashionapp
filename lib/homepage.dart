import 'package:designapp/auth.dart';
import 'package:designapp/profile/profile_settings.dart';
import 'package:designapp/utils/recom_pics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({required this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<String> categoryList = ['Recommendation', 'New Models', '2021 Show'];
  bool _isSigningOut = false;
  int selectedIndex = 0;
  late final String avatarUrl = '';
  late User _currentUser;
  var menuList = ['Settings', 'Sign out'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: PopupMenuButton(
          elevation: 40,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          icon: Icon(
            Icons.menu_rounded,
            color: Colors.black45,
          ),
          enabled: true,
          onSelected: (value) async {
            if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(user: widget.user),
                ),
              );
            } else if (value == 2) {
              _isSigningOut
                  ? CircularProgressIndicator()
                  : setState(() {
                      _isSigningOut = true;
                    });
              await FirebaseAuth.instance.signOut();
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Auth(),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text(
                'Settings',
                style: TextStyle(
                    color: Color(0xff8705bf),
                    fontSize: 16,
                    fontWeight: FontWeight.w200),
              ),
              value: 1,
            ),
            PopupMenuItem(
              child: Text(
                'Sign out',
                style: TextStyle(
                    color: Color(0xff8705bf),
                    fontSize: 16,
                    fontWeight: FontWeight.w200),
              ),
              value: 2,
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_rounded,
              color: Colors.black45,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Fashion Week',
                  style: TextStyle(
                    color: Color(0xff8705bf),
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                Text(
                  '2021 Fashion show in paris',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          'Explore',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 1,
                          ),
                        ),
                        SizedBox(
                          width: 270,
                        ),
                        Icon(
                          Icons.swap_horiz_rounded,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    categoryList.length,
                    (index) => GestureDetector(
                      onTap: () => setState(() {
                        selectedIndex = index;
                      }),
                      child: Text(
                        categoryList[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: selectedIndex == index
                              ? FontWeight.w400
                              : FontWeight.w200,
                          color: selectedIndex == index
                              ? Color(0xff8705bf)
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mainColumn.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: 200,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.asset(
                                    'images/' + mainColumn[index].pic,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              mainColumn[index].name,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              mainColumn[index].place,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: 100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'images/model2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
