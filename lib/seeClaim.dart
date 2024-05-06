import 'dart:convert';

import 'package:farmcast_app/widgets/bottomNav.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SeeClaim extends StatefulWidget {
  @override
  _SeeClaim createState() => _SeeClaim();
}

class _SeeClaim extends State<SeeClaim> {
  int _selectedTabIndex = 1;

  late Future<List<Map<String, dynamic>>> _pendingClaims;
  late Future<List<Map<String, dynamic>>> _approvedClaims;
  late Future<List<Map<String, dynamic>>> _rejectedClaims;

  @override
  void initState() {
    super.initState();
    _pendingClaims = _fetchClaims('PENDING');
    _approvedClaims = _fetchClaims('APPROVED');
    _rejectedClaims = _fetchClaims('REJECTED');
  }

  Future<List<Map<String, dynamic>>> _fetchClaims(String status) async {
    final response = await http.get(Uri.parse(
        'https://farmcast-api.onrender.com/api/v1/claim?status=$status'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load claims');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFFD6F8D6),
        appBar: AppBar(
          backgroundColor: Color(0xFFD6F8D6),
          title: Text('Farmcast'),
          leading: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(
              Icons.agriculture,
              size: 40,
              color: Color(0xFF55505C),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildClaimsList(_pendingClaims),
            _buildClaimsList(_approvedClaims),
            _buildClaimsList(_rejectedClaims),
          ],
        ),
        bottomNavigationBar: BottomNav(selectedIndex: _selectedTabIndex),
      ),
    );
  }

  Widget _buildClaimsList(Future<List<Map<String, dynamic>>> claims) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: claims,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No claims found',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
        } else {
          final claims = snapshot.data!;
          return ListView.builder(
            itemCount: claims.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  color: Color(0xFF7FC6A4),
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason: ${claims[index]['reason']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'From Date: ${_formatDate(claims[index]['fromTime'])}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'To Date: ${_formatDate(claims[index]['toTime'])}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  String _formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    return '${date.day}-${date.month}-${date.year}';
  }
}
