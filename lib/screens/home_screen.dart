import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:usman_e_ghani/models/announcement.dart';
import 'package:usman_e_ghani/services/api_service.dart';
import 'package:usman_e_ghani/widgets/navigation_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Announcement> _announcements = [];
  bool _isLoading = false;

  Future<void> _fetchAnnouncements() async {
    setState(() => _isLoading = true);

    // Construct API URL with query parameters for from and to dates
    String apiUrl = '/announcements';
    try {
      // Perform API call to fetch announcements
      // var response = await http.get(Uri.parse(apiUrl));
      Response response = await ApiService(context).get(apiUrl);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Expenses fetched successfully
        setState(() {
          _announcements = List<Announcement>.from(
              json.decode(response.body).map((x) => Announcement.fromJson(x)));
          print(_announcements);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial expenses data when the screen is loaded
    _fetchAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Jama Masjid Usman-e-Ghani',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        drawer: DrawerNavigation(),
        body:SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: _fetchAnnouncements,
                  child: Column(
                    children: <Widget>[
                      // List of expenses
                      Expanded(
                        child: ListView.builder(
                          itemCount: _announcements.length,
                          itemBuilder: (context, index) {
                            // Build list item UI based on _announcements[index]
                            // return ListTile(
                            //   // Set title, subtitle, etc. based on _announcements[index]
                            //   title: Text(_announcements[index].title),
                            //   subtitle: Text(_announcements[index].description),
                            // );
                            return CustomCard(
                                title: _announcements[index].title,
                                description: _announcements[index].description);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String description;

  CustomCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            height: 8.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
              color: Colors.lightBlueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
