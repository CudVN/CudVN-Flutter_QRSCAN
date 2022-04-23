import 'package:flutter/material.dart';
import 'package:qr_code/constance.dart';
import 'package:qr_code/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('DANH MỤC'),
      centerTitle: true,
      backgroundColor: cPrimaryColor,),      
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,      
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.7,
                height: size.height * 0.18,
                child: ClipRRect(
               borderRadius: BorderRadius.circular(29),
               child: TextButton(
                   style: TextButton.styleFrom(
                       backgroundColor: cPrimaryColor,
                       padding: const EdgeInsets.symmetric(
                           horizontal: 40, vertical: 20)),
                   onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => const MyHomePage(title: 'XUẤT BÁN',vID: vIDXuatBan,)),
                      (Route<dynamic> route) => true);
                   },
                   child: const Text(
                     'XUẤT BÁN',
                     style: TextStyle(color: Colors.white, fontSize: 30),
                   )),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.7,
                height: size.height * 0.18,
                child: ClipRRect(
               borderRadius: BorderRadius.circular(29),
               child: TextButton(
                   style: TextButton.styleFrom(
                       backgroundColor: cPrimaryLightColor2,
                       padding: const EdgeInsets.symmetric(
                           horizontal: 20, vertical: 20)),
                   onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>const MyHomePage(title: 'XUẤT SẢN XUẤT', vID: vIDXuatSX,)),
                      (Route<dynamic> route) => true);
                   },
                   child: const Text(
                     'XUẤT SẢN XUẤT',
                     style: TextStyle(color: cPrimaryColor, fontSize: 30),
                   )),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.7,
                height: size.height * 0.18,
                child: ClipRRect(
               borderRadius: BorderRadius.circular(29),
               child: TextButton(
                   style: TextButton.styleFrom(
                       backgroundColor: cPrimaryColor,
                       padding: const EdgeInsets.symmetric(
                           horizontal: 40, vertical: 20)),
                   onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => const MyHomePage(title: 'CHUYỂN KHO',vID: vIDChuyenKho,)),
                      (Route<dynamic> route) => false);
                   },
                   child: const Text(
                     'CHUYỂN KHO',
                     style: TextStyle(color: Colors.white, fontSize: 30),
                   )),
                ),
              ),
            ],
          ),
        ),
      ),      
    );
  }
}