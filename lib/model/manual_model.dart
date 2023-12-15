import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Manual {
  const Manual(
      {required this.image, required this.title, required this.description});

  final String image;
  final String title;
  final String description;
}

class ManualTile extends StatelessWidget {
  const ManualTile({super.key, required this.manual});
  final Manual manual;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(manual.title),
              content: Container(
                width: 300,
                height: 300,
                child: Column(
                  children: [
                    Image.network(manual.image),
                    Text(manual.description),
                  ],
                ),
              ),
            );
          },
        );
      },
      title: Text(manual.title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
      subtitle: Text(manual.description),
      leading: Container(
        child: Image.network(manual.image),
        width: MediaQuery.of(context).size.width * 0.3,
      ),
    );
  }
}
