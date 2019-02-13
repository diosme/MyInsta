import 'package:duo/components/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';

class CommentIcon extends StatefulWidget {
  @override
  _CommentIconState createState() => new _CommentIconState();
}

class _CommentIconState extends State<CommentIcon> {
  Widget _commentBuild(BuildContext context) {
    return Flexible(
        flex: 1,
        child: Container(
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(),
                    Text.rich(
                      TextSpan(
                        text: 'sasas',
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite),
                    )
                  ],
                );
              }),
        ));
  }

  Widget _buildComposeMessgRow() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: 'text'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: 200,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: IconButton(
        onPressed: () {
          showModalCustomBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  children: <Widget>[
                    _commentBuild(context),
                    Divider(),
                    _buildComposeMessgRow()
                  ],
                );
              });
        },
        icon: Icon(
          Icons.comment,
        ),
      ),
    );
  }
}
