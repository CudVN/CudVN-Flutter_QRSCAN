import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/add_in02m.dart';
import 'package:qr_code/constance.dart';

import 'package:http/http.dart' as http;
import 'in02m_item.dart';
import 'object/xuatkho.dart';

Future<List<IN02M>> fetchIN02M(
    http.Client client, String fDate, String tDate) async {
  final uri = Uri.parse(base + 'IN02M/GetByDate/')
      .replace(queryParameters: {'fDate': fDate, 'tDate': tDate});
  final response = await client.get(uri);
  return compute(parseIN02Ms, response.body);
}

List<IN02M> parseIN02Ms(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<IN02M>((json) => IN02M.fromJson(json)).toList();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? selectedTDate;
  DateTime fDate = DateTime.now();
  DateTime? selectedFDate;
  DateTime tDate = DateTime.now();
  bool isLoad = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 228, 219),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddIN02M()));
              })
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 40,
                child: TextButton(
                  onPressed: () async {
                    isLoad = false;
                    selectedFDate = (await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2025)));
                    setState(() {
                      if (selectedFDate != null) {
                        fDate = selectedFDate!;
                      }
                    });
                  },
                  child: const Icon(Icons.calendar_month_rounded),
                ),
              ),
              Text(DateFormat('dd-MM-yyyy').format(fDate)),
              const SizedBox(
                  width: 30,
                  child: Text(
                    '-',
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                width: 40,
                child: TextButton(
                  onPressed: () async {
                    isLoad = false;
                    selectedTDate = (await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2025)));
                    setState(() {
                      if (selectedTDate != null) {
                        tDate = selectedTDate!;
                      }
                    });
                  },
                  child: const Icon(Icons.calendar_month_rounded),
                ),
              ),
              Text(DateFormat('dd-MM-yyyy').format(tDate)),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isLoad = true;
                    });
                  },
                  child: const Icon(
                    Icons.search,
                  )),
            ],
          ),
          Expanded(
              child: Center(
            child: isLoad
                ? FutureBuilder<List<IN02M>>(
                    future: fetchIN02M(
                        http.Client(),
                        DateFormat('MM-dd-yyyy').format(fDate),
                        DateFormat('MM-dd-yyyy').format(tDate)),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Không có dữ liệu');
                      } else if (snapshot.hasData) {
                        return IN02MList(
                          in02ms: snapshot.data!,
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })
                : Container(),
          ))
        ],
      ),
    );
  }
}
