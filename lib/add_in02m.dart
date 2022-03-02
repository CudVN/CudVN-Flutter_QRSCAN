import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/constance.dart';
import 'package:qr_code/object/employee.dart';
import 'package:qr_code/object/khachhang.dart';
import 'package:qr_code/object/qr.dart';
import 'package:qr_code/object/serial.dart';
import 'package:qr_code/object/xuatkho.dart';
import 'package:qr_code/object/xuatkho_tojson.dart';
import 'package:qr_code/provider/add_qr.dart';
import 'package:qr_code/qr_scan_page.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code/widget/noti_bar.dart';
import 'package:qr_code/widget/qr_item.dart';
import 'package:uuid/uuid.dart';

class AddIN02M extends StatefulWidget {
  const AddIN02M({Key? key}) : super(key: key);

  @override
  _AddIN02MState createState() => _AddIN02MState();
}

class _AddIN02MState extends State<AddIN02M> {
  String? _mySelectionUser;
  String? _mySelectionCustomer;
  List<Employee> employees = [];
  List<Customer> customers = [];
  List<SerialView> serials = [];
  bool checkSaved = false;

  DateTime? selectedDate = DateTime.now();
  String time = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final qrTextController = TextEditingController();
  final phieuXuat = TextEditingController();
  final ghiChu = TextEditingController();
  bool? added;
  bool _validatePhieuXuat = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  //Lấy danh sách khách hàng từ db
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

  //Lấy danh sách user từ db
  Future<List<Employee>> fetchUser(http.Client client) async {
    final response = await client.get(Uri.parse(base + 'Employee/'));
    setState(() {
      employees = parseUsers(response.body);
    });
    return employees;
  }

