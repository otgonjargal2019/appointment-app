import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/api_service.dart';
import '../models/organization_type_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imageList = [
    'assets/images/rectangle_1.png',
    'assets/images/rectangle_2.png',
    'assets/images/rectangle_3.png',
  ];
  int _currentIndex = 0;
  List<OrganizationTypeModel>? organizationTypes;
  final ApiService apiService = ApiService(baseUrl: 'http://10.0.2.2:3000');

  @override
  void initState() {
    super.initState();
    fetchOrganizationTypes();
  }

  Future<void> fetchOrganizationTypes() async {
    try {
      organizationTypes = await apiService.getOrganizationTypes();
      setState(() {}); // Update the state to reflect the fetched data
    } catch (error) {
      print('Error fetching organization types: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text('Home Page'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushReplacementNamed(context, '/sign-in');
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 272,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  viewportFraction: 1.0,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: imageList.map((item) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageList.asMap().entries.map((entry) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == entry.key
                          ? Colors.white
                          : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              top: 190,
              left: 19,
              child: Text(
                '2024 Trend',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
                top: 250,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      // [
                      //   _buildLinkItem(
                      //     context,
                      //     'assets/images/hair_salon.png',
                      //     'Hair Salon',
                      //     '/organization',
                      //   ),
                      //   SizedBox(width: 20),
                      //   _buildLinkItem(
                      //     context,
                      //     'assets/images/nail_salon.png',
                      //     'Nail Salon',
                      //     '/organization',
                      //   ),
                      //   SizedBox(width: 20),
                      //   _buildLinkItem(
                      //     context,
                      //     'assets/images/beauty_salon.png',
                      //     'Beauty Salon',
                      //     '/organization',
                      //   ),
                      // ],
                      organizationTypes != null
                          ? organizationTypes!.map((organizationType) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: _buildLinkItem(
                                  context,
                                  'assets/images/${organizationType.name.toLowerCase().replaceAll(' ', '_')}.png',
                                  organizationType.name,
                                  '/organization',
                                ),
                              );
                            }).toList()
                          : [CircularProgressIndicator()],
                ))
          ],
        ));
  }

  Widget _buildLinkItem(
      BuildContext context, String imagePath, String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
