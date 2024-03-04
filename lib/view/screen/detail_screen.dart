import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/controller/api/api.dart';
import 'package:locate_me/view/screen/widgets/location_widget.dart';

class DetailScreen extends StatelessWidget {
  final String? currentAddress;
  const DetailScreen({required this.currentAddress, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              LocationWidget(currentAddress: currentAddress!.toString()),
              Expanded(
                child: Consumer(
                  builder: (context, watch, _) {
                    final userDataAsyncValue = watch.watch(userDataProvider);
                    return userDataAsyncValue.when(
                      data: (users) {
                        return ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(user.avatar.toString()),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "FirstName: ${user.first_name}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "LastName: ${user.last_name}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Email: ${user.email}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 15),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) => const Center(
                          child: Text(
                              "No data Available...Pleases try after sometime")),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
