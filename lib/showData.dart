import 'package:farmcast_app/data/reading_class.dart';
import 'package:farmcast_app/widgets/bottomNav.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter/material.dart';

class ReadingScreen extends StatefulWidget {
  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  int selectedIndex = 2;
  late mongo.Db db;
  late mongo.DbCollection collection;
  Reading? mostRecentReading;

  @override
  void initState() {
    super.initState();
    fetchMostRecentReading();
    // Start the periodic data fetching
    startPeriodicFetching();
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  Future<void> fetchMostRecentReading() async {
    try {
      // Connect to the database
      db = mongo.Db(
          'mongodb://codeswithroh:codeswithroh@cluster0-shard-00-00.frga0.mongodb.net:27017,cluster0-shard-00-01.frga0.mongodb.net:27017,cluster0-shard-00-02.frga0.mongodb.net:27017/FarmCast?ssl=true&replicaSet=atlas-xxxx-shard-0&authSource=admin&retryWrites=true&w=majority');
      await db.open();
      collection = db.collection('readings');

      // Find the latest document
      var latestDoc =
          await collection.findOne(mongo.where.sortBy('_id', descending: true));

      if (latestDoc != null) {
        setState(() {
          mostRecentReading = Reading.fromJson(latestDoc);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void startPeriodicFetching() async {
    while (mounted) {
      // Wait for 10 seconds
      await Future.delayed(const Duration(seconds: 10));
      // Fetch data again
      await fetchMostRecentReading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6F8D6),
      appBar: AppBar(
        backgroundColor: Color(0xFFD6F8D6),
        title: const Text('farmcast'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      body: mostRecentReading == null
          ? Center(child: CircularProgressIndicator())
          : ReadingCard(reading: mostRecentReading!),
      bottomNavigationBar: BottomNav(selectedIndex: selectedIndex),
    );
  }
}

class ReadingCard extends StatelessWidget {
  final Reading reading;

  ReadingCard({required this.reading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _buildReadingCard(Icons.thermostat, 'Temperature',
                      '${reading.temperatureDHT}°C', Colors.orange)),
              Expanded(
                  child: _buildReadingCard(Icons.water_drop, 'Humidity',
                      '${reading.humidity}%', Colors.blue)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildReadingCard(Icons.speed, 'Pressure',
                      '${reading.pressure} hPa', Colors.purple)),
              Expanded(
                  child: _buildReadingCard(Icons.air, 'Air Quality',
                      '${reading.airQuality}', Colors.green)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildReadingCard(Icons.grass, 'Soil Moisture',
                      '${reading.soilMoisture}', Colors.brown)),
              Expanded(
                  child: _buildReadingCard(Icons.cloud_queue, 'Is Raining',
                      '${reading.isRaining ? 'Yes' : 'No'}', Colors.grey)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildReadingCard(Icons.opacity, 'Rainfall',
                      '${reading.rainfall} mm', Colors.lightBlue)),
              Expanded(
                  child: _buildReadingCard(Icons.explore, 'Wind Direction',
                      reading.windDirection, Colors.blueGrey)),
            ],
          ),
          SizedBox(height: 12),
          _buildReadingCard(Icons.air_sharp, 'Wind Speed',
              '${reading.windSpeed} m/s', Colors.teal,
              isFullWidth: true),
        ],
      ),
    );
  }

  Widget _buildReadingCard(
      IconData icon, String title, String value, Color color,
      {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: color),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
