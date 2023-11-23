import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerDetailPage extends StatefulWidget {
  const CustomerDetailPage({Key? key}) : super(key: key);

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  late int customerId;
  Map<String, dynamic> customerData = {};
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    customerId = ModalRoute.of(context)?.settings.arguments as int;

    fetchData();
  }

  Future<void> fetchData() async {
    String apiUrl = 'https://retoolapi.dev/yZjtsj/customers/$customerId';

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          customerData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print(
            'Error fetching customer data. Status code: ${response.statusCode}');
        isLoading = false;
      }
    } catch (error) {
      print('Error fetching data: $error');
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('ID', customerData['id'].toString()),
                      _buildDivider(),
                      _buildDetailRow('Name', customerData['customer_name']),
                      _buildDivider(),
                      _buildDetailRow('Email', customerData['email']),
                      _buildDivider(),
                      _buildDetailRow('Address', customerData['address']),
                      _buildDivider(),
                      _buildDetailRow(
                          'Phone Number', customerData['phone_number']),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.0,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider();
  }
}
