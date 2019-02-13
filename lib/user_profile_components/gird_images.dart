import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GridImages extends StatefulWidget {
  final int crossAxisCount;
  final DocumentSnapshot documentSnapshot;
  GridImages({this.documentSnapshot, this.crossAxisCount = 3});
  @override
  _GridImagesState createState() => new _GridImagesState();
}

class _GridImagesState extends State<GridImages> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('media_storage_info')
              .where(
                'user_email_id',
                isEqualTo: widget.documentSnapshot['user_email_id'],
              )
              .orderBy('date_and_time', descending: true)
              .snapshots(),
          builder: (context, snap) {
            if (!snap.hasData)
              return SliverToBoxAdapter(
                child: Center(child: Text('wait')),
              );
            else {
              final l = snap.data.documents.length;
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.crossAxisCount,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    print('index:: $index');
                    final DocumentSnapshot documentSnapshot =
                        snap.data.documents[index];
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          showBottomSheet(
                              context: context,
                              builder: (context) {
                                return Material(
                                  child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(Icons.close),
                                          ),
                                          Divider(),
                                          AspectRatio(
                                            aspectRatio: .8,
                                            child: Center(
                                              child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Image.network(
                                                  documentSnapshot[
                                                      'uploaded_media_url'],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              });
                        },
                        child: documentSnapshot['uploaded_media_url'] != null
                            ? Image.network(
                                documentSnapshot['uploaded_media_url'],
                                fit: BoxFit.fill,
                              )
                            : Container(),
                      ),
                    );
                  },
                  childCount: l,
                ),
              );
            }
          }),
    );
  }
}
