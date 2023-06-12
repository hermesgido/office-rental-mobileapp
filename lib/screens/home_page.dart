import 'package:flutter/material.dart';
import 'package:office_rental/screens/boooked_offfieces.dart';
import 'package:office_rental/screens/login.dart';
import 'package:office_rental/screens/office_details.dart';
import 'package:office_rental/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/office.dart';
import '../providers/office_provider.dart';
import '../utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final officeProvider = Provider.of<OfficeProvider>(context, listen: false);

    Future<void> _refreshData() async {
      await officeProvider.getOffices(forceRefresh: true, context: context);
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OfficeDetails(
                    id: '1',
                  ),
                ),
              ),
              child: const Icon(Icons.home),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              ),
              child: const Icon(Icons.bookmarks),
            ),
            label: "Offices",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BookedOffice(),
                ),
              ),
              child: const Icon(Icons.my_library_books),
            ),
            label: "Bookings",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/images/house1.jpg'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black
                        .withOpacity(0.4), // Adjust the opacity as needed
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Column(
                      children: const [
                        Text(
                          "Get Your Dream Office Today",
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Book Now",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                decoration: const BoxDecoration(),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recommended Offices",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<OfficeProvider>(
                builder: (context, provider, _) {
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: FutureBuilder<List<Office>>(
                      future: officeProvider.getOffices(
                          forceRefresh: true, context: context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              children: const [
                                Icon(Icons.warning),
                                Text("Failed to load data"),
                                Text(
                                    "Please Connect to the internet and try again")
                              ],
                            ),
                          );
                        } else {
                          return CustomScrollView(
                            primary: false,
                            slivers: <Widget>[
                              SliverPadding(
                                padding: const EdgeInsets.all(20),
                                sliver: SliverGrid.count(
                                  childAspectRatio: .7,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  children: snapshot.data?.map((office) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OfficeDetails(
                                                            id: office.id
                                                                .toString()),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "$baseUrl${office.picture!}",
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 150,
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                office.name!,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Tsh ${office.price}/ Month',
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(width: 3),
                                                ],
                                              ),
                                              Text(
                                                office.location.toString(),
                                                style: const TextStyle(),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList() ??
                                      [],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
