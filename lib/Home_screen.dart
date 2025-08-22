import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      //final response = await http.get(Uri.parse('http://10.0.2.2:5000/get_questions_data'));
      final response = await http.get(Uri.parse('http://192.168.100.11:5000/get_questions_data'));
      if (response.statusCode == 200) {
        setState(() {
          questions = json.decode(response.body);
          isLoading = false;
        });
      } else {
        // Handle server errors
        print('Failed to load questions: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching questions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // gradient shows behind AppBar
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            height: 260, // Adjusted height of gradient section
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF7043), // Orange
                  Color(0xFFFFA726), // Lighter Orange
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40), // round bottom-left
                bottomRight: Radius.circular(40), // round bottom-right
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top:10 ), // Adjusted top padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Text(
                        "Trendy Stack",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        "Hi,Stay ahead with the latest and trending questions from Stack "
                            "Overflow. Learn, explore, and get inspired by what developers "
                            "around the world are solving — all in one stylish and minimal app. ",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 17,
                          height: 1.5,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade, // Use fade for overflow
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero, // Remove default ListView padding
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shadowColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final url = Uri.parse(question['Link']); // your API link
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.inAppWebView);
                            } else {
                              print("Could not launch $url");
                            }
                          },
                          child: Text(
                            question['Title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  question['Views'] ?? '0',
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold,color: Colors.orange),
                                ),
                                const Text('Views', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  question['Answers'] ?? '0',
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold,color: Colors.orange),
                                ),
                                const Text('Answers', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  question['Votes'] ?? '0',
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold,color: Colors.orange),
                                ),
                                const Text('Votes', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          children: (question['Tags'] as List<dynamic>?)
                              ?.map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.orange.shade200,
                            labelStyle: const TextStyle(color: Colors.black),
                          ))
                              .toList() ??
                              [],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
