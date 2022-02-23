import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/constance.dart';
import 'package:qr_code/object/khachhang.dart';
import 'package:qr_code/object/nhanvien.dart';
import 'package:qr_code/object/qr.dart';
import 'package:qr_code/provider/add_qr.dart';
import 'package:qr_code/qr_scan_page.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code/widget/noti_bar.dart';
import 'package:qr_code/widget/qr_item.dart';

class AddIN02M extends StatefulWidget {
  const AddIN02M({Key? key}) : super(key: key);

  @override
  _AddIN02MState createState() => _AddIN02MState();
}

class _AddIN02MState extends State<AddIN02M> {
  String? _mySelectionUser;
  String? _mySelectionCustomer;
  List<User> users = [];
  List<Customer> customers = [];
  DateTime? selectedDate;
  String time = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final qrTextController = TextEditingController();
  bool? added;

  Future<List<Customer>> fetchCustomer(http.Client client) async {
    final response = await client.get(Uri.parse(base + 'Customer/'));
    setState(() {
      customers = parseCustomers(response.body);
    });
    return customers;
  }

  List<Customer> parseCustomers(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
  }

  Future<List<User>> fetchUser(http.Client client) async {
    final response = await client.get(Uri.parse(base + 'User/'));
    setState(() {
      users = parseUsers(response.body);
    });
    return users;
  }

  List<User> parseUsers(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchUser(http.Client());
    fetchCustomer(http.Client());
  }

  @override
  void dispose() {
    qrTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddQRCode>(context);
    final qrs = provider.qrs;
    return Scaffold(
        appBar: AppBar(title: const Text('Thêm mới'), actions: [
          IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {})
        ]),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.6,
                    child: DropdownButton(
                      isExpanded: true,
                      hint: const Text('Chọn khách hàng'),
                      items: customers.map((item) {
                        return DropdownMenuItem(
                          child: Text(item.shortName!),
                          value: item.oid,
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _mySelectionCustomer = newVal.toString();
                        });
                      },
                      value: _mySelectionCustomer,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                          hintText: 'Phiếu xuất số', border: InputBorder.none),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: DropdownButton(
                      hint: const Text('Chọn nhân viên'),
                      items: users.map((item) {
                        return DropdownMenuItem(
                          child: Text(item.fullName!),
                          value: item.oid,
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _mySelectionUser = newVal.toString();
                        });
                      },
                      value: _mySelectionUser,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      selectedDate = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2025)));
                      setState(() {
                        if (selectedDate != null) {
                          time = DateFormat('dd/MM/yyyy').format(selectedDate!);
                        }
                      });
                    },
                    child: const Icon(Icons.calendar_month_rounded),
                  ),
                  Expanded(child: Text(time)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Ghi Chú',
                        )),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: qrTextController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                          hintText: 'Nhập mã hoặc thêm bằng QR code'),
                    ),
                  ),
                  SizedBox(
                      width: 40,
                      child: TextButton(
                        onPressed: () {
                          final provider =
                              Provider.of<AddQRCode>(context, listen: false);
                          final foundQR = provider.qrs.where((element) =>
                              element.qrCode == qrTextController.text);
                          if (foundQR.isEmpty) {
                            final qr = QR(
                                qrCode: qrTextController.text, isDone: false);
                            provider.addQrCode(qr);
                            qrTextController.clear();
                          } else {
                            NotiBar.showSnackBar(
                                context, 'Mã này đã được thêm');
                          }
                        },
                        child: const Icon(Icons.add_box),
                      )),
                  SizedBox(
                      width: 40,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QRScan()));
                        },
                        child: const Icon(Icons.qr_code_2),
                      )),
                ],
              ),
              Expanded(
                child: qrs.isEmpty
                    ? const Center(
                        child: Text('Không có dữ liệu'),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(2),
                        separatorBuilder: (context, index) => Container(
                              height: 2,
                            ),
                        itemCount: qrs.length,
                        itemBuilder: (context, index) {
                          final qr = qrs[index];
                          return QrItem(qr: qr);
                        }),
              )
            ]),
          ),
        ));
  }
}