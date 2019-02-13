import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duo/user_profile_components/gird_images.dart';
import 'package:duo/components/user_detail.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final UsersData userData;
  final String userID, name;
  final DocumentSnapshot documentSnapshot;
  UserProfile({this.userData, this.userID, this.name, this.documentSnapshot})
      : assert(documentSnapshot != null);
  @override
  _UserProfileState createState() => new _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String imageUrl, name, email;
  Stream<QuerySnapshot> stream;
  @override
  void initState() {
    imageUrl = widget.documentSnapshot['profile_photo_url'];
    name = widget.documentSnapshot['user_name'];
    email = widget.documentSnapshot['user_name_id'];
    print(
        '${widget.documentSnapshot['user_name']}, ${widget.documentSnapshot['user_email_id']}, $imageUrl');
    super.initState();
  }

  Choice _selectedChoice = choices[0];
  int _crossAxisCount = 3;
  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          width: MediaQuery.of(context).size.width * .9,
          child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {},
                leading: CircleAvatar(),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.red,
        // actions: <Widget>[
        //   PopupMenuButton<Choice>(
        //     onSelected: _select,
        //     icon: Icon(Icons.notifications),
        //     itemBuilder: (BuildContext context) {
        //       return choices.skip(2).map((Choice choice) {
        //         return PopupMenuItem<Choice>(
        //           value: choice,
        //           child: Container(
        //               width: MediaQuery.of(context).size.width,
        //               child: Text(choice.title)),
        //         );
        //       }).toList();
        //     },
        //   ),
        // ],
      ),
      // primary: true,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
              // delegate: SliverChildBuilderDelegate((context, idnex) {
              child: SizedBox(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: CircleAvatar(
                                maxRadius: 40,
                                child: Image.network(imageUrl),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text('3'),
                                Text('Post'),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text('3'),
                                Text('Followers'),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text('33'),
                                Text('Following'),
                              ],
                            ),
                          ],
                        ),
                        widget.userData.getEmailId == widget.userID
                            ? Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.edit),
                                    ),
                                  ),
                                  Text('Edit'),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.black,
                                    child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        Firestore.instance
                                            .collection('activity_data')
                                            .document(widget.documentSnapshot[
                                                'user_email_id'])
                                            .collection(
                                                '${widget.documentSnapshot['user_email_id']}_followers_duo')
                                            .document(
                                                widget.userData.getEmailId)
                                            .setData(({
                                              'approved': false,
                                              'date_and_time': DateTime.now(),
                                              'follower_id':
                                                  widget.userData.getUserUid,
                                              'follower_name':
                                                  widget.userData.getUserName,
                                              'is_follower': false,
                                              'follower_email_id':
                                                  widget.documentSnapshot[
                                                      'user_email_id']
                                            }));
                                        Firestore.instance
                                            .collection('activity_data')
                                            .document(
                                                widget.userData.getEmailId)
                                            .collection('follow_requested_sent')
                                            .document(widget.documentSnapshot[
                                                'user_email_id'])
                                            .setData({
                                          'follower': false,
                                          'following': false,
                                          'date_and_time': DateTime.now(),
                                        });
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                  ),
                                  Text('Follow'),
                                ],
                              )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 20),
                  child: Text(name),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 20),
                    child: Text(
                      widget.userID,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                  onTap: () {
                    {}
                  },
                ),
                Container(
                  height: 40,
                ),
                Divider(),
                Center(
                  child: Text('Story'),
                )
              ],
            ),
          )
              // },
              //  childCount: 1),
              // viewportFraction: .95,
              ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(
                        top: BorderSide(color: Colors.black87, width: 1.0),
                        bottom: BorderSide(color: Colors.black87, width: 1.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _crossAxisCount = 1;
                        });
                      },
                      icon: Icon(Icons.grid_off),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _crossAxisCount = 3;
                        });
                      },
                      icon: Icon(Icons.grid_on),
                    )
                  ],
                ),
              ),
            ),
          ),
          GridImages(
            documentSnapshot: widget.documentSnapshot,
            crossAxisCount: _crossAxisCount,
          ),
          new SliverToBoxAdapter(
            child: new Container(height: 2.0, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];
