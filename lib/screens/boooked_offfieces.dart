import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:office_rental/models/booking.dart';
import 'package:office_rental/providers/booking_provider.dart';
import 'package:office_rental/providers/download.dart';
import 'package:office_rental/utils/constants.dart';
import 'package:provider/provider.dart';

class BookedOffice extends StatelessWidget {
  const BookedOffice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Booked Offices",
          style: TextStyle(fontSize: 16),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks),
            label: 'Offices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more),
            label: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<OfficeReservation>>(
                future: bookingProvider.getUserBookings(context: context, "23"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        children: [
                          const Icon(Icons.warning),
                          const Text("Failed to load data"),
                          const Text(
                            "Please connect to the internet and try again",
                          ),
                          Text("${snapshot.error}"),
                        ],
                      ),
                    );
                  } else {
                    final data = snapshot.data;
                    return ListView.builder(
                      itemCount: data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final booking = data![index];
                        return Container(
                          height: 170,
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                                offset: Offset.zero,
                              ),
                            ],
                            color: const Color.fromARGB(255, 249, 255, 249),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 34,
                                    backgroundImage: CachedNetworkImageProvider(
                                      "$baseUrl/${booking.office?.picture}",
                                    ),
                                  ),
                                  title: Text(
                                    "${booking.office?.name}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price: Tsh ${booking.office?.price}/ Month",
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.green,
                                          ),
                                          Text(
                                              "${booking.office?.location?.substring(0, 15)}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Status"),
                                      const SizedBox(height: 5),
                                      Text("${booking.status}"),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Text("Download Invoice"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final downloadContract =
                                          Provider.of<DownloadContract>(
                                        context,
                                        listen: false,
                                      );
                                      downloadContract.downloadContract(
                                        context,
                                        "${booking.id}",
                                      );
                                    },
                                    child: const Text("Download Contract"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
