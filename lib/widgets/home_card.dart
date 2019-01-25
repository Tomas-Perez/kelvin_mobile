import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String image;
  final String title;
  final GestureTapCallback onTap;

  const HomeCard({
    Key key,
    @required this.image,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          _makeCard(context),
          _onClickEffect(),
        ],
      ),
    );
  }

  Widget _makeCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(image),
              ),
            ),
          ),
          ListTile(
            title: Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ],
      ),
    );
  }

  Widget _onClickEffect() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        child: Container(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
