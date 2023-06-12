import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:office_rental/providers/office_provider.dart';
import 'package:office_rental/utils/constants.dart';
import 'package:provider/provider.dart';

class OfficeDetails extends StatelessWidget {
  const OfficeDetails({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<OfficeProvider>(
        builder: (context, officeProvider, child) {
          return FutureBuilder(
              future: officeProvider.getSingleOffice(id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final office = snapshot.data;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(0),
                        ),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          imageUrl: '$baseUrl${office?.picture}',
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 255),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(19),
                                topRight: Radius.circular(19))),
                        height: 500,
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Title goes here a key google",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    '${office?.location}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.price_check_outlined),
                                      Text(
                                        "Price: ${office?.price}Tsh/Month",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Size: ${office?.size} SQM",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 219, 122, 2),
                                  ),
                                  Text("Reviews (49)")
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Column(
                                children: const [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Description",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                      "Welcome to your dream home! This stunning and spacious house is now available for rent, offering the perfect blend of elegance, comfort, and modern living. Located in a peaceful residential neighborhood, this meticulously maintained property is sure to impress even the most discerning tenants. As you step inside, you'll be greeted by an inviting foyer that leads to a beautifully designed open-concept living area. The generous layout provides ample space for both entertaining and relaxation. Large windows adorn the walls, allowing natural light to flood the rooms and create a warm, welcoming ambiance.")
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final bk = Provider.of<OfficeProvider>(
                                          context,
                                          listen: false)
                                      .bookOffice(context, office?.id);
                                  // Call the bookOffice function and pass the necessary parameters
                                  print(bk);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow[700],
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                ),
                                child: const Text(
                                  'BOOK THIS OFFICE',
                                  style: TextStyle(fontSize: 18, ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 133, 97, 5),
                    ),
                  );
                }
              });
        },
      ),
    );
  }
}
