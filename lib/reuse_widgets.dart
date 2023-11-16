import 'package:flutter/material.dart';

class boatWidget extends StatelessWidget {
  const boatWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      color: Colors.red,
    );
  }
}

class truckWidget extends StatelessWidget {
  const truckWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      color: Colors.purple,
    );
  }
}