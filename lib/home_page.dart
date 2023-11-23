import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> customers = [];
  int page = 1;
  int limit = 10;
  bool isLoading = false;
  bool isSearchLoading = false;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    String url =
        'https://retoolapi.dev/yZjtsj/customers?_page=$page&_limit=$limit';

    try {
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);

      setState(() {
        customers.addAll(data);
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> seachData() async {
    setState(() {
      isSearchLoading = true;
      isSearchActive = true;
    });

    String customerName = searchController.text;
    String url =
        'https://retoolapi.dev/yZjtsj/customers?customer_name=$customerName';

    try {
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);

      setState(() {
        customers.clear();
        customers.addAll(data);
        isSearchLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isSearchLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pelanggan'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'Cari berdasarkan nama',
                  ),
                ),
              ),
              ElevatedButton(onPressed: seachData, child: const Text("Cari")),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isSearchActive = false;
                    page = 1;
                    fetchData();
                  });
                },
                child: const Text("LoadSemua"))
            ],
          ),
          Expanded(
            child: isSearchActive
                ? ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(customers[index]['customer_name']),
                          subtitle: Text(customers[index]['email']),
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              '/customerDetail',
                              arguments: customers[index]['id'],
                            );
                          }
                        );
                    },
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          customers.isNotEmpty) {
                        setState(() {
                          page++;
                        });
                        fetchData();
                      }
                      return true;
                    },
                    child: ListView.builder(
                      itemCount: customers.length + 1,
                      itemBuilder: (context, index) {
                        if (index == customers.length) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return ListTile(
                              title: Text(customers[index]['customer_name']),
                              subtitle: Text(customers[index]['email']),
                              onTap: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/customerDetail',
                                  arguments: customers[index]['id'],
                                );
                              }
                            );
                        }
                      },
                    ),
                  ),
          ),
        ],
      )
    );
  }
}
