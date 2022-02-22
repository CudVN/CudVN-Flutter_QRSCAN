import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/add_in02m.dart';
import 'package:qr_code/constance.dart';

import 'package:http/http.dart' as http;
import 'in02m_item.dart';
import 'object/xuatkho.dart';

Future<List<IN02M>> fetchIN02M(http.Client client) async {
  final response = await client.get(Uri.parse(base+'IN02M/'));
  return compute(parseIN02Ms, response.body);
}

List<IN02M> parseIN02Ms(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<IN02M>((json) => IN02M.fromJson(json)).toList();
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: FutureBuilder<List<IN02M>>(
                future: fetchIN02M(http.Client()),
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
        ),
    );
  }
}
