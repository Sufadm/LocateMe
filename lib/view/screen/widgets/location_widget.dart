import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    Key? key,
    required this.currentAddress,
  }) : super(key: key);

  final String? currentAddress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 247, 247, 247),
                  child: Icon(Icons.arrow_back))),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              height: 55,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.green,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentAddress ?? 'Unknown address',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