  List<Employee> parseUsers(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  //Lưu dữ liệu khi tạo phiếu xuất kho
  Future<int> createIN02M(http.Client client, IN02M in02m) async {
    final response = await client.post(
      Uri.parse(base + 'IN02M/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },

      body: jsonEncode(in02m
          .toJson()), // jsonEncode(<String, dynamic>{'user': in02m.toJson()}),
    );

    if (response.statusCode < 200 || response.statusCode >= 400) {
      return 0; //throw Exception('Failed to create');
    } else {
      return 1; //return IN02M.fromJson(jsonDecode(response.body));
    }
  }

  //Kiểm tra danh sách serial trên db
  Future<List<SerialView>> fetchSerial(
      http.Client client, String? _serial) async {
    final uri = Uri.parse(base + 'IN02D0/GetBySeri/')
        .replace(queryParameters: {'seriNumber': _serial});
    final response = await client.get(uri);

    setState(() {
      serials = parseSerial(response.body);
    });
    return serials;
  }

  List<SerialView> parseSerial(String responseBody) {
    final parsed = jsonDecode('[$responseBody]').cast<Map<String, dynamic>>();
    return parsed.map<SerialView>((json) => SerialView.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchUser(http.Client());
    fetchCustomer(http.Client());
    phieuXuat.addListener(() {});
    ghiChu.addListener(() {});
  }

  @override
  void dispose() {
    qrTextController.dispose();
    phieuXuat.dispose();
    ghiChu.dispose();
    super.dispose();
  }

  Future<void> saveIN02M(List<QR> qrs) async {
    for (var e in qrs) {
      await fetchSerial(http.Client(), e.qrCode);
      if (serials.isNotEmpty) {
        e.isDone = true;
      }
    }
    //Nếu danh sách seri không có lỗi - Lưu dữ liệu
    if (qrs.where((e) => e.isDone == false).isEmpty && qrs.isNotEmpty) {
      List<SerialViewItem> _lstSerial = [];
      for (var e in qrs) {
        _lstSerial.add(
          SerialViewItem(
              length: 0,
              width: 0,
              height: 0,
              lotNumber: '',
              serialNumber: e.qrCode,
              crackSize: '',
              crackAcreage: 0,
              actualQty: 0),
        );
      }
      var _in02 = IN02M(
          oid: const Uuid().v4(),
          voucherNo: phieuXuat.text.toUpperCase(),
          voucherDate: selectedDate.toString(),
          remark: '',
          employeeID: _mySelectionUser,
          employeeName: employees
              .where((e) => e.oid == _mySelectionUser)
              .first
              .employeeName,
          createDate: DateTime.now().toString(),
          createBy: userName,
          remark2: 'remark2',
          customerID: _mySelectionCustomer,
          customerName: customers
              .where((e) => e.oid == _mySelectionCustomer)
              .first
              .shortName,
          seris: _lstSerial);
      createIN02M(http.Client(), _in02);
      checkSaved = true;
    } else {
      NotiBar.showSnackBar(context, 'Kiểm tra lại QR Code');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddQRCode>(context);
    final qrs = provider.qrs;
    return Scaffold(
        key: _formKey2,
        appBar: AppBar(
            backgroundColor: cPrimaryColor,
            centerTitle: true,
            title: const Text('Thêm mới'),
            actions: [
              IconButton(
                  icon: const Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    checkSaved = false;
                    setState(() {
                      phieuXuat.text.isEmpty
                          ? _validatePhieuXuat = true
                          : _validatePhieuXuat = false;
                    });
                    if (_formKey.currentState!.validate()) {
                      await saveIN02M(qrs);
                      setState(() {
                        if (checkSaved) {
                          phieuXuat.clear();
                          ghiChu.clear();
                          _mySelectionCustomer = null;
                          _mySelectionUser = null;
                          deleteAllQrCodes(context);
                          NotiBar.showSnackBar(context, 'Lưu thành công!');
                        }
                      });
                    }
                  })
            ]),
        body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.6,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: cPrimaryLightColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            validator: (value) =>
                                value == null ? 'Bắt buộc' : null,
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: cPrimaryLightColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextFormField(
                              controller: phieuXuat,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  errorText: _validatePhieuXuat
                                      ? 'Không bỏ trống'
                                      : null,
                                  hintText: 'Phiếu xuất số',
                                  border: InputBorder.none),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: cPrimaryLightColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            validator: (value) =>
                                value == null ? 'Bắt buộc' : null,
                            isExpanded: true,
                            hint: const Text('Chọn nhân viên'),
                            items: employees.map((item) {
                              return DropdownMenuItem(
                                child: Text(item.employeeName!),
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
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: cPrimaryLightColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextButton.icon(
                              icon: const Icon(Icons.calendar_month_rounded),
                              onPressed: () async {
                                selectedDate = (await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2025)));
                                setState(() {
                                  if (selectedDate != null) {
                                    time = DateFormat('dd/MM/yyyy')
                                        .format(selectedDate!);
                                  }
                                });
                              },
                              label: Text(time),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: cPrimaryLightColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextFormField(
                                controller: ghiChu,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  hintText: 'Ghi Chú',
                                  border: InputBorder.none,
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: cPrimaryLightColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextFormField(
                              controller: qrTextController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nhập mã hoặc thêm bằng QR code'),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 40,
                            child: TextButton(
                              onPressed: () {
                                insertQrCode(context, qrTextController);
                              },
                              child: const Icon(Icons.add_box),
                            )),
                        SizedBox(
                            width: 40,
                            child: TextButton(
                              onPressed: () {
                                deleteQrCodes(context);
                              },
                              child: const Icon(Icons.delete),
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
          ),
        ));
  }
}

void deleteQrCodes(BuildContext context) {
  final provider = Provider.of<AddQRCode>(context, listen: false);
  provider.removeQrCodes();
  NotiBar.showSnackBar(context, 'Đã xoá danh sách mã QR');
}

void deleteAllQrCodes(BuildContext context) {
  final provider = Provider.of<AddQRCode>(context, listen: false);
  provider.removeAllQrCodes();
  NotiBar.showSnackBar(context, 'Đã xoá danh sách mã QR');
}

void insertQrCode(
    BuildContext context, TextEditingController qrTextController) {
  final provider = Provider.of<AddQRCode>(context, listen: false);
  final foundQR =
      provider.qrs.where((element) => element.qrCode == qrTextController.text);
  if (foundQR.isEmpty && qrTextController.text.isNotEmpty) {
    final qr = QR(qrCode: qrTextController.text, isDone: false, isDel: false);
    provider.addQrCode(qr);
    qrTextController.clear();
  } else {
    NotiBar.showSnackBar(context, 'Mã này đã được thêm');
  }
}
