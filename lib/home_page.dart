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
    http.Client client, String fDate, String tDate, String vID) async {
  final uri = Uri.parse(base + 'IN02M/GetByDate/')
      .replace(queryParameters: {'fDate': fDate, 'tDate': tDate, 'VID' : vID});
  final response = await client.get(uri);
  return compute(parseIN02Ms, response.body);
}

List<IN02M> parseIN02Ms(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<IN02M>((json) => IN02M.fromJson(json)).toList();
}

class MyHomePage extends StatefulWidget {
  final String vID;
  const MyHomePage({
    Key? key,
    required this.title,
    required this.vID,
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
        ),
        backgroundColor: cPrimaryColor,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddIN02M(vID: widget.vID,)));
                setState(() {
                  isLoad = true;
                });
              })
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: cPrimaryLightColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: TextButton.icon(
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: Text(DateFormat('dd-MM-yyyy').format(fDate)),
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
                  ),
                ),
                const SizedBox(
                    width: 30,
                    child: Text(
                      '-',
                      textAlign: TextAlign.center,
                    )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: cPrimaryLightColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: TextButton.icon(
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: Text(DateFormat('dd-MM-yyyy').format(tDate)),
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
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: cPrimaryLightColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoad = true;
                        });
                      },
                      child: const Icon(
                        Icons.search,
                      )),
                ),
              ],
            ),
          ),
          Expanded(
              child: Center(
            child: isLoad
                ? FutureBuilder<List<IN02M>>(
                    future: fetchIN02M(
                        http.Client(),
                        DateFormat('MM-dd-yyyy').format(fDate),
                        DateFormat('MM-dd-yyyy').format(tDate),
                        widget.vID),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Kh??ng c?? d??? li???u');
                      } else if (snapshot.hasData) {
                        return IN02MList(
                          vID: widget.vID,
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
