import 'package:farmcast_app/widgets/bottomNav.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClaimForm extends StatefulWidget {
  const ClaimForm({Key? key}) : super(key: key);
  @override
  _ClaimFormState createState() => _ClaimFormState();
}

class _ClaimFormState extends State<ClaimForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> reasons = [
    "RAIN",
    "DROUGHT",
    "STORM",
    "FLOOD",
    "HAIL",
    "FIRE",
    "OTHERS"
  ];
  String _fromDate = '';
  String _toDate = '';
  String _selectedReason = '';
  int selectedIndex = 0;

  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6F8D6),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hi, Rohit Purkait',
                  style: TextStyle(
                    color: Color(0xFF55505C),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Claim what you owe',
                  style: TextStyle(
                    color: Color(0xFF55505C),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _fromDateController,
                        decoration: InputDecoration(
                          hintText: 'Enter the from date',
                          labelText: 'From Date',
                          labelStyle: TextStyle(color: Color(0xFF55505C)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFF55505C)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFF55505C)),
                          ),
                          suffixIcon: Icon(Icons.calendar_today),
                          filled: true,
                          fillColor: Color(0xFF7FC6A4),
                        ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (picked != null) {
                            setState(() {
                              _fromDate = picked.toString();
                              _fromDateController.text =
                                  _fromDate.split(' ')[0];
                            });
                          }
                        },
                        readOnly: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter from date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _toDateController,
                        decoration: InputDecoration(
                          labelText: "To Date",
                          suffixIcon: Icon(Icons.calendar_today),
                          filled: true,
                          fillColor: Color(0xFF7FC6A4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFF55505C)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFF55505C)),
                          ),
                        ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (picked != null) {
                            setState(() {
                              _toDate = picked.toString();
                              _toDateController.text = _toDate.split(' ')[0];
                            });
                          }
                        },
                        readOnly: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter to date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Reason',
                          labelStyle: TextStyle(color: Color(0xFF55505C)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFF55505C)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFF55505C)),
                          ),
                          filled: true,
                          fillColor: Color(0xFF7FC6A4),
                        ),
                        value:
                            _selectedReason.isNotEmpty ? _selectedReason : null,
                        items: reasons.map((reason) {
                          return DropdownMenuItem(
                              child: Text(reason), value: reason);
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedReason = newValue.toString();
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a reason';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submitClaim();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF55505C)),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                          child: Text(
                            'Submit Claim',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(selectedIndex: selectedIndex),
    );
  }

  void _submitClaim() async {
    DateTime parsedFromDate = DateTime.parse(_fromDate);
    DateTime parsedToDate = DateTime.parse(_toDate);

    String isoFromDate = parsedFromDate.toIso8601String();
    String isoToDate = parsedToDate.toIso8601String();

    final url = Uri.parse('https://farmcast-api.onrender.com/api/v1/claim');
    final response = await http.post(url, body: {
      'fromTime': isoFromDate,
      'toTime': isoToDate,
      'reason': _selectedReason,
      'user': '663629e5ac04a8da08a52da5'
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Claim submitted successfully')));

      _formKey.currentState!.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit claim')));
    }
  }
}
