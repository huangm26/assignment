import 'package:affirm_assignment/model/business.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BusinessCard extends StatefulWidget {
  final Business business;
  final double elevation;

  const BusinessCard({this.business, this.elevation});

  @override
  _BusinessCardState createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  final BorderRadius _cornerRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: _cornerRadius
      ),
      child: Stack(
        children: [
          Center(
            child: widget.business.imageUrl?.isNotEmpty == true ? ClipRRect(
              borderRadius: _cornerRadius,
              child: CachedNetworkImage(
                imageUrl: widget.business.imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ) : Container(
              width: 400,
              height: 300,
              alignment: Alignment.center,
              child: Text(
                'No Image available'
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Chip(
                backgroundColor: Colors.black,
                label: Text(
                  widget.business.rating.toString(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  widget.business.name,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
